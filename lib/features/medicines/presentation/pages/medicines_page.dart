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
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _addKey,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
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
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 56),
                    itemBuilder: (context, i) {
                      final m = items[i];
                      return _MedicineTile(
                        medicine: m,
                        onOpen: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MedicineDetailPage(medicine: m),
                          ),
                        ),
                        onEdit: () => _openForm(m),
                        onDelete: () => _delete(m),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
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

class _MedicineTile extends StatelessWidget {
  const _MedicineTile({
    required this.medicine,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final Medicine medicine;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = medicine.units.isNotEmpty
        ? Formatters.money(medicine.units.first.salePrice)
        : '—';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        child: Icon(Icons.medication_outlined, color: theme.colorScheme.primary),
      ),
      title: Text(medicine.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              if (medicine.genericName.isNotEmpty) medicine.genericName,
              if (medicine.barcode.isNotEmpty) medicine.barcode,
            ].join('  •  '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if ((medicine.manufacturerName ?? '').trim().isNotEmpty)
            Row(
              children: [
                Icon(Icons.factory_outlined, size: 13, color: theme.hintColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    medicine.manufacturerName!.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
        ],
      ),
      onTap: onOpen,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(price, style: theme.textTheme.titleSmall),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text(AppStrings.edit)),
              PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
            ],
          ),
        ],
      ),
    );
  }
}
