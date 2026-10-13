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
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Fast pricing screen: search a medicine and edit the sale price of each of
/// its units inline (detailed per unit, with the per-unit cost shown and a
/// loss warning), then save that medicine's prices in one tap.
class QuickPricingPage extends ConsumerStatefulWidget {
  const QuickPricingPage({super.key});

  @override
  ConsumerState<QuickPricingPage> createState() => _QuickPricingPageState();
}

class _QuickPricingPageState extends ConsumerState<QuickPricingPage> {
  String _query = '';
  final _ctrls = <String, TextEditingController>{};
  final _saving = <String>{};

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String medId, MedicineUnit u) {
    return _ctrls.putIfAbsent(
      '$medId:${u.unitId}',
      () => TextEditingController(
          text: u.salePrice == 0 ? '' : Formatters.qty(u.salePrice)),
    );
  }

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

  Future<void> _save(Medicine m) async {
    final prices = <String, double>{};
    for (final u in m.units) {
      final v = double.tryParse(_controller(m.id, u).text.trim());
      if (v != null && v >= 0) prices[u.unitId] = v;
    }
    if (prices.isEmpty) return;
    setState(() => _saving.add(m.id));
    final res = await ref.read(medicineRepositoryProvider).updatePrices(m.id, prices);
    if (!mounted) return;
    setState(() => _saving.remove(m.id));
    res.fold(
      (_) {
        // Refresh ONLY the edited medicine (no full-catalog re-pull).
        ref.read(medicineCatalogProvider.notifier).refreshOne(m.id);
        AppSnackbar.success(context, AppStrings.pricesSaved);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
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
          final items = _filter(all);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BaseCurrencyBanner(),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(
                        icon: Icons.sell_outlined,
                        message: AppStrings.noMedicines)
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: items.length,
                        itemBuilder: (context, i) => _MedicineCard(
                          medicine: items[i],
                          controllerFor: (u) => _controller(items[i].id, u),
                          saving: _saving.contains(items[i].id),
                          onSave: () => _save(items[i]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Reminds the pharmacist that all prices here are entered in the pharmacy's
/// base currency (الليرة السورية), so the typed numbers are unambiguous.
class _BaseCurrencyBanner extends ConsumerWidget {
  const _BaseCurrencyBanner();

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
        borderRadius: AppRadius.brMd,
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
        ],
      ),
    );
  }
}

class _MedicineCard extends StatefulWidget {
  const _MedicineCard({
    required this.medicine,
    required this.controllerFor,
    required this.saving,
    required this.onSave,
  });

  final Medicine medicine;
  final TextEditingController Function(MedicineUnit) controllerFor;
  final bool saving;
  final VoidCallback onSave;

  @override
  State<_MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<_MedicineCard> {
  Medicine get medicine => widget.medicine;
  bool get saving => widget.saving;
  VoidCallback get onSave => widget.onSave;
  TextEditingController Function(MedicineUnit) get controllerFor =>
      widget.controllerFor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Base unit first, then by ascending factor — a clear, predictable order.
    final units = [...medicine.units]
      ..sort((a, b) {
        if (a.isBaseUnit != b.isBaseUnit) return a.isBaseUnit ? -1 : 1;
        return a.conversionFactor.compareTo(b.conversionFactor);
      });

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medicine.displayName,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            if (medicine.purchaseCost > 0)
              Text(
                '${AppStrings.costLabel}: ${Formatters.qty(medicine.purchaseCost)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
            const Divider(),
            for (final u in units) _unitRow(theme, u),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: saving ? null : onSave,
                icon: saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined, size: 18),
                label: const Text(AppStrings.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitRow(ThemeData theme, MedicineUnit u) {
    // Cost allocated to this unit = base cost × units-per-this-unit (factor).
    final unitCost = medicine.purchaseCost * u.conversionFactor;
    final price = double.tryParse(controllerFor(u).text.trim()) ?? u.salePrice;
    final belowCost = unitCost > 0 && price < unitCost;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(u.unitName,
                          style: theme.textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _badge(
                      theme,
                      u.isBaseUnit
                          ? AppStrings.baseBadge
                          : '×${Formatters.qty(u.conversionFactor)}',
                    ),
                  ],
                ),
                if (unitCost > 0)
                  Row(
                    children: [
                      if (belowCost)
                        Icon(Icons.warning_amber_rounded,
                            size: 13, color: Colors.orange.shade800),
                      if (belowCost) const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${AppStrings.costPerUnit}: ${Formatters.qty(unitCost)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: belowCost
                                  ? Colors.orange.shade800
                                  : theme.hintColor),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 120,
            child: AppNumberField(
              controller: controllerFor(u),
              label: AppStrings.salePrice,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(ThemeData theme, String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: theme.textTheme.labelSmall),
      );
}
