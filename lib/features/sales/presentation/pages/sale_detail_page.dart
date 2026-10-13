import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/utils/invoice_pdf.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// Read-only sales invoice details — the project-standard layout: a stat-chips
/// strip (total / cost / profit / payment / date) over a full-height grid of
/// the line items. Amounts shown in the invoice's ORIGINAL currency.
class SaleDetailPage extends ConsumerWidget {
  const SaleDetailPage({required this.sale, super.key});

  final Sale sale;

  static const _fName = 'name';
  static const _fUnit = 'unit';
  static const _fUnitPrice = 'unitPrice';
  static const _fQty = 'qty';
  static const _fTotal = 'total';

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
    final revenue = sale.items.fold<double>(0, (s, l) => s + l.subTotal);
    final profit = revenue - totalCost;
    final profitColor =
        profit >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.saleDetails} — #${sale.invoiceNumber}'),
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatChipsBar(chips: [
              StatChip(
                label: AppStrings.total,
                value: money(sale.totalAmount),
                icon: Icons.receipt_long_outlined,
              ),
              StatChip(
                label: AppStrings.profitLabel,
                value: money(profit),
                icon: Icons.trending_up_outlined,
                color: profitColor,
              ),
              StatChip(
                label: AppStrings.costLabel,
                value: money(totalCost),
                icon: Icons.shopping_bag_outlined,
                color: theme.colorScheme.secondary,
              ),
              StatChip(
                label: AppStrings.paymentMethod,
                value: sale.paymentMethod.label,
                icon: Icons.account_balance_wallet_outlined,
              ),
              StatChip(
                label: AppStrings.dateColumn,
                value: AppDate.ymdHm(sale.saleDate),
                icon: Icons.event_outlined,
              ),
            ]),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AppGrid(
                columns: [
                  appGridTextColumn(AppStrings.medicineName, _fName,
                      width: 240),
                  appGridTextColumn(AppStrings.unitLabel, _fUnit, width: 110),
                  appGridNumberColumn(AppStrings.unitPriceColumn, _fUnitPrice,
                      width: 110),
                  appGridNumberColumn(AppStrings.piecesCountColumn, _fQty,
                      width: 100),
                  appGridNumberColumn(AppStrings.total, _fTotal, width: 120,
                      renderer: (ctx) {
                    final v = ctx.cell.value;
                    final n = v is num ? v.toDouble() : 0.0;
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        Formatters.number(n),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ],
                rows: [
                  for (final line in sale.items)
                    TrinaRow(cells: {
                      _fName: TrinaCell(value: line.medicineName),
                      _fUnit: TrinaCell(value: line.unitName),
                      _fUnitPrice: TrinaCell(value: line.individual * rate),
                      _fQty: TrinaCell(value: line.quantity),
                      _fTotal: TrinaCell(value: line.subTotal * rate),
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
