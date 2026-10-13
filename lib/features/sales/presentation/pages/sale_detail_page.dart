import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/utils/invoice_pdf.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/app_section_card.dart';

/// Read-only sales invoice details — amounts shown in the invoice's ORIGINAL
/// transaction currency (stored in base + exchangeRate; converted for display).
class SaleDetailPage extends ConsumerWidget {
  const SaleDetailPage({required this.sale, super.key});

  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    // Amounts are stored in base; show them in the original transaction currency.
    final foreign = sale.originalCurrencyId.isNotEmpty;
    final code = foreign
        ? (currencies
                .where((c) => c.id == sale.originalCurrencyId)
                .map((c) => c.code)
                .firstOrNull ??
            sale.currencyCode)
        : sale.currencyCode;
    final rate = foreign ? sale.exchangeRate : 1.0;
    String money(double base) => Formatters.money(base * rate, code);

    // الكلفة والربح (بالعملة الأساسية ثم تُعرض بعملة المعاملة).
    final totalCost =
        sale.items.fold<double>(0, (s, l) => s + l.unitCost * l.quantity);
    // الإيراد = مجموع الأسطر.
    final revenue = sale.items.fold<double>(0, (s, l) => s + l.subTotal);
    final profit = revenue - totalCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.saleDetails),
        actions: [
          const TutorialHelpButton(TutorialTopic.afterSale),
          IconButton(
            tooltip: AppStrings.exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => shareInvoicePdf(
              sale,
              pharmacyName: ref.read(pharmacyNameProvider).value ?? '',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppSectionCard(
            title: money(sale.totalAmount),
            icon: Icons.receipt_long_outlined,
            child: Column(
              children: [
                _row(theme, AppStrings.invoiceLabel, '#${sale.invoiceNumber}'),
                _row(theme, AppStrings.paymentMethod, sale.paymentMethod.label),
                _row(theme, AppStrings.dateColumn, AppDate.ymdHm(sale.saleDate)),
                _row(theme, AppStrings.costLabel, money(totalCost)),
                _row(theme, AppStrings.profitLabel, money(profit),
                    valueColor: profit >= 0
                        ? Colors.green.shade700
                        : Colors.red.shade700),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSectionCard(
            title: AppStrings.units,
            icon: Icons.medication_outlined,
            child: Column(
              children: [
                for (final line in sale.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(line.medicineName,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                                '${line.unitName}  •  '
                                '${Formatters.qty(line.quantity)} × ${money(line.individual)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          money(line.subTotal),
                          style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value, {Color? valueColor}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ),
            Expanded(
              child: Text(value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: valueColor,
                      fontWeight:
                          valueColor != null ? FontWeight.bold : null)),
            ),
          ],
        ),
      );
}
