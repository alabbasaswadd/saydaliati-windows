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
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';

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
      body: AsyncListView<StockMovement>(
        value: async,
        emptyMessage: AppStrings.noMovements,
        onRefresh: () => ref.refresh(stockMovementsProvider(
                _medicineId, _categoryId, _period?.startUtcIso, _period?.endUtcIso)
            .future),
        itemBuilder: (context, m) => _MovementCard(movement: m),
      ),
    );
  }
}

class _MovementCard extends StatelessWidget {
  const _MovementCard({required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final up = movement.type.isIncrease;
    final color = up ? Colors.green.shade700 : Colors.red.shade700;
    final title = movement.medicineName.isNotEmpty
        ? movement.medicineName
        : movement.type.label;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(up ? Icons.arrow_downward : Icons.arrow_upward,
                  color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(movement.type.label,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor)),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _chip(theme, Icons.event_outlined,
                          AppDate.ymd(movement.occurredOn)),
                      if (movement.expiryDate != null)
                        _chip(theme, Icons.schedule_outlined,
                            '${AppStrings.expiry}: ${AppDate.ymd(movement.expiryDate!)}'),
                      if (movement.note.isNotEmpty)
                        _chip(theme, Icons.sticky_note_2_outlined, movement.note),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${up ? '+' : '-'}${Formatters.qty(movement.quantityDelta.abs())}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
                Text(up ? AppStrings.movementIn : AppStrings.movementOut,
                    style: theme.textTheme.bodySmall?.copyWith(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: theme.hintColor),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
