import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Inventory report — the project-standard tree grid: a stat-chips strip
/// (stock value / in-stock / low-stock) + a currency menu chip, over a tree
/// grid (medicine → its units with sale/cost prices). Low-stock rows tinted.
class InventoryReportPage extends ConsumerStatefulWidget {
  const InventoryReportPage({super.key});

  @override
  ConsumerState<InventoryReportPage> createState() =>
      _InventoryReportPageState();
}

class _InventoryReportPageState extends ConsumerState<InventoryReportPage> {
  String? _currencyId; // null => base currency

  TrinaGridStateManager? _gridManager;

  static const _fName = 'name';
  static const _fQty = 'qty';
  static const _fSale = 'sale';
  static const _fCost = 'cost';
  static const _fValue = 'value';
  static const _fLow = 'low';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(inventoryReportProvider);
    final base = ref.watch(baseCurrencyProvider);
    final currencies =
        ref.watch(currenciesProvider).value ?? const <Currency>[];
    final target =
        currencies.where((c) => c.id == (_currencyId ?? base?.id)).firstOrNull ??
            base;
    final code = target?.code ?? '';

    return ReportScaffold(
      title: AppStrings.inventoryReport,
      actions: [AppGridColumnsButton(managerGetter: () => _gridManager)],
      onRefresh: () => ref.invalidate(inventoryReportProvider),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(inventoryReportProvider),
        ),
        data: (r) {
          double conv(double v) => convertFromBase(v, base, target);
          final lowColor = Colors.orange.shade800;

          if (r.items.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              message: AppStrings.noData,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilterBar(
                  children: [
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
                    label: AppStrings.stockValue,
                    value: Formatters.money(conv(r.totalStockValue), code),
                    icon: Icons.inventory_2_outlined,
                  ),
                  StatChip(
                    label: AppStrings.medicinesInStock,
                    value: Formatters.integer(r.medicinesInStock),
                    icon: Icons.medication_outlined,
                  ),
                  StatChip(
                    label: AppStrings.lowStockCount,
                    value: Formatters.integer(r.lowStockCount),
                    icon: Icons.warning_amber_outlined,
                    color: r.lowStockCount > 0 ? lowColor : null,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: AppGrid(
                    key: ValueKey('$code-${r.items.length}'),
                    tree: true,
                    columns: [
                      appGridTextColumn(AppStrings.medicineName, _fName,
                          width: 240),
                      appGridNumberColumn(AppStrings.qtyLabel, _fQty,
                          width: 100),
                      appGridNumberColumn(AppStrings.priceColumn, _fSale,
                          width: 120),
                      appGridNumberColumn(AppStrings.costPriceLabel, _fCost,
                          width: 120, hide: true),
                      appGridNumberColumn(AppStrings.stockValue, _fValue,
                          width: 130, renderer: (ctx) {
                        final v = ctx.cell.value;
                        final n = v is num ? v.toDouble() : 0.0;
                        if (ctx.cell.value == '' || n == 0) {
                          return const SizedBox.shrink();
                        }
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
                      // الحالة: شريحة «منخفض» برتقالية.
                      TrinaColumn(
                        title: AppStrings.stockStatus,
                        field: _fLow,
                        type: TrinaColumnType.text(),
                        width: 110,
                        enableEditingMode: false,
                        textAlign: TrinaColumnTextAlign.center,
                        renderer: (ctx) {
                          if (ctx.cell.value != 'true') {
                            return const SizedBox.shrink();
                          }
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm, vertical: 2),
                              decoration: BoxDecoration(
                                color: lowColor.withValues(alpha: 0.12),
                                borderRadius: AppRadius.brSm,
                              ),
                              child: Text(AppStrings.lowStockBadge,
                                  style: TextStyle(
                                      color: lowColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          );
                        },
                      ),
                    ],
                    rows: [
                      for (final it in r.items)
                        TrinaRow(
                          cells: {
                            _fName: TrinaCell(value: it.brandName),
                            _fQty: TrinaCell(value: it.quantity),
                            _fSale: TrinaCell(value: ''),
                            _fCost: TrinaCell(value: ''),
                            _fValue: TrinaCell(value: conv(it.stockValue)),
                            _fLow: TrinaCell(value: it.isLowStock.toString()),
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
                                  _fSale:
                                      TrinaCell(value: conv(u.salePrice)),
                                  _fCost:
                                      TrinaCell(value: conv(u.purchaseCost)),
                                  _fValue: TrinaCell(value: ''),
                                  _fLow: TrinaCell(value: ''),
                                }),
                            ]),
                          ),
                        ),
                    ],
                    onLoaded: (m) => _gridManager = m,
                    // صنف منخفض المخزون → تظليل برتقالي خفيف.
                    rowColorCallback: (ctx) =>
                        ctx.row.cells[_fLow]?.value == 'true'
                            ? lowColor.withValues(alpha: 0.06)
                            : Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
