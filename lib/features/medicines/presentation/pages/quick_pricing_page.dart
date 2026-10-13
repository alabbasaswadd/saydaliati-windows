import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_value_widget.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Fast pricing screen — the project-standard grid: every medicine×unit as
/// one row, the sale-price cell edits in place (loss rows tinted orange), and
/// a lightweight save bar (like أدويتي) commits all pending prices in one tap.
class QuickPricingPage extends ConsumerStatefulWidget {
  const QuickPricingPage({super.key});

  @override
  ConsumerState<QuickPricingPage> createState() => _QuickPricingPageState();
}

/// صف واحد في الغريد = وحدة دواء واحدة.
class _UnitRow {
  const _UnitRow(this.medicine, this.unit);
  final Medicine medicine;
  final MedicineUnit unit;

  String get key => '${medicine.id}:${unit.unitId}';
  double get cost => medicine.purchaseCost * unit.conversionFactor;
}

class _QuickPricingPageState extends ConsumerState<QuickPricingPage> {
  String _query = '';

  /// تعديلات معلّقة {medId:unitId → السعر الجديد}.
  final Map<String, double> _pending = {};
  bool _saving = false;
  TrinaGridStateManager? _gridManager;

  static const _fKey = 'key';
  static const _fMed = 'medicine';
  static const _fUnit = 'unit';
  static const _fCost = 'cost';
  static const _fPrice = 'price';

  List<Medicine> _filter(List<Medicine> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((m) =>
            m.brandName.toLowerCase().contains(q) ||
            m.brandNameArabic.contains(q) ||
            m.genericName.toLowerCase().contains(q) ||
            m.foreignName.toLowerCase().contains(q) ||
            m.barcode.toLowerCase().contains(q))
        .toList();
  }

  List<_UnitRow> _rowsFor(List<Medicine> medicines) {
    final rows = <_UnitRow>[];
    for (final m in medicines) {
      final units = [...m.units]
        ..sort((a, b) {
          if (a.isBaseUnit != b.isBaseUnit) return a.isBaseUnit ? -1 : 1;
          return a.conversionFactor.compareTo(b.conversionFactor);
        });
      for (final u in units) {
        rows.add(_UnitRow(m, u));
      }
    }
    return rows;
  }

