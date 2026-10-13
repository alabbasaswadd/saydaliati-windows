import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// The single most important number in a report, shown large and legible so the
/// pharmacist reads it at a glance.
class ReportHeroStat extends StatelessWidget {
  const ReportHeroStat({
    required this.label,
    required this.value,
    this.icon,
    this.color,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = color ?? theme.colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon ?? Icons.insights_outlined, color: accent, size: AppSizes.iconLg),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.hintColor)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
