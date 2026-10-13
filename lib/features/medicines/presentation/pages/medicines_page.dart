import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/pages/medicine_detail_page.dart';
import 'package:saydaliati/features/medicines/presentation/pages/medicine_form_page.dart';
import 'package:saydaliati/features/medicines/presentation/pages/quick_pricing_page.dart';
import 'package:saydaliati/features/medicines/presentation/price_sync_action.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:saydaliati/features/onboarding/onboarding_coach.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_value_widget.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Tab 2 — الأدوية. Cache-first catalog with search, a side filter drawer (by
/// manufacturer), add/edit/delete, and an online-search fallback when the
/// offline catalog has no match. Source the POS scans against.
class MedicinesPage extends ConsumerStatefulWidget {
  const MedicinesPage({super.key});

  @override
  ConsumerState<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends ConsumerState<MedicinesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// مدير الشبكة + تعديلات الأسعار المعلّقة {medicineId: السعر الجديد} —
  /// تُحفظ دفعة واحدة بزر الحفظ الخفيف أسفل الجدول.
  TrinaGridStateManager? _gridManager;
  final Map<String, double> _pendingPrices = {};
  bool _savingPrices = false;
  String _query = '';
  String? _manufacturer; // selected company filter (null = all)
  List<Medicine>? _online; // online-search results for the current query
  bool _onlineLoading = false;
  final _addKey = GlobalKey();
  bool _coachShown = false;

