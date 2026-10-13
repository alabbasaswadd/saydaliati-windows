import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/alternatives/alternatives_providers.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Alternatives of a medicine (same active ingredient). Clean, scannable list:
/// a header that states the active ingredient, then one card per alternative
/// showing brand name, manufacturer (الشركة) and price at a glance.
class AlternativesPage extends ConsumerWidget {
  const AlternativesPage({required this.medicine, super.key});

  final Medicine medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(medicineAlternativesProvider(medicine.id));

    return Scaffold(
      appBar: AppBar(title: const Text('البدائل')),
      body: Column(
        children: [
          _Header(medicine: medicine, theme: theme),
          Expanded(
            child: async.when(
              loading: () => const LoadingState(),
              error: (e, _) => ErrorState.fromError(
                e,
                onRetry: () =>
                    ref.invalidate(medicineAlternativesProvider(medicine.id)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.swap_horiz_rounded,
                    message: 'لا توجد بدائل مسجّلة لهذا الدواء',
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _AlternativesGrid(items: items),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Top banner: states the active ingredient these alternatives share.
class _Header extends StatelessWidget {
  const _Header({required this.medicine, required this.theme});

  final Medicine medicine;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final ingredient =
        medicine.genericName.isNotEmpty ? medicine.genericName : '—';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: AppRadius.brLg,
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('بدائل: ${medicine.displayName}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('المادة الفعّالة: $ingredient',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// شبكة البدائل — الأسلوب المعتمد: صف لكل بديل بأعمدة واضحة (الدواء، الشركة،
/// الشكل الدوائي، السعر) مع فرز وفلترة لكل عمود.
class _AlternativesGrid extends StatelessWidget {
  const _AlternativesGrid({required this.items});

  final List<Medicine> items;

  static const _fName = 'name';
  static const _fCompany = 'company';
  static const _fForm = 'form';
  static const _fForeign = 'foreign';
  static const _fPrice = 'price';

  static double _priceOf(Medicine m) {
    if (m.units.isEmpty) return 0;
    final u = m.units.firstWhere(
      (x) => x.isDefault,
      orElse: () => m.units.firstWhere(
        (x) => x.isBaseUnit,
        orElse: () => m.units.first,
      ),
    );
    return u.salePrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppGrid(
      columns: [
        appGridTextColumn(AppStrings.medicineName, _fName, width: 220),
        appGridTextColumn(AppStrings.manufacturer, _fCompany, width: 170),
        appGridTextColumn(AppStrings.dosageForm, _fForm, width: 120),
        appGridTextColumn('الاسم الأجنبي', _fForeign, width: 160, hide: true),
        appGridNumberColumn(AppStrings.price, _fPrice, width: 120,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          if (n <= 0) {
            return Text('غير مسعّر',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.hintColor));
          }
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.number(n),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
      ],
      rows: [
        for (final m in items)
          TrinaRow(cells: {
            _fName: TrinaCell(value: m.displayName),
            _fCompany: TrinaCell(value: m.manufacturerName?.trim() ?? ''),
            _fForm: TrinaCell(value: m.dosageForm.label),
            _fForeign: TrinaCell(
                value: m.foreignName != m.brandName ? m.foreignName : ''),
            _fPrice: TrinaCell(value: _priceOf(m)),
          }),
      ],
    );
  }
}
