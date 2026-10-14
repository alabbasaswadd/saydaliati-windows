import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/inventory_report.dart';
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
/// grid (medicine → its expiry batches, only when it has more than one).
/// Low-stock rows tinted orange; near/past-expiry batch rows tinted too.
class InventoryReportPage extends ConsumerStatefulWidget {
  const InventoryReportPage({super.key});

  @override
  ConsumerState<InventoryReportPage> createState() =>
      _InventoryReportPageState();
}

class _InventoryReportPageState extends ConsumerState<InventoryReportPage> {
  // نفس نافذة «قريب الانتهاء» الافتراضية المعتمدة بتقرير الصلاحية المخصّص
  // (60 يوماً) — اتساق الألوان بين التقريرين.
  static const _soonWindowDays = 60;

  String? _currencyId; // null => base currency

  TrinaGridStateManager? _gridManager;

  static const _fName = 'name';
  static const _fQty = 'qty';
  static const _fSale = 'sale';
  static const _fCost = 'cost';
  static const _fValue = 'value';
  static const _fLow = 'low';
  static const _fWarehouse = 'warehouse';
  static const _fExpiry = 'expiry';
  static const _fDaysLeft = 'daysLeft';

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
          final soonColor = Colors.orange.shade800;
          final expiredColor = Colors.red.shade700;

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
                          width: 120, renderer: (ctx) {
                        final v = ctx.cell.value;
                        final n = v is num ? v.toDouble() : 0.0;
                        if (n == 0) return const SizedBox.shrink();
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(Formatters.number(n),
                              textAlign: TextAlign.center),
                        );
                      }),
                      appGridNumberColumn(AppStrings.costPriceLabel, _fCost,
                          width: 120, hide: true, renderer: (ctx) {
                        final v = ctx.cell.value;
                        final n = v is num ? v.toDouble() : 0.0;
                        if (n == 0) return const SizedBox.shrink();
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(Formatters.number(n),
                              textAlign: TextAlign.center),
                        );
                      }),
                      appGridTextColumn('المستودع', _fWarehouse,
                          width: 130, hide: true),
                      appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
                          width: 110, textAlign: TrinaColumnTextAlign.center),
                      appGridNumberColumn('الأيام المتبقية', _fDaysLeft,
                          width: 90, renderer: (ctx) {
                        final v = ctx.cell.value;
                        if (v == null || v == '') return const SizedBox.shrink();
                        final n = v is num ? v.toInt() : int.tryParse('$v');
                        if (n == null) return const SizedBox.shrink();
                        final color = n < 0
                            ? expiredColor
                            : (n <= _soonWindowDays ? soonColor : null);
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            '$n',
                            textAlign: TextAlign.center,
                            style: color == null
                                ? null
                                : TextStyle(color: color, fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
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
                      // الحالة: شريحة «منخفض» برتقالية (صف الدواء فقط).
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
                    rows: [for (final it in r.items) _itemRow(it, conv)],
                    onLoaded: (m) => _gridManager = m,
                    // صنف منخفض المخزون أو دفعة منتهية/قريبة الانتهاء → تظليل خفيف.
                    rowColorCallback: (ctx) {
                      if (ctx.row.cells[_fLow]?.value == 'true') {
                        return lowColor.withValues(alpha: 0.06);
                      }
                      final days = ctx.row.cells[_fDaysLeft]?.value;
                      final n = days is num ? days.toInt() : int.tryParse('$days');
                      if (n != null) {
                        if (n < 0) return expiredColor.withValues(alpha: 0.06);
                        if (n <= _soonWindowDays) {
                          return soonColor.withValues(alpha: 0.05);
                        }
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// صف الدواء (الأب): الكمية والقيمة الإجمالية + سعر البيع/التكلفة بالوحدة
  /// الأساسية مباشرة. الأسطر الفرعية (دفعات الصلاحية) تظهر فقط حين يملك
  /// الدواء أكثر من دفعة/تاريخ صلاحية — دواء بدفعة واحدة لا فائدة من توسيعه،
  /// فيبقى صفاً مسطّحاً، لكن **صلاحيته وأيامه المتبقية تُعرَض على نفس الصف**
  /// (لا تُفقَد فقط لأنه بلا أبناء).
  TrinaRow<dynamic> _itemRow(InventoryItem it, double Function(double) conv) {
    // دواء بدفعة واحدة بالضبط: فلا شجرة، لكن تفاصيل تلك الدفعة الوحيدة تُعرَض
    // مباشرة على صف الدواء نفسه بدل أن تختفي.
    final onlyBatch = it.batches.length == 1 ? it.batches.first : null;

    final parentCells = {
      _fName: TrinaCell(value: it.brandName),
      _fQty: TrinaCell(value: it.quantity),
      _fSale: TrinaCell(value: conv(it.baseUnitSalePrice)),
      _fCost: TrinaCell(value: conv(it.baseUnitCost)),
      _fWarehouse: TrinaCell(value: onlyBatch?.warehouseName ?? ''),
      _fExpiry: TrinaCell(
          value: onlyBatch == null
              ? ''
              : (onlyBatch.expiryDate != null
                  ? _ymd(onlyBatch.expiryDate!)
                  : AppStrings.notSet)),
      _fDaysLeft: TrinaCell(value: onlyBatch?.daysLeft ?? ''),
      _fValue: TrinaCell(value: conv(it.stockValue)),
      _fLow: TrinaCell(value: it.isLowStock.toString()),
    };

    if (it.batches.length <= 1) {
      return TrinaRow(cells: parentCells);
    }

    return TrinaRow(
      cells: parentCells,
      type: TrinaRowType.group(
        children: FilteredList(initialList: [
          for (final b in it.batches) _batchRow(b, conv),
        ]),
      ),
    );
  }

  TrinaRow<dynamic> _batchRow(InventoryBatch b, double Function(double) conv) {
    return TrinaRow(cells: {
      _fName: TrinaCell(value: ''),
      _fQty: TrinaCell(value: b.quantity),
      _fSale: TrinaCell(value: ''),
      _fCost: TrinaCell(value: conv(b.purchasePrice)),
      _fWarehouse: TrinaCell(value: b.warehouseName),
      _fExpiry: TrinaCell(
          value: b.expiryDate != null ? _ymd(b.expiryDate!) : AppStrings.notSet),
      _fDaysLeft: TrinaCell(value: b.daysLeft ?? ''),
      _fValue: TrinaCell(value: conv(b.batchValue)),
      _fLow: TrinaCell(value: ''),
    });
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