  void _maybeShowCoach() {
    if (_coachShown) return;
    final onb = ref.read(onboardingControllerProvider);
    if (!onb.active || onb.stage != OnboardingStage.medicine) return;
    _coachShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showCoach(
        context,
        steps: [
          CoachStep(
              key: _addKey,
              title: AppStrings.onbAddMedicineTitle,
              text: AppStrings.onbAddMedicineText),
        ],
        onSkip: () => ref.read(onboardingControllerProvider.notifier).finish(),
      );
    });
  }

  /// Distinct manufacturers present in the catalog with how many medicines each
  /// has (sorted by name) — feeds the side filter drawer.
  List<MapEntry<String, int>> _manufacturers(List<Medicine> all) {
    final counts = <String, int>{};
    for (final m in all) {
      final n = (m.manufacturerName ?? '').trim();
      if (n.isEmpty) continue;
      counts[n] = (counts[n] ?? 0) + 1;
    }
    return counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  List<Medicine> _filter(List<Medicine> all) {
    var list = all;
    final man = _manufacturer;
    if (man != null) {
      list = list
          .where((m) => (m.manufacturerName ?? '').trim() == man)
          .toList();
    }
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((m) =>
              m.brandName.toLowerCase().contains(q) ||
              m.brandNameArabic.contains(q) ||
              m.genericName.toLowerCase().contains(q) ||
              m.foreignName.toLowerCase().contains(q) ||
              m.barcode.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  /// Fallback online search by name (hits the server) when nothing matches
  /// offline. Results are cached write-through for next time.
  Future<void> _searchOnline() async {
    final q = _query.trim();
    if (q.isEmpty) return;
    setState(() => _onlineLoading = true);
    try {
      final res = await ref.read(medicineRepositoryProvider).searchOnline(q);
      if (!mounted) return;
      setState(() => _online = res);
      if (res.isEmpty) {
        AppSnackbar.info(context, 'لا توجد نتائج على الإنترنت لـ «$q»');
      }
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'تعذّر البحث عبر الإنترنت');
    } finally {
      if (mounted) setState(() => _onlineLoading = false);
    }
  }

  Future<void> _openForm([Medicine? existing]) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MedicineFormPage(existing: existing),
      ),
    );
  }

  Future<void> _delete(Medicine m) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: m.displayName);
    if (!ok || !mounted) return;
    final result = await ref.read(medicineRepositoryProvider).delete(m.id);
    if (!mounted) return;
    result.fold(
      (_) {
        ref.invalidate(medicineCatalogProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(medicineCatalogProvider);
    final all = async.value ?? const <Medicine>[];
    ref.watch(onboardingControllerProvider);
    _maybeShowCoach();

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _ManufacturerFilterDrawer(
        manufacturers: _manufacturers(all),
        selected: _manufacturer,
        onSelect: (name) => setState(() => _manufacturer = name),
      ),
      appBar: AppBar(
        title: const Text('أدويتي'),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
          const NotificationBell(),
          IconButton(
            tooltip: 'تحديث أدويتي',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(medicineCatalogProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يتم تحديث أدويتك…')),
              );
            },
          ),
          IconButton(
            tooltip: 'مزامنة الأسعار من الكاتلوغ',
            icon: const Icon(Icons.price_change_outlined),
            onPressed: () => runMedicinePriceSync(context, ref),
          ),
          IconButton(
            tooltip: 'فلترة حسب الشركة',
            icon: Badge(
              isLabelVisible: _manufacturer != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          IconButton(
            tooltip: AppStrings.quickPricing,
            icon: const Icon(Icons.sell_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const QuickPricingPage()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: AppSearchField(
                    hint: AppStrings.searchMedicineHint,
                    debounce: const Duration(milliseconds: 250),
                    // A new query invalidates any previous online results.
                    onChanged: (v) => setState(() {
                      _query = v;
                      _online = null;
                    }),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // زر إضافة دواء بأسلوب سطح المكتب — بجانب البحث بدل الزر العائم.
                FilledButton.icon(
                  key: _addKey,
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة دواء'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(medicineCatalogProvider.future),
        child: AsyncValueWidget(
          value: async,
          onRetry: () => ref.invalidate(medicineCatalogProvider),
          data: (all) {
            final local = _filter(all);
            final usingOnline =
                local.isEmpty && (_online != null && _online!.isNotEmpty);
            final items = local.isNotEmpty ? local : (_online ?? const <Medicine>[]);

            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  const EmptyState(
                    icon: Icons.medication_outlined,
                    message: AppStrings.noMedicines,
                  ),
                  if (_query.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: AppButton.outline(
                        label: 'ابحث عبر الإنترنت',
                        icon: Icons.travel_explore,
                        isLoading: _onlineLoading,
                        onPressed: _searchOnline,
                      ),
                    ),
                  ],
                ],
              );
            }

            return Column(
              children: [
                if (_manufacturer != null)
                  _activeFilterChip(context),
                if (usingOnline) _onlineBanner(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _medicinesGrid(items),
                  ),
                ),
                _pendingSaveBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── الغريد المعتمد مع تعديل السعر داخل الخلية ─────────────────────────────

  static const _fId = 'id';
  static const _fName = 'name';
  static const _fCompany = 'company';
  static const _fBarcode = 'barcode';
  static const _fUnit = 'unit';
  static const _fPrice = 'price';
  static const _fCost = 'cost';
  static const _fActions = 'actions';

  Widget _medicinesGrid(List<Medicine> items) {
    final byId = {for (final m in items) m.id: m};
    return AppGrid(
      key: ValueKey(items.length ^ items.hashCode),
      columns: _columns(byId),
      rows: [for (final m in items) _row(m)],
      onLoaded: (m) => _gridManager = m,
      onChanged: (e) => _onPriceCellChanged(e, byId),
      onRowDoubleTap: (e) {
        // نقرة مزدوجة على خلية السعر تبقى للتعديل، لا تفتح تفاصيل الدواء.
        if (e.row.cells[_fPrice] == e.cell) return;
        final m = byId[e.row.cells[_fId]?.value];
        if (m != null) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => MedicineDetailPage(medicine: m)));
        }
      },
      // الصفوف ذات تعديل سعر معلّق تُظلَّل بخفّة حتى الحفظ.
      rowColorCallback: (ctx) {
        final id = ctx.row.cells[_fId]?.value;
        return _pendingPrices.containsKey(id)
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06)
            : Colors.transparent;
      },
    );
  }

  void _onPriceCellChanged(TrinaGridOnChangedEvent e, Map<String, Medicine> byId) {
    if (e.column.field != _fPrice) return;
    final m = byId[e.row.cells[_fId]?.value];
    if (m == null || m.units.isEmpty) return;
    final unit =
        m.units.firstWhere((u) => u.isDefault, orElse: () => m.units.first);
    final v = e.value is num
        ? (e.value as num).toDouble()
        : double.tryParse(e.value?.toString() ?? '');
    setState(() {
      if (v == null || v < 0 || v == unit.salePrice) {
        _pendingPrices.remove(m.id);
      } else {
        _pendingPrices[m.id] = v;
      }
    });
  }

  /// شريط حفظ خفيف يظهر فقط عند وجود تعديلات أسعار معلّقة.
  Widget _pendingSaveBar() {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      child: _pendingPrices.isEmpty
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
                  Text('${_pendingPrices.length} تعديل سعر غير محفوظ',
                      style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: _savingPrices
                        ? null
                        : () => setState(() {
                              _pendingPrices.clear();
                              // إعادة بناء الشبكة تسترجع الأسعار الأصلية.
                              ref.invalidate(medicineCatalogProvider);
                            }),
                    child: const Text('تجاهل'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _savingPrices ? null : _savePendingPrices,
                    icon: _savingPrices
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

  Future<void> _savePendingPrices() async {
    final all = ref.read(medicineCatalogProvider).value ?? const <Medicine>[];
    final byId = {for (final m in all) m.id: m};
    setState(() => _savingPrices = true);
    final repo = ref.read(medicineRepositoryProvider);
    var failures = 0;
    for (final entry in _pendingPrices.entries) {
      final m = byId[entry.key];
      if (m == null || m.units.isEmpty) continue;
      final unit =
          m.units.firstWhere((u) => u.isDefault, orElse: () => m.units.first);
      final res = await repo.updatePrices(m.id, {unit.unitId: entry.value});
      res.fold((_) {}, (_) => failures++);
    }
    if (!mounted) return;
    setState(() {
      _savingPrices = false;
      _pendingPrices.clear();
    });
    ref.invalidate(medicineCatalogProvider);
    if (failures == 0) {
      AppSnackbar.success(context, AppStrings.updatedSuccess);
    } else {
      AppSnackbar.error(context, 'تعذّر حفظ $failures من التعديلات');
    }
  }

  List<TrinaColumn> _columns(Map<String, Medicine> byId) {
    return [
      appGridTextColumn(AppStrings.medicineName, _fName, width: 240),
      appGridTextColumn('الشركة', _fCompany, width: 150),
      appGridTextColumn('الباركود', _fBarcode, width: 130, hide: true),
      appGridTextColumn(AppStrings.unitLabel, _fUnit, width: 100),
      // سعر البيع — قابل للتعديل داخل الخلية (الوحدة الافتراضية).
      TrinaColumn(
        title: AppStrings.price,
        field: _fPrice,
        type: TrinaColumnType.number(
          format: '#,##0.##',
          locale: 'en',
          applyFormatOnInit: false,
        ),
        width: 120,
        textAlign: TrinaColumnTextAlign.center,
        enableEditingMode: true,
        checkReadOnly: (row, cell) =>
            byId[row.cells[_fId]?.value]?.units.isEmpty ?? true,
        renderer: (ctx) {
          final id = ctx.row.cells[_fId]?.value;
          final pending = _pendingPrices.containsKey(id);
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
                    color: pending
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.edit_outlined,
                  size: 13,
                  color: pending
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).hintColor),
            ],
          );
        },
      ),
      appGridNumberColumn(AppStrings.costShort, _fCost,
          width: 110, hide: true),
      TrinaColumn(
        title: '',
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 120,
        enableEditingMode: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableSorting: false,
        renderer: (ctx) {
          final m = byId[ctx.row.cells[_fId]?.value];
          if (m == null) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.details,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => MedicineDetailPage(medicine: m))),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.edit,
                onPressed: () => _openForm(m),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 16, color: Theme.of(context).colorScheme.error),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.delete,
                onPressed: () => _delete(m),
              ),
            ],
          );
        },
      ),
      TrinaColumn(
          title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
    ];
  }

  TrinaRow<dynamic> _row(Medicine m) {
    final unit = m.units.isEmpty
        ? null
        : m.units.firstWhere((u) => u.isDefault, orElse: () => m.units.first);
    return TrinaRow(
      cells: {
        _fId: TrinaCell(value: m.id),
        _fName: TrinaCell(value: m.displayName),
        _fCompany: TrinaCell(value: m.manufacturerName ?? ''),
        _fBarcode: TrinaCell(value: m.barcode),
        _fUnit: TrinaCell(value: unit?.unitName ?? ''),
        _fPrice: TrinaCell(
            value: _pendingPrices[m.id] ?? unit?.salePrice ?? 0),
        _fCost: TrinaCell(value: m.purchaseCost),
      },
    );
  }

  Widget _activeFilterChip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Chip(
          avatar: Icon(Icons.factory_outlined,
              size: 16, color: theme.colorScheme.primary),
          label: Text(_manufacturer!),
          onDeleted: () => setState(() => _manufacturer = null),
          deleteIcon: const Icon(Icons.close, size: 16),
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  Widget _onlineBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.brSm,
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_done_outlined,
              size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text('نتائج من الإنترنت',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }
}

