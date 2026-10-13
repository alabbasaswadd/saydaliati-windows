import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/grids/app_editable_grid.dart';

/// Read-only column for [AppDataGrid]. Prefer [AppDataColumn.text] for plain
/// values; pass [sortBy] to make the header sortable (click to toggle ↑/↓).
class AppDataColumn<T> {
  const AppDataColumn({
    required this.label,
    required this.cellBuilder,
    this.sortBy,
    this.flex = 1,
    this.width,
    this.alignEnd = false,
  });

  /// Plain text column: [value] renders via [AppGridText]; [emphasized] uses
  /// the primary bold style (totals), [color] overrides per row.
  AppDataColumn.text({
    required this.label,
    required String Function(T row) value,
    bool emphasized = false,
    bool secondary = false,
    Color? Function(T row)? color,
    this.sortBy,
    this.flex = 1,
    this.width,
    this.alignEnd = false,
  }) : cellBuilder = ((context, row, index) => AppGridText(
              value(row),
              emphasized: emphasized,
              secondary: secondary,
              color: color?.call(row),
            ));

  final String label;
  final int flex;
  final double? width;
  final bool alignEnd;
  final Widget Function(BuildContext context, T row, int index) cellBuilder;

  /// Sort key for this column; null → not sortable.
  final Comparable<Object?> Function(T row)? sortBy;
}

/// الجدول الموحّد للقراءة — the project-wide READ grid (reports & lists).
///
/// Same visual language as [AppEditableGrid] (card, muted header, divided
/// rows, optional accent bar) plus: click-to-sort headers, lazy row building
/// (ListView.builder — safe for thousands of rows), row hover + onRowTap,
/// and horizontal scrolling below [minWidth].
class AppDataGrid<T> extends StatefulWidget {
  const AppDataGrid({
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.rowAccent,
    this.trailing,
    this.emptyMessage,
    this.minWidth = 720,
    this.expand = true,
    this.initialSortColumn,
    this.initialAscending = true,
    super.key,
  });

  final List<AppDataColumn<T>> columns;
  final List<T> rows;

  /// Row click (open detail…). Adds hover + pointer feedback.
  final void Function(T row)? onRowTap;

  /// Thin leading accent bar per row (warnings…); null for none.
  final Color? Function(T row)? rowAccent;

  /// Per-row trailing actions cell (edit/delete buttons), fixed 88px.
  final Widget Function(BuildContext context, T row)? trailing;

  final String? emptyMessage;
  final double minWidth;

  /// true → fixed header + scrolling rows (inside Expanded).
  /// false → lays out all rows (inside an outer scroll view).
  final bool expand;

  /// Index into [columns] to sort by initially (must have sortBy).
  final int? initialSortColumn;
  final bool initialAscending;

  @override
  State<AppDataGrid<T>> createState() => _AppDataGridState<T>();
}

class _AppDataGridState<T> extends State<AppDataGrid<T>> {
  int? _sortColumn;
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    _sortColumn = widget.initialSortColumn;
    _ascending = widget.initialAscending;
  }

  List<T> get _sortedRows {
    final c = _sortColumn == null ? null : widget.columns[_sortColumn!];
    final sortBy = c?.sortBy;
    if (sortBy == null) return widget.rows;
    final sorted = [...widget.rows]
      ..sort((a, b) => sortBy(a).compareTo(sortBy(b)));
    return _ascending ? sorted : sorted.reversed.toList();
  }

  void _onHeaderTap(int index) {
    if (widget.columns[index].sortBy == null) return;
    setState(() {
      if (_sortColumn == index) {
        _ascending = !_ascending;
      } else {
        _sortColumn = index;
        _ascending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.rows.isEmpty && widget.emptyMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          widget.emptyMessage!,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsHScroll = constraints.hasBoundedWidth &&
            constraints.maxWidth < widget.minWidth;
        final grid = _buildGrid(theme);
        if (!needsHScroll) return grid;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: widget.minWidth, child: grid),
        );
      },
    );
  }

  Widget _buildGrid(ThemeData theme) {
    final rows = _sortedRows;
    final body = widget.expand
        ? Expanded(
            child: ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _row(context, rows[i], i),
            ),
          )
        : Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _row(context, rows[i], i),
              ],
            ],
          );

    // Dense bordered grid (wakeed-style): tight radius, hairline outline.
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brSm,
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        children: [_header(theme), const Divider(height: 1), body],
      ),
    );
  }

  /// Vertical column separator (grid lines) — on every cell after the first.
  BoxDecoration? _cellDivider(ThemeData theme, bool first) => first
      ? null
      : BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: theme.dividerColor),
          ),
        );

  Widget _header(ThemeData theme) {
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.hintColor,
      fontWeight: FontWeight.w700,
    );
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(width: 4),
            for (var i = 0; i < widget.columns.length; i++)
              _headerCell(widget.columns[i], i, style, theme),
            if (widget.trailing != null)
              Container(width: 88, decoration: _cellDivider(theme, false)),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(
      AppDataColumn<T> c, int index, TextStyle? style, ThemeData theme) {
    final sortable = c.sortBy != null;
    final active = _sortColumn == index;
    final label = Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            c.alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              c.label,
              style: active
                  ? style?.copyWith(color: theme.colorScheme.primary)
                  : style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (active)
            Icon(
              _ascending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: theme.colorScheme.primary,
            )
          else if (sortable)
            Icon(Icons.unfold_more, size: 14, color: theme.hintColor),
        ],
      ),
    );
    final decorated = Container(
      decoration: _cellDivider(theme, index == 0),
      child: sortable
          ? InkWell(onTap: () => _onHeaderTap(index), child: label)
          : label,
    );
    return c.width != null
        ? SizedBox(width: c.width, child: decorated)
        : Expanded(flex: c.flex, child: decorated);
  }

  Widget _row(BuildContext context, T row, int index) {
    final theme = Theme.of(context);
    final accent = widget.rowAccent?.call(row);
    // Zebra striping keeps long tables scannable at desktop widths.
    final stripe = index.isOdd
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.22)
        : null;
    final content = Container(
      color: stripe,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accent ?? Colors.transparent),
            for (var i = 0; i < widget.columns.length; i++)
              _cellBox(
                widget.columns[i],
                Container(
                  decoration: _cellDivider(theme, i == 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  child: Align(
                    alignment: widget.columns[i].alignEnd
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: widget.columns[i].cellBuilder(context, row, index),
                  ),
                ),
              ),
            if (widget.trailing != null)
              Container(
                width: 88,
                decoration: _cellDivider(theme, false),
                child: Center(child: widget.trailing!(context, row)),
              ),
          ],
        ),
      ),
    );
    if (widget.onRowTap == null) return content;
    return InkWell(onTap: () => widget.onRowTap!(row), child: content);
  }

  Widget _cellBox(AppDataColumn<T> c, Widget child) => c.width != null
      ? SizedBox(width: c.width, child: child)
      : Expanded(flex: c.flex, child: child);
}
