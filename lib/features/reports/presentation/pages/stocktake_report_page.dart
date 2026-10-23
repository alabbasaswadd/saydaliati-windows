import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/stocktake.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/buttons/app_segmented_pill.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/grids/grid_group_memory.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

enum _Basis { cost, sale }

/// Stocktake — the project-standard tree grid: inline filter bar (price basis
/// + currency) and stat chips over a tree grid (medicine → units priced by the
/// chosen basis). Values convert on the client from the base currency.
class StocktakeReportPage extends ConsumerStatefulWidget {
  const StocktakeReportPage({super.key});

  @override
  ConsumerState<StocktakeReportPage> createState() =>
      _StocktakeReportPageState();
}

class _StocktakeReportPageState extends ConsumerState<StocktakeReportPage> {
  _Basis _basis = _Basis.cost;
  String? _currencyId; // null => base currency

  TrinaGridStateManager? _gridManager;

  @override
  void dispose() {
    _groups.dispose();
    super.dispose();
  }

  /// ذاكرة الشجرة: تُبقي المجموعات المفتوحة عبر إعادة بناء الشبكة.
  ///
  /// مفتاح الشبكة يضمّ العملة وأساس التسعير (لأن القيم تتغيّر بهما)، فكل
  /// تبديل كان يُعيد البناء ويطوي الشجرة — فيفقد المستخدم موضعه بعد كل
  /// نقرة على المفتاح أو العملة.
  late final _groups = GridGroupMemory(
    keyField: _fName,
    isMounted: () => mounted,
  );

  static const _fName = 'name';
  static const _fQty = 'qty';
  static const _fPrice = 'price';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(stocktakeProvider);
    final base = ref.watch(baseCurrencyProvider);
    final currencies =
        ref.watch(currenciesProvider).value ?? const <Currency>[];
    final target =
        currencies.where((c) => c.id == (_currencyId ?? base?.id)).firstOrNull ??
            base;
    final code = target?.code ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stocktakeReport),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
          AppRefreshButton(
            onRefresh: () => ref.refresh(stocktakeProvider.future),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(stocktakeProvider),
        ),
        data: (s) => _content(context, s, base, target, code, currencies),
      ),
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
      Currency? target, String code, List<Currency> currencies) {
    double conv(double v) => convertFromBase(v, base, target);
    final basisLabel =
        _basis == _Basis.cost ? AppStrings.basisCost : AppStrings.basisSale;

    if (s.items.isEmpty) {
      return const EmptyState(
        icon: Icons.fact_check_outlined,
        message: AppStrings.noData,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // فلاتر مضمّنة: أساس التسعير + عملة العرض.
          FilterBar(
            children: [
              // نفس أسلوب مُنتقي الفترة بقسم الربح بالشاشة الرئيسية — لا
              // كروم SegmentedButton القياسي الذي كان يبدو غريباً هنا.
              AppSegmentedPill<_Basis>(
                options: const [
                  (_Basis.cost, AppStrings.basisCost),
                  (_Basis.sale, AppStrings.basisSale),
                ],
                selected: _basis,
                onChanged: (v) => setState(() => _basis = v),
              ),
              if (currencies.isNotEmpty)
                AppMenuChip<String>(
                  icon: Icons.payments_outlined,
                  tooltip: AppStrings.selectCurrency,
                  label: code,
                  items: [
                    for (final c in currencies)
                      PopupMenuItem(value: c.id, child: Text(c.code)),
                  ],
                  onSelected: (v) => setState(() => _currencyId = v),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          StatChipsBar(chips: [
            StatChip(
              label: '${AppStrings.stocktakeValue} ($basisLabel)',
              value: Formatters.money(
                  conv(_basis == _Basis.cost
                      ? s.totalCostValue
                      : _saleTotal(s)),
                  code),
              icon: Icons.fact_check_outlined,
            ),
            StatChip(
              label: AppStrings.materialsCount,
              value: Formatters.integer(s.medicinesCount),
              icon: Icons.medication_outlined,
            ),
          ]),
          if (_basis == _Basis.cost)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(AppStrings.costCalcHint,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor)),
            ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: AppGrid(
              // المفتاح كان مشتقّاً من عدد الأصناف وحده — فتسويةٌ أو فاتورة
              // أول المدة تُغيّر كمية صنفٍ قائم (بلا تغيير العدد الكلي) كانت
              // لا تُجبر TrinaGrid على إعادة بناء صفوفه المخبَّأة داخلياً،
              // فتبقى الكمية القديمة ظاهرة رغم وصول بيانات جديدة صحيحة من
              // الخادم. GridGroupMemory مربوطة أصلاً لاستعادة التمدّد/الفلترة
              // بعد أي إعادة بناء، فتضمين قيم البيانات هنا آمن.
              key: ValueKey(Object.hash(
                code,
                _basis,
                s.items.length,
                Object.hashAllUnordered(s.items.map((i) =>
                    Object.hash(i.medicineId, i.onHandQuantity, i.costValue))),
              )),
              tree: true,
              columns: [
                appGridTextColumn(AppStrings.medicineName, _fName, width: 260),
                appGridNumberColumn(AppStrings.qtyLabel, _fQty, width: 110),
                appGridNumberColumn('$basisLabel ($code)', _fPrice,
                    width: 140, renderer: (ctx) {
                  final v = ctx.cell.value;
                  if (v == '' || v == null) return const SizedBox.shrink();
                  final n = v is num ? v.toDouble() : 0.0;
                  if (n == 0) return const SizedBox.shrink();
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      Formatters.number(n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
              ],
              rows: [
                for (final it in s.items)
                  TrinaRow(
                    cells: {
                      _fName: TrinaCell(value: it.brandName),
                      _fQty: TrinaCell(value: it.onHandQuantity),
                      _fPrice: TrinaCell(value: ''),
                    },
                    type: TrinaRowType.group(
                      children: FilteredList(initialList: [
                        for (final u in it.units)
                          TrinaRow(cells: {
                            _fName: TrinaCell(
                                value: u.isBaseUnit
                                    ? '${u.unitName} (${AppStrings.baseBadge})'
                                    : u.unitName),
                            _fQty: TrinaCell(value: ''),
                            _fPrice: TrinaCell(
                                value: conv(_basis == _Basis.cost
                                    ? u.costPrice
                                    : u.salePrice)),
                          }),
                      ]),
                    ),
                  ),
              ],
              onLoaded: (m) {
                _gridManager = m;
                _groups.attach(m);
              },
            ),
          ),
        ],
      ),
    );
  }
}
