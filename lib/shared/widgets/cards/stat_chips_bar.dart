import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// One chip in a [StatChipsBar]: icon + label + value, optionally colored,
/// optionally tappable (filtering) with a selected state.
class StatChip {
  const StatChip({
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;

  /// Accent for the icon + value (e.g. green profit, red expired).
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;
}

/// شريط الإحصائيات أعلى الجدول (أسلوب وكيد): شرائح مدمجة داخل إطار يطابق حدّ
/// الجدول — بدل بطاقات KPI الكبيرة الممتدة. تدعم شرائح قابلة للنقر للفلترة.
class StatChipsBar extends StatelessWidget {
  const StatChipsBar({required this.chips, super.key});

  final List<StatChip> chips;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: AppRadius.brSm,
        color: theme.colorScheme.surface,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final c in chips)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: _Chip(chip: c),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.chip});

  final StatChip chip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = chip.color ?? theme.colorScheme.primary;
    final body = Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brSm,
        color: chip.selected
            ? accent.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border.all(
          color: chip.selected ? accent : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chip.icon != null) ...[
            Icon(chip.icon, size: AppSizes.iconSm, color: accent),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            chip.label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            chip.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
      ),
    );
    if (chip.onTap == null) return body;
    return InkWell(
      borderRadius: AppRadius.brSm,
      onTap: chip.onTap,
      child: body,
    );
  }
}
