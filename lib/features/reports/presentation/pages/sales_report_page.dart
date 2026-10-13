import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_grid.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Sales report — a tree grid only (no page stats): each parent row is an
/// invoice (number, date, customer, total + profit); expanding it shows its
/// line items. Filtered by the period selector. Profit (green) / loss (red).
class SalesReportPage extends ConsumerStatefulWidget {
  const SalesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends ConsumerState<SalesReportPage> {
  late ReportPeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(salesGridProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.salesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.invalidate(
          salesGridProvider(_period.startUtcIso, _period.endUtcIso)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(
              salesGridProvider(_period.startUtcIso, _period.endUtcIso)),
        ),
        data: (rows) => _content(context, rows),
      ),
    );
  }

  Widget _content(BuildContext context, List<SalesGridInvoice> rows) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [for (final inv in rows) _invoiceItem(context, inv)],
        ),
      ],
    );
  }

  ReportItem _invoiceItem(BuildContext context, SalesGridInvoice inv) {
    final sym = _symbol(inv.currencySymbol, inv.currencyCode);
    final profitColor =
        inv.profit >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    final fields = <ReportField>[
      ReportField(AppStrings.paymentMethod, _payLabel(inv.paymentMethod)),
      ReportField(AppStrings.profitLabel, Formatters.money(inv.profit, sym),
          color: profitColor),
      ReportField(AppStrings.marginLabel, '${Formatters.number(inv.profitMargin)}%',
          color: profitColor),
      ReportField(AppStrings.costShort, Formatters.money(inv.cost, sym)),
      if (inv.discountAmount > 0)
        ReportField(
            AppStrings.discountShort, Formatters.money(inv.discountAmount, sym)),
      if (inv.warehouseName.isNotEmpty)
        ReportField(AppStrings.warehouseColumn, inv.warehouseName),
      if (inv.originalCurrencyCode.isNotEmpty &&
          inv.originalCurrencyCode != inv.currencyCode)
        ReportField(AppStrings.exchangeRateLabel,
            '${inv.originalCurrencyCode} × ${Formatters.number(inv.originalExchangeRate)}'),
      if (inv.costMissing) const ReportField(AppStrings.estimatedCost, '•'),
    ];

    return ReportItem(
      title: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}',
      subtitle: '${_ymd(inv.saleDate)} · '
          '${inv.customerName.isNotEmpty ? inv.customerName : AppStrings.cashSale}',
      trailing: Formatters.money(inv.totalAmount, sym),
      trailingCaption: Formatters.money(inv.profit, sym),
      trailingColor: null,
      accentColor: inv.costMissing ? Colors.orange.shade600 : null,
      fields: fields,
      children: [for (final line in inv.items) _lineItem(line, sym)],
    );
  }

  ReportItem _lineItem(SalesGridItem line, String? sym) {
    final profitColor =
        line.lineProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    final unit = line.unitName.isNotEmpty ? ' ${line.unitName}' : '';
    return ReportItem(
      title: line.brandName,
      subtitle: '${Formatters.qty(line.quantity)}$unit × '
          '${Formatters.number(line.unitPrice)}'
          '${line.discount > 0 ? ' − ${Formatters.number(line.discount)}' : ''}'
          ' · ${AppStrings.profitLabel}: ${Formatters.money(line.lineProfit, sym)}',
      trailing: Formatters.money(line.subTotal, sym),
      trailingColor: profitColor,
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