/// Side drawer to filter the catalog by manufacturer. Card-style selectable
/// rows with per-company counts and a built-in search over companies.
class _ManufacturerFilterDrawer extends StatefulWidget {
  const _ManufacturerFilterDrawer({
    required this.manufacturers,
    required this.selected,
    required this.onSelect,
  });

  final List<MapEntry<String, int>> manufacturers;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  State<_ManufacturerFilterDrawer> createState() =>
      _ManufacturerFilterDrawerState();
}

class _ManufacturerFilterDrawerState extends State<_ManufacturerFilterDrawer> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _q.trim().toLowerCase();
    final list = q.isEmpty
        ? widget.manufacturers
        : widget.manufacturers
            .where((e) => e.key.toLowerCase().contains(q))
            .toList();
    final total =
        widget.manufacturers.fold<int>(0, (s, e) => s + e.value);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.factory_outlined,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text('فلترة حسب الشركة',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('${widget.manufacturers.length} شركة · $total دواء',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'ابحث عن شركة…',
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(borderRadius: AppRadius.brMd),
                ),
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            // "All" (clear filter)
            _tile(
              context,
              label: 'كل الشركات',
              count: total,
              icon: Icons.apps,
              selected: widget.selected == null,
              onTap: () {
                widget.onSelect(null);
                Navigator.of(context).pop();
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text('لا شركات مطابقة',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final e = list[i];
                        return _tile(
                          context,
                          label: e.key,
                          count: e.value,
                          icon: Icons.business_outlined,
                          selected: widget.selected == e.key,
                          onTap: () {
                            widget.onSelect(e.key);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String label,
    required int count,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      child: Material(
        color: selected ? primary.withValues(alpha: 0.12) : theme.colorScheme.surface,
        borderRadius: AppRadius.brMd,
        child: InkWell(
          borderRadius: AppRadius.brMd,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.brMd,
              border: Border.all(
                color: selected ? primary : theme.dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: selected ? primary : theme.hintColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? primary : null)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('$count',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: primary, fontWeight: FontWeight.bold)),
                ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.check_circle, size: 18, color: primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
