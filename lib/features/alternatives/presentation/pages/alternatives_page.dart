import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/alternatives/alternatives_providers.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) => _AlternativeCard(medicine: items[i]),
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

/// One alternative medicine — brand name, manufacturer, dosage form, and price.
class _AlternativeCard extends StatelessWidget {
  const _AlternativeCard({required this.medicine});

  final Medicine medicine;

  double get _price {
    if (medicine.units.isEmpty) return 0;
    final u = medicine.units.firstWhere(
      (x) => x.isDefault,
      orElse: () => medicine.units.firstWhere(
        (x) => x.isBaseUnit,
        orElse: () => medicine.units.first,
      ),
    );
    return u.salePrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    final price = _price;
    final company = medicine.manufacturerName?.trim();

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.brLg,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.brLg,
          border: Border.all(color: semantic.border),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: AppRadius.brMd,
              ),
              child: Icon(Icons.medication_rounded,
                  color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.displayName,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.factory_outlined,
                          size: 15, color: semantic.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          (company != null && company.isNotEmpty) ? company : '—',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: semantic.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _chip(theme, medicine.dosageForm.label,
                          theme.colorScheme.secondary),
                      if (medicine.foreignName.isNotEmpty &&
                          medicine.foreignName != medicine.brandName)
                        _chip(theme, medicine.foreignName, semantic.textSecondary,
                            outlined: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Price badge
            _PriceBadge(price: price, theme: theme, semantic: semantic),
          ],
        ),
      ),
    );
  }

  Widget _chip(ThemeData theme, String label, Color color,
          {bool outlined = false}) =>
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color.withValues(alpha: 0.12),
          borderRadius: AppRadius.brSm,
          border: outlined ? Border.all(color: color.withValues(alpha: 0.4)) : null,
        ),
        child: Text(label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600)),
      );
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge(
      {required this.price, required this.theme, required this.semantic});

  final double price;
  final ThemeData theme;
  final AppSemanticColors semantic;

  @override
  Widget build(BuildContext context) {
    if (price <= 0) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: semantic.textSecondary.withValues(alpha: 0.10),
          borderRadius: AppRadius.brSm,
        ),
        child: Text('غير مسعّر',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: semantic.textSecondary)),
      );
    }
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(
        Formatters.money(price),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
