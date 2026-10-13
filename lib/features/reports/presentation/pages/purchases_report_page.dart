import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_grid.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Purchases report — a tree grid only (no page stats): each parent row is a
/// purchase invoice (number, date, supplier, total); expanding it shows its
/// line items (medicine, qty × price, batch, expiry). Filtered by the period.
class PurchasesReportPage extends ConsumerStatefulWidget {
  const PurchasesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<PurchasesReportPage> createState() =>
      _PurchasesReportPageState();
}

class _PurchasesReportPageState extends ConsumerState<PurchasesReportPage> {
  late ReportPeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(purchasesGridProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.purchasesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.invalidate(
          purchasesGridProvider(_period.startUtcIso, _period.endUtcIso)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(
              purchasesGridProvider(_period.startUtcIso, _period.endUtcIso)),
        ),
        data: (rows) => _content(context, rows),
      ),
    );
  }

  Widget _content(BuildContext context, List<PurchasesGridInvoice> rows) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [for (final inv in rows) _invoiceItem(inv)],
        ),
      ],
    );
  }

  ReportItem _invoiceItem(PurchasesGridInvoice inv) {
    final sym = _symbol(inv.currencySymbol, inv.currencyCode);
    final fields = <ReportField>[
      ReportField(AppStrings.paymentMethod, _payLabel(inv.paymentMethod)),
      ReportField(AppStrings.quantity, Formatters.integer(inv.itemsCount)),
      if (inv.discountAmount > 0)
        ReportField(
            AppStrings.discountShort, Formatters.money(inv.discountAmount, sym)),
      if (inv.warehouseName.isNotEmpty)
        ReportField(AppStrings.warehouseColumn, inv.warehouseName),
    ];

    return ReportItem(
      title: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}',
      subtitle: '${_ymd(inv.purchaseDate)} · '
          '${inv.supplierName.isNotEmpty ? inv.supplierName : AppStrings.supplier}',
      trailing: Formatters.money(inv.totalAmount, sym),
      fields: fields,
      children: [for (final line in inv.items) _lineItem(line, sym)],
    );
  }

  ReportItem _lineItem(PurchasesGridItem line, String? sym) {
    final unit = line.unitName.isNotEmpty ? ' ${line.unitName}' : '';
    final batch =
        line.batchNumber.isNotEmpty ? ' · ${AppStrings.batchLabel}: ${line.batchNumber}' : '';
    final expiry =
        line.expiryDate != null ? ' · ${AppStrings.expiry}: ${_ymd(line.expiryDate!)}' : '';
    return ReportItem(
      title: line.brandName,
      subtitle: '${Formatters.qty(line.quantity)}$unit × '
          '${Formatters.number(line.unitPrice)}'
          '${line.discount > 0 ? ' − ${Formatters.number(line.discount)}' : ''}'
          '$batch$expiry',
      trailing: Formatters.money(line.subTotal, sym),
    );
  }

  static String? _symbol(String symbol, String code) =>
      symbol.isNotEmpty ? symbol : (code.isNotEmpty ? code : null);

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _payLabel(int method) {
    switch (method) {
      case 1:
        return AppStrings.payCash;
      case 2:
        return AppStrings.payCreditCard;
      case 3:
        return AppStrings.payDebitCard;
      case 4:
        return AppStrings.payBankTransfer;
      case 5:
        return AppStrings.payMobileWallet;
      default:
        return '—';
    }
  }
}
