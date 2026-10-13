import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A small labelled detail shown as a pill under a report item
/// (e.g. "الكمية: 12", "الصلاحية: 2027-01-01").
class ReportField {
  const ReportField(this.label, this.value, {this.color});
  final String label;
  final String value;
  final Color? color;
}

/// One readable record in a report list: a bold title, an optional secondary
/// line, an emphasized trailing value, labelled detail pills, and optional
/// nested sub-rows (invoice → lines, medicine → units).
class ReportItem {
  const ReportItem({
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingColor,
    this.trailingCaption,
    this.accentColor,
    this.fields = const [],
    this.children = const [],
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final Color? trailingColor;
  final String? trailingCaption;

  /// A thin leading accent bar (e.g. orange for low-stock / red for expired).
  final Color? accentColor;

  final List<ReportField> fields;
  final List<ReportItem> children;
}

/// Mobile-first readable report list: a single card holding divided rows.
/// Replaces the old horizontally-scrolling table — no side scroll, each record
/// reads top-to-bottom.
class ReportList extends StatelessWidget {
  const ReportList({required this.items, this.emptyMessage, super.key});

  final List<ReportItem> items;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          emptyMessage ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _ReportItemView(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _ReportItemView extends StatelessWidget {
  const _ReportItemView({required this.item});

  final ReportItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.accentColor != null)
            Container(width: 4, color: item.accentColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _main(theme)),
                  if (item.trailing != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    _trailing(theme),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _main(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (item.subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              item.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        if (item.fields.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [for (final f in item.fields) _pill(theme, f)],
            ),
          ),
        if (item.children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Column(
              children: [for (final c in item.children) _SubRow(item: c)],
            ),
          ),
      ],
    );
  }

  Widget _trailing(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          item.trailing!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: item.trailingColor,
          ),
        ),
        if (item.trailingCaption != null)
          Text(
            item.trailingCaption!,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
      ],
    );
  }

  Widget _pill(ThemeData theme, ReportField f) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${f.label}: ',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            TextSpan(
              text: f.value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: f.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact nested row (invoice line / medicine unit).
class _SubRow extends StatelessWidget {
  const _SubRow({required this.item});

  final ReportItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chevron_left, size: 16, color: theme.hintColor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.bodyMedium),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
              ],
            ),
          ),
          if (item.trailing != null)
            Text(
              item.trailing!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: item.trailingColor,
              ),
            ),
        ],
      ),
    );
  }
}
