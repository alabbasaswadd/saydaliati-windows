import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_hero_stat.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/stat_tile.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

enum _Basis { cost, sale }

/// Stocktake: every medicine × unit as a readable list, with a cost/sale price
/// toggle and a currency selector (default = base). Values come from the backend
/// in the base currency and are converted on the client for display.
class StocktakeReportPage extends ConsumerStatefulWidget {
  const StocktakeReportPage({super.key});

  @override
  ConsumerState<StocktakeReportPage> createState() =>
      _StocktakeReportPageState();
}

class _StocktakeReportPageState extends ConsumerState<StocktakeReportPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _Basis _basis = _Basis.cost;
  String? _currencyId; // null => base currency

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(stocktakeProvider);
    final base = ref.watch(baseCurrencyProvider);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final target =
        currencies.where((c) => c.id == (_currencyId ?? base?.id)).firstOrNull ??
            base;
    final code = target?.code ?? '';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.stocktakeReport),
        actions: [
          IconButton(
            tooltip: AppStrings.filters,
            icon: const Icon(Icons.tune),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(stocktakeProvider),
          ),
        ],
      ),
      endDrawer: _filterDrawer(context, target, currencies),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(stocktakeProvider),
        ),
        data: (s) => _content(context, s, base, target, code),
      ),
    );
  }

  Widget _filterDrawer(
      BuildContext context, Currency? target, List<Currency> currencies) {
    final theme = Theme.of(context);
    return FilterSideSheet(
      children: [
        Text(AppStrings.priceBasis, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<_Basis>(
          segments: const [
            ButtonSegment(value: _Basis.cost, label: Text(AppStrings.basisCost)),
            ButtonSegment(value: _Basis.sale, label: Text(AppStrings.basisSale)),
          ],
          selected: {_basis},
          onSelectionChanged: (sel) => setState(() => _basis = sel.first),
        ),
        if (_basis == _Basis.cost)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(AppStrings.costCalcHint,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor)),
          ),
        const SizedBox(height: AppSpacing.md),
        const Divider(),
        if (currencies.isNotEmpty)
          AppDropdown<String>(
            label: AppStrings.selectCurrency,
            value: target?.id,
            items: [
              for (final c in currencies)
                AppDropdownItem(value: c.id, label: c.code),
            ],
            onChanged: (v) => setState(() => _currencyId = v),
          ),
      ],
    );
  }

  /// Inventory valued at SALE price: Σ(on-hand qty × base-unit sale price).
  /// (Cost valuation comes authoritatively from the backend as totalCostValue.)
  double _saleTotal(Stocktake s) {
    var total = 0.0;
    for (final it in s.items) {
      if (it.units.isEmpty) continue;
      final base = it.units.firstWhere((u) => u.isBaseUnit,
          orElse: () => it.units.first);
      total += it.onHandQuantity * base.salePrice;
    }
    return total;
  }

  Widget _content(BuildContext context, Stocktake s, Currency? base,
      Currency? target, String code) {
    double conv(double v) => convertFromBase(v, base, target);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportHeroStat(
          label:
              '${AppStrings.stocktakeValue} (${_basis == _Basis.cost ? AppStrings.basisCost : AppStrings.basisSale})',
          value: Formatters.money(
              conv(_basis == _Basis.cost ? s.totalCostValue : _saleTotal(s)),
              code),
          icon: Icons.fact_check_outlined,
        ),
        const SizedBox(height: AppSpacing.md),
        StatTile(
          label: AppStrings.materialsCount,
          value: Formatters.integer(s.medicinesCount),
          icon: Icons.medication_outlined,
        ),
        const SizedBox(height: AppSpacing.md),
        ReportList(
          emptyMessage: AppStrings.noData,
          items: [
            for (final it in s.items)
              ReportItem(
                title: it.brandName,
                fields: [
                  ReportField(
                      AppStrings.qtyLabel, Formatters.qty(it.onHandQuantity)),
                ],
                children: [
                  for (final u in it.units)
                    ReportItem(
                      title: u.isBaseUnit
                          ? '${u.unitName} (${AppStrings.baseBadge})'
                          : u.unitName,
                      trailing: Formatters.money(
                          conv(_basis == _Basis.cost ? u.costPrice : u.salePrice),
                          code),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