  Future<void> _saveAll() async {
    if (_pending.isEmpty) return;
    // تجميع التعديلات حسب الدواء — نداء واحد لكل دواء بكل وحداته المعدَّلة.
    final byMedicine = <String, Map<String, double>>{};
    for (final entry in _pending.entries) {
      final parts = entry.key.split(':');
      final medId = parts[0];
      final unitId = parts[1];
      byMedicine.putIfAbsent(medId, () => {})[unitId] = entry.value;
    }
    setState(() => _saving = true);
    final repo = ref.read(medicineRepositoryProvider);
    var failures = 0;
    for (final e in byMedicine.entries) {
      final res = await repo.updatePrices(e.key, e.value);
      res.fold(
          (_) => ref.read(medicineCatalogProvider.notifier).refreshOne(e.key),
          (_) => failures++);
    }
    if (!mounted) return;
    setState(() {
      _saving = false;
      _pending.clear();
    });
    if (failures == 0) {
      AppSnackbar.success(context, AppStrings.pricesSaved);
    } else {
      AppSnackbar.error(context, 'تعذّر حفظ $failures من التعديلات');
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(medicineCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.quickPricing),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: AppSearchField(
              hint: AppStrings.searchMedicineHint,
              debounce: const Duration(milliseconds: 250),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: AsyncValueWidget(
        value: async,
        onRetry: () => ref.invalidate(medicineCatalogProvider),
        data: (all) {
          final rows = _rowsFor(_filter(all));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BaseCurrencyBanner(columnsButton: () => _gridManager),
              Expanded(
                child: rows.isEmpty
                    ? const EmptyState(
                        icon: Icons.sell_outlined,
                        message: AppStrings.noMedicines)
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: _grid(rows),
                      ),
              ),
              _pendingSaveBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _grid(List<_UnitRow> rows) {
    final theme = Theme.of(context);
    final byKey = {for (final r in rows) r.key: r};

    return AppGrid(
      key: ValueKey(rows.length ^ rows.hashCode),
      columns: [
        appGridTextColumn(AppStrings.medicineName, _fMed, width: 240),
        appGridTextColumn(AppStrings.unitLabel, _fUnit, width: 130),
        appGridNumberColumn(AppStrings.costPerUnit, _fCost, width: 110),
        TrinaColumn(
          title: AppStrings.salePrice,
          field: _fPrice,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 120,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
          renderer: (ctx) {
            final key = ctx.row.cells[_fKey]?.value;
            final pending = _pending.containsKey(key);
            final v = ctx.cell.value;
            final n = v is num ? v.toDouble() : 0.0;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    n > 0 ? Formatters.number(n) : '—',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: pending ? theme.colorScheme.primary : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.edit_outlined,
                    size: 12,
                    color: pending ? theme.colorScheme.primary : theme.hintColor),
              ],
            );
          },
        ),
        TrinaColumn(
            title: '', field: _fKey, type: TrinaColumnType.text(), hide: true),
      ],
      rows: [
        for (final r in rows)
          TrinaRow(cells: {
            _fKey: TrinaCell(value: r.key),
            _fMed: TrinaCell(value: r.medicine.displayName),
            _fUnit: TrinaCell(
                value: r.unit.isBaseUnit
                    ? '${r.unit.unitName} (${AppStrings.baseBadge})'
                    : '${r.unit.unitName} ×${r.unit.conversionFactor}'),
            _fCost: TrinaCell(value: r.cost),
            _fPrice: TrinaCell(value: _pending[r.key] ?? r.unit.salePrice),
          }),
      ],
      onLoaded: (m) => _gridManager = m,
      onChanged: (e) {
        if (e.column.field != _fPrice) return;
        final row = byKey[e.row.cells[_fKey]?.value];
        if (row == null) return;
        final v = e.value is num
            ? (e.value as num).toDouble()
            : double.tryParse(e.value?.toString() ?? '');
        setState(() {
          if (v == null || v < 0 || v == row.unit.salePrice) {
            _pending.remove(row.key);
          } else {
            _pending[row.key] = v;
          }
        });
      },
      // سعر أقل من الكلفة → تظليل تحذيري لكامل السطر.
      rowColorCallback: (ctx) {
        final row = byKey[ctx.row.cells[_fKey]?.value];
        if (row == null || row.cost <= 0) return Colors.transparent;
        final price = _pending[row.key] ?? row.unit.salePrice;
        return price > 0 && price < row.cost
            ? Colors.orange.withValues(alpha: 0.08)
            : Colors.transparent;
      },
    );
  }

  /// شريط حفظ خفيف يظهر فقط عند وجود تعديلات أسعار معلّقة (مطابق لأدويتي).
  Widget _pendingSaveBar() {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      child: _pending.isEmpty
          ? const SizedBox(width: double.infinity)
          : Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Icon(Icons.sell_outlined,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${_pending.length} تعديل سعر غير محفوظ',
                      style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  TextButton(
                    onPressed:
                        _saving ? null : () => setState(_pending.clear),
                    child: const Text('تجاهل'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _saving ? null : _saveAll,
                    icon: _saving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined, size: 16),
                    label: const Text(AppStrings.save),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Reminds the pharmacist that all prices here are entered in the pharmacy's
/// base currency (الليرة السورية), so the typed numbers are unambiguous.
class _BaseCurrencyBanner extends ConsumerWidget {
  const _BaseCurrencyBanner({required this.columnsButton});

  final TrinaGridStateManager? Function() columnsButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final base = ref.watch(baseCurrencyProvider);
    final label = base == null
        ? 'العملة الأساسية'
        : '${base.name} (${base.symbol})';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'التسعير بالعملة الأساسية: $label',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ),
          AppGridColumnsButton(managerGetter: columnsButton),
        ],
      ),
    );
  }
}
