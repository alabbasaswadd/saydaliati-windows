import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/alternatives/presentation/pages/alternatives_page.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/reports/presentation/pages/medicine_report_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/app_section_card.dart';

/// Read-only medicine details + its priced units.
class MedicineDetailPage extends ConsumerWidget {
  const MedicineDetailPage({required this.medicine, super.key});

  final Medicine medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // عملة أسعار الدواء + العملة الأساسية (للعرض وحساب المعادل بالعملة الأساسية).
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);
    Currency? medCurrency;
    for (final c in currencies) {
      if (c.code == medicine.currency) {
        medCurrency = c;
        break;
      }
    }
    final symbol = medCurrency?.symbol ?? base?.symbol ?? 'ل.س';

    // رقم سعري + العملة بجانبه، ومعادله بالعملة الأساسية إن اختلفت عنها.
    String priced(double v) {
      final native = Formatters.money(v, symbol);
      if (medCurrency != null &&
          base != null &&
          medCurrency.id != base.id &&
          medCurrency.exchangeRate > 0 &&
          base.exchangeRate > 0) {
        final inBase = convertToBase(v, base, medCurrency);
        return '$native  (≈ ${Formatters.money(inBase, base.symbol)})';
      }
      return native;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicineDetails),
        actions: [
          IconButton(
            tooltip: AppStrings.medicineReport,
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MedicineReportPage(medicineId: medicine.id),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppSectionCard(
            title: medicine.displayName,
            icon: Icons.medication_outlined,
            child: Column(
              children: [
                _row(theme, AppStrings.dosageForm, medicine.dosageForm.label),
                if (medicine.genericName.isNotEmpty)
                  _row(theme, 'المادة الفعّالة', medicine.genericName),
                if (medicine.barcode.isNotEmpty)
                  _row(theme, AppStrings.barcode, medicine.barcode),
                if (medicine.categoryName != null)
                  _row(theme, AppStrings.category, medicine.categoryName!),
                if (medicine.manufacturerName != null)
                  _row(theme, AppStrings.manufacturer, medicine.manufacturerName!),
                if (medicine.purchaseCost > 0)
                  _row(theme, AppStrings.purchaseCostLabel,
                      priced(medicine.purchaseCost)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _AutoPriceSyncTile(medicine: medicine),
          const SizedBox(height: AppSpacing.md),
          // زر بارز لعرض بدائل الدواء (نفس المادة الفعّالة) مع الشركة والسعر.
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AlternativesPage(medicine: medicine),
              ),
            ),
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('عرض البدائل'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSectionCard(
            title: AppStrings.units,
            icon: Icons.straighten_outlined,
            child: medicine.units.isEmpty
                ? Text('—', style: theme.textTheme.bodyMedium)
                : Column(
                    children: [
                      for (final u in medicine.units)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            children: [
                              Expanded(child: Text(u.unitName)),
                              Text(
                                '${AppStrings.salePrice}: ${priced(u.salePrice)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ),
            Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
          ],
        ),
      );
}

/// Per-medicine «تحديث السعر تلقائياً» switch. Default ON. Toggling persists to
/// the backend and patches the in-memory catalog so the state sticks.
class _AutoPriceSyncTile extends ConsumerStatefulWidget {
  const _AutoPriceSyncTile({required this.medicine});

  final Medicine medicine;

  @override
  ConsumerState<_AutoPriceSyncTile> createState() => _AutoPriceSyncTileState();
}

class _AutoPriceSyncTileState extends ConsumerState<_AutoPriceSyncTile> {
  late bool _enabled = widget.medicine.autoPriceSync;
  bool _busy = false;

  Future<void> _toggle(bool v) async {
    final previous = _enabled;
    setState(() {
      _enabled = v;
      _busy = true;
    });
    try {
      await ref.read(medicineRemoteDataSourceProvider).setAutoPriceSync(widget.medicine.id, v);
      // patch the in-memory catalog so the new value survives navigation.
      ref.read(medicineCatalogProvider.notifier)
          .upsert(widget.medicine.copyWith(autoPriceSync: v));
    } catch (e) {
      if (mounted) {
        setState(() => _enabled = previous); // revert on failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذّر حفظ الإعداد: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: SwitchListTile(
        value: _enabled,
        onChanged: _busy ? null : _toggle,
        secondary: const Icon(Icons.price_change_outlined),
        title: const Text('تحديث السعر تلقائياً'),
        subtitle: Text(
          'عند مزامنة الأسعار، يُحدَّث سعر هذا الدواء من الكاتلوغ العام. أوقِفه للاحتفاظ بسعرك الخاص.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }
}
