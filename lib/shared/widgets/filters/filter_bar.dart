import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Inline filter toolbar shown ABOVE the content on desktop — replaces the
/// endDrawer filter sheets (which stay as the compact-width fallback).
/// Children are [AppMenuChip]s, `FilterChip`s, `SegmentedButton`s…
class FilterBar extends StatelessWidget {
  const FilterBar({required this.children, this.trailing = const [], super.key});

  final List<Widget> children;

  /// Pinned at the end of the bar (e.g. a refresh button).
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ),
        ...trailing,
      ],
    );
  }
}

/// Compact selector for toolbars/filter bars: a bordered chip (icon + current
/// value + ▾) that opens a popup menu. The project-wide replacement for
/// full-width dropdowns in headers.
class AppMenuChip<T> extends StatelessWidget {
  const AppMenuChip({
    required this.icon,
    required this.label,
    required this.items,
    required this.onSelected,
    this.tooltip,
    this.maxLabelWidth = 180,
    super.key,
  });

  final IconData icon;

  /// The currently selected value's display text.
  final String label;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final String? tooltip;
  final double maxLabelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<T>(
      tooltip: tooltip ?? label,
      onSelected: onSelected,
      itemBuilder: (_) => items,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: context.semantic.border),
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSizes.iconSm, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.xs),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxLabelWidth),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 18, color: theme.hintColor),
          ],
        ),
      ),
    );
  }
}
