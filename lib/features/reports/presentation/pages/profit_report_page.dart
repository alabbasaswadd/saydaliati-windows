import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_hero_stat.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/presentation/widgets/stat_tile.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/lists/app_section_header.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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
      onRefresh: () => ref.invalidate(profitReportProvider(
          _period.startUtcIso, _period.endUtcIso, null)),
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportHeroStat(
          label: AppStrings.profitShort,
          value: Formatters.money(conv(r.totalProfit), code),
          icon: Icons.trending_up_outlined,
          color: profitColor(r.totalProfit),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: AppStrings.revenueShort,
                value: Formatters.money(conv(r.totalRevenue), code),
                icon: Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: AppStrings.costShort,
                value: Formatters.money(conv(r.totalCost), code),
                icon: Icons.shopping_bag_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: AppStrings.invoicesCount,
                value: Formatters.integer(r.invoicesCount),
                icon: Icons.receipt_long_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppSectionHeader(title: AppStrings.invoicesTitle),
        const SizedBox(height: AppSpacing.sm),
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [
            for (final inv in r.invoices)
              ReportItem(
                title: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}',
                subtitle:
                    '${AppDate.ymd(inv.saleDate)} • ${_payLabel(inv.paymentMethod)}',
                accentColor: profitColor(inv.profit),
                trailing: Formatters.money(conv(inv.profit), code),
                trailingColor: profitColor(inv.profit),
                trailingCaption: AppStrings.profitShort,
                fields: [
                  ReportField(
                      AppStrings.revenueShort, Formatters.money(conv(inv.revenue), code)),
                  ReportField(
                      AppStrings.costShort, Formatters.money(conv(inv.cost), code)),
                  // العملة الأصلية للمعاملة إن اختلفت عن الأساس (للتدقيق).
                  if (inv.originalCurrencyCode.isNotEmpty)
                    ReportField(
                      AppStrings.originalCurrency,
                      '${Formatters.money(inv.revenue * inv.originalExchangeRate)} ${inv.originalCurrencyCode}',
                    ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppStrings.profitFormulaHint,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).hintColor),
          textAlign: TextAlign.center,
        ),
      ],
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
