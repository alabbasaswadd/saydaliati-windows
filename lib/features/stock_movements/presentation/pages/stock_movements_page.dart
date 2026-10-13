import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/categories/category_providers.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/stock_movements/domain/entities/stock_movement.dart';
import 'package:saydaliati/features/stock_movements/stock_movement_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:trina_grid/trina_grid.dart';

/// Read-only stock movement audit log (newest first). Filters (دواء / صنف /
/// الفترة) live in a right-side panel opened from the AppBar filter button.
class StockMovementsPage extends ConsumerStatefulWidget {
  const StockMovementsPage({super.key});

  @override
  ConsumerState<StockMovementsPage> createState() => _StockMovementsPageState();
}

class _StockMovementsPageState extends ConsumerState<StockMovementsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _medicineId;
  String? _categoryId;
  ReportPeriod? _period;

  bool get _hasFilters =>
      _medicineId != null || _categoryId != null || _period != null;

  void _clear() => setState(() {
        _medicineId = null;
        _categoryId = null;
        _period = null;
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(stockMovementsProvider(
        _medicineId, _categoryId, _period?.startUtcIso, _period?.endUtcIso));
    final catalog = ref.watch(medicineCatalogProvider).value ?? const <Medicine>[];
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final selectedMed = catalog.where((m) => m.id == _medicineId).firstOrNull;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.stockMovements),
        actions: [
          IconButton(
            tooltip: AppStrings.filters,
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Badge(
              isLabelVisible: _hasFilters,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      endDrawer: FilterSideSheet(
        onClear: _hasFilters ? _clear : null,
        children: [
          Text(AppStrings.filterByMedicine, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          _medicineId == null
              ? MedicinePickerField(
                  medicines: catalog,
                  hint: AppStrings.filterByMedicine,
                  onSelected: (m) => setState(() {
                    _medicineId = m.id;
                    _categoryId = null;
                  }),
                )
              : InputChip(
                  label: Text(selectedMed?.displayName ?? '—',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  avatar: const Icon(Icons.medication_outlined, size: 18),
                  onDeleted: () => setState(() => _medicineId = null),
                ),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<String?>(
            label: AppStrings.filterByCategory,
            value: _categoryId,
            items: [
              const AppDropdownItem<String?>(value: null, label: AppStrings.all),
              for (final c in categories)
                AppDropdownItem<String?>(value: c.id, label: c.categoryName),
            ],
            onChanged: (v) => setState(() {
              _categoryId = v;
              if (v != null) _medicineId = null;
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          Text(AppStrings.period, style: theme.textTheme.labelLarge),
          PeriodFilterList(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
        ],
      ),
      // الغريد المعتمد: إدخال (سهم أخضر هابط) / إخراج (سهم أحمر صاعد) مع
      // تلوين خفيف لكامل السطر بلون الحركة.
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (movements) {
          if (movements.isEmpty) {
            return const Center(child: Text(AppStrings.noMovements));
          }
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _MovementsGrid(movements: movements),
          );
        },
      ),
    );
  }
}

class _MovementsGrid extends StatelessWidget {
  const _MovementsGrid({required this.movements});

  final List<StockMovement> movements;

  static const _fType = 'type';
  static const _fMedicine = 'medicine';
  static const _fDate = 'date';
  static const _fQty = 'qty';
  static const _fExpiry = 'expiry';
  static const _fNote = 'note';
  static const _fUp = 'up';

  @override
  Widget build(BuildContext context) {
    return AppGrid(
      key: ValueKey(movements.length ^ movements.hashCode),
      columns: [
        TrinaColumn(
          title: AppStrings.stockStatus,
          field: _fType,
          type: TrinaColumnType.text(),
          width: 150,
          enableEditingMode: false,
          renderer: (ctx) {
            final up = ctx.row.cells[_fUp]?.value == 'true';
            final color = up ? Colors.green.shade700 : Colors.red.shade700;
            return Row(
              children: [
                Icon(up ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 15, color: color),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    ctx.cell.value?.toString() ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        ),
        appGridTextColumn(AppStrings.medicineName, _fMedicine, width: 220),
        appGridTextColumn(AppStrings.dateColumn, _fDate,
            width: 105, textAlign: TrinaColumnTextAlign.center),
        appGridNumberColumn(AppStrings.qtyLabel, _fQty, width: 100,
            renderer: (ctx) {
          final up = ctx.row.cells[_fUp]?.value == 'true';
          final color = up ? Colors.green.shade700 : Colors.red.shade700;
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${up ? '+' : '-'}${Formatters.qty(n.abs())}',
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          );
        }),
        appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
            width: 105, hide: true, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn('ملاحظة', _fNote, width: 200),
        TrinaColumn(
            title: '', field: _fUp, type: TrinaColumnType.text(), hide: true),
      ],
      rows: [
        for (final m in movements)
          TrinaRow(cells: {
            _fType: TrinaCell(value: m.type.label),
            _fMedicine: TrinaCell(
                value: m.medicineName.isNotEmpty
                    ? m.medicineName
                    : m.type.label),
            _fDate: TrinaCell(value: AppDate.ymd(m.occurredOn)),
            _fQty: TrinaCell(value: m.quantityDelta),
            _fExpiry: TrinaCell(
                value: m.expiryDate != null ? AppDate.ymd(m.expiryDate!) : ''),
            _fNote: TrinaCell(value: m.note),
            _fUp: TrinaCell(value: m.type.isIncrease.toString()),
          }),
      ],
      // تلوين السطر كاملاً بلون الحركة (أخضر إدخال / أحمر إخراج) بشفافية خفيفة.
      rowColorCallback: (ctx) {
        final up = ctx.row.cells[_fUp]?.value == 'true';
        return (up ? Colors.green : Colors.red).withValues(alpha: 0.05);
      },
    );
  }
}
