import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A compact secondary KPI card used in a row/grid under the hero stat.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.primary, size: AppSizes.iconSm),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(value,
                style: theme.textTheme.titleMedium?.copyWith(color: valueColor)),
            Text(label,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }
}
