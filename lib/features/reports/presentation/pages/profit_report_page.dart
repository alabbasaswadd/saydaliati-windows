import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Profit report: per-invoice profit + totals. Defaults to today (opened from
/// the sales page header). All amounts are stored in the base currency; the
/// currency selector is a DISPLAY currency — picking one converts every figure
/// (totals + each invoice) into it. Period from the side sheet.
class ProfitReportPage extends ConsumerStatefulWidget {
  const ProfitReportPage({this.initialPeriod, super.key});

  final ReportPeriod? initialPeriod;

  @override
  ConsumerState<ProfitReportPage> createState() => _ProfitReportPageState();
}

class _ProfitReportPageState extends ConsumerState<ProfitReportPage> {
  late ReportPeriod _period = widget.initialPeriod ?? ReportPeriod.today();
  String? _displayCurrencyId; // null => base currency

  /// مدير الشبكة — لزر إظهار/إخفاء الأعمدة.
  TrinaGridStateManager? _gridManager;

  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fPayment = 'payment';
  static const _fRevenue = 'revenue';
  static const _fCost = 'cost';
  static const _fProfit = 'profit';
  static const _fOriginal = 'original';

  @override
  Widget build(BuildContext context) {
    final base = ref.watch(baseCurrencyProvider);
    final currencies =
        ref.watch(currenciesProvider).value ?? const <Currency>[];
    // Always fetch ALL invoices (stored in base); conversion is for display.
    final async = ref.watch(
        profitReportProvider(_period.startUtcIso, _period.endUtcIso, null));
    final targetId = _displayCurrencyId ?? base?.id;

    return ReportScaffold(
      title: AppStrings.profitReportTitle,
      actions: const [TutorialHelpButton(TutorialTopic.profitReport)],
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.refresh(profitReportProvider(
              _period.startUtcIso, _period.endUtcIso, null)
          .future),
      endDrawerExtra: [
        if (currencies.isNotEmpty)
          AppDropdown<String>(
            label: AppStrings.displayCurrency,
            value: targetId,
            items: [
              for (final c in currencies)
                AppDropdownItem(value: c.id, label: c.code),
            ],
            onChanged: (v) => setState(() => _displayCurrencyId = v),
          ),
      ],
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(profitReportProvider(
              _period.startUtcIso, _period.endUtcIso, null)),
        ),
        data: (r) => _content(context, r, base, currencies),
      ),
    );
  }

  Widget _content(BuildContext context, ProfitReport r, Currency? base,
      List<Currency> currencies) {
    final target =
        currencies.where((c) => c.id == (_displayCurrencyId ?? base?.id)).firstOrNull ??
            base;
    final code = target?.code ?? '';
    double conv(double v) => convertFromBase(v, base, target);
    Color profitColor(double v) =>
        v >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    if (r.invoices.isEmpty) {
      return const EmptyState(
        icon: Icons.trending_up_outlined,
        message: AppStrings.noDataForPeriod,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatChipsBar(chips: [
                  StatChip(
                    label: AppStrings.profitShort,
                    value: Formatters.money(conv(r.totalProfit), code),
                    icon: Icons.trending_up_outlined,
                    color: profitColor(r.totalProfit),
                  ),
                  StatChip(
                    label: AppStrings.revenueShort,
                    value: Formatters.money(conv(r.totalRevenue), code),
                    icon: Icons.payments_outlined,
                  ),
                  StatChip(
                    label: AppStrings.costShort,
                    value: Formatters.money(conv(r.totalCost), code),
                    icon: Icons.shopping_bag_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  StatChip(
                    label: AppStrings.invoicesCount,
                    value: Formatters.integer(r.invoicesCount),
                    icon: Icons.receipt_long_outlined,
                  ),
                ]),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppGridColumnsButton(managerGetter: () => _gridManager),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: AppGrid(
              // نفس إصلاح stocktake_report_page.dart: عدد الفواتير وحده لا
              // يلتقط تعديل فاتورة قائمة (ربحها/إجماليها يتغيّر بلا تغيّر
              // العدد) فتبقى TrinaGrid على صفوفها المخبَّأة القديمة.
              key: ValueKey(Object.hash(
                code,
                r.invoices.length,
                Object.hashAllUnordered(r.invoices.map((i) =>
                    Object.hash(i.invoiceNumber, i.revenue, i.cost, i.profit))),
              )),
              columns: [
                appGridTextColumn(AppStrings.invoiceLabel, _fInvoice,
                    width: 130),
                appGridTextColumn(AppStrings.dateColumn, _fDate,
                    width: 105, textAlign: TrinaColumnTextAlign.center),
                appGridTextColumn(AppStrings.paymentMethod, _fPayment,
                    width: 110, hide: true),
                appGridNumberColumn(AppStrings.revenueShort, _fRevenue,
                    width: 120),
                appGridNumberColumn(AppStrings.costShort, _fCost, width: 120),
                appGridNumberColumn(AppStrings.profitShort, _fProfit,
                    width: 120, renderer: (ctx) {
                  final v = ctx.cell.value;
                  final n = v is num ? v.toDouble() : 0.0;
                  if (n == 0) return const SizedBox.shrink();
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      Formatters.number(n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: profitColor(n),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
                appGridTextColumn(AppStrings.originalCurrency, _fOriginal,
                    width: 140, hide: true),
              ],
              rows: [
                for (final inv in r.invoices)
                  TrinaRow(cells: {
                    _fInvoice: TrinaCell(
                        value: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}'),
                    _fDate: TrinaCell(value: AppDate.ymd(inv.saleDate)),
                    _fPayment: TrinaCell(value: _payLabel(inv.paymentMethod)),
                    _fRevenue: TrinaCell(value: conv(inv.revenue)),
                    _fCost: TrinaCell(value: conv(inv.cost)),
                    _fProfit: TrinaCell(value: conv(inv.profit)),
                    _fOriginal: TrinaCell(
                        value: inv.originalCurrencyCode.isEmpty
                            ? ''
                            : '${Formatters.money(inv.revenue * inv.originalExchangeRate)} ${inv.originalCurrencyCode}'),
                  }),
              ],
              onLoaded: (m) => _gridManager = m,
              // فاتورة بخسارة → تظليل تحذيري خفيف.
              rowColorCallback: (ctx) {
                final p = ctx.row.cells[_fProfit]?.value;
                return (p is num && p < 0)
                    ? Colors.red.withValues(alpha: 0.05)
                    : Colors.transparent;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.profitFormulaHint,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

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
