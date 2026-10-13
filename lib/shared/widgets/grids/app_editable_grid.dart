import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// الغريد الموحّد للمشروع — THE single editable grid for the whole project.
///
/// Visually it follows the expiry-report grid style: one card, a muted header
/// row, divided rows, and an optional thin leading accent bar per row. All
/// colors come from the app theme (works in light & dark).
///
/// It is generic over the row type and editable through cell widgets:
/// [AppGridNumberCell], [AppGridDropdownCell], [AppGridDateCell],
/// [AppGridTextCell] and the read-only [AppGridText]. Invoice pages (sales /
/// purchases) and any future screen should build on THIS widget — extend it
/// here rather than forking per-screen grids.
class AppGridColumn<T> {
  const AppGridColumn({
    required this.label,
    required this.cellBuilder,
    this.flex = 1,
    this.width,
    this.alignEnd = false,
  });

  final String label;

  /// Relative width. Ignored when [width] is set.
  final int flex;

  /// Fixed width in logical pixels (e.g. a delete button column).
  final double? width;

  /// End-align the header + cell (numbers / totals).
  final bool alignEnd;

  final Widget Function(BuildContext context, T row, int index) cellBuilder;
}

class AppEditableGrid<T> extends StatelessWidget {
  const AppEditableGrid({
    required this.columns,
    required this.rows,
    this.onDeleteRow,
    this.canDeleteRow,
    this.rowAccent,
    this.rowBackground,
    this.emptyMessage,
    this.minWidth = 720,
    this.expand = true,
    super.key,
  });

  final List<AppGridColumn<T>> columns;
  final List<T> rows;

  /// When set, a trailing ✕ column is added.
  final void Function(T row, int index)? onDeleteRow;

  /// Hides the ✕ for specific rows (e.g. the trailing "new row" placeholder).
  final bool Function(T row)? canDeleteRow;

  /// Thin leading accent bar per row (e.g. warning for negative profit) —
  /// same affordance as the expiry grid. Return null for no accent.
  final Color? Function(T row)? rowAccent;

  /// Optional row tint (kept subtle; prefer [rowAccent]).
  final Color? Function(T row)? rowBackground;

  final String? emptyMessage;

  /// Below this width the grid scrolls horizontally instead of squeezing.
  final double minWidth;

  /// true → header fixed + rows scroll vertically (use inside Expanded).
  /// false → lays out all rows (use inside an outer scroll view).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (rows.isEmpty && emptyMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          emptyMessage!,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsHScroll =
            constraints.hasBoundedWidth && constraints.maxWidth < minWidth;
        final grid = _buildGrid(context, theme);
        if (!needsHScroll) return grid;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: minWidth, child: grid),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, ThemeData theme) {
    final header = _HeaderRow(columns: columns, hasDelete: onDeleteRow != null);
    final body = expand
        ? Expanded(
            child: ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _row(context, i),
            ),
          )
        : Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                _row(context, i),
              ],
            ],
          );

    // Dense bordered grid (wakeed-style): tight radius, hairline outline —
    // matches AppDataGrid so edit & read grids share one visual language.
    return Builder(
      builder: (context) => Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brSm,
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [header, const Divider(height: 1), body],
        ),
      ),
    );
  }

  /// Vertical column separator (grid lines) — on every cell after the first.
  static BoxDecoration? _cellDivider(ThemeData theme, bool first) => first
      ? null
      : BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: theme.dividerColor),
          ),
        );

  Widget _row(BuildContext context, int index) {
    final theme = Theme.of(context);
    final row = rows[index];
    final accent = rowAccent?.call(row);
    // Explicit row tint wins; otherwise subtle zebra striping.
    final bg = rowBackground?.call(row) ??
        (index.isOdd
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.22)
            : null);
    return Container(
      color: bg,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accent ?? Colors.transparent),
            for (var i = 0; i < columns.length; i++)
              _cellBox(
                columns[i],
                Container(
                  decoration: _cellDivider(theme, i == 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Align(
                    alignment: columns[i].alignEnd
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: columns[i].cellBuilder(context, row, index),
                  ),
                ),
              ),
            if (onDeleteRow != null)
              Container(
                width: 44,
                decoration: _cellDivider(theme, false),
                child: (canDeleteRow?.call(row) ?? true)
                    ? Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: AppSizes.iconSm,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          visualDensity: VisualDensity.compact,
                          tooltip: MaterialLocalizations.of(context)
                              .deleteButtonTooltip,
                          onPressed: () => onDeleteRow!(row, index),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _cellBox(AppGridColumn<T> c, Widget child) => c.width != null
      ? SizedBox(width: c.width, child: child)
      : Expanded(flex: c.flex, child: child);
}

class _HeaderRow<T> extends StatelessWidget {
  const _HeaderRow({required this.columns, required this.hasDelete});

  final List<AppGridColumn<T>> columns;
  final bool hasDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.hintColor,
      fontWeight: FontWeight.w700,
    );
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const SizedBox(width: 4),
          for (final c in columns)
            c.width != null
                ? SizedBox(
                    width: c.width,
                    child: _label(c, style),
                  )
                : Expanded(flex: c.flex, child: _label(c, style)),
          if (hasDelete) const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _label(AppGridColumn<T> c, TextStyle? style) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Text(
          c.label,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: c.alignEnd ? TextAlign.end : TextAlign.start,
        ),
      );
}

// ─── Cell widgets ───────────────────────────────────────────────────────────

/// Read-only grid text (names, totals). [emphasized] uses the primary color +
/// bold, like the trailing value in the expiry grid.
class AppGridText extends StatelessWidget {
  const AppGridText(
    this.text, {
    this.emphasized = false,
    this.secondary = false,
    this.color,
    super.key,
  });

  final String text;
  final bool emphasized;
  final bool secondary;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: emphasized
          ? theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.primary,
            )
          : secondary
              ? theme.textTheme.bodySmall?.copyWith(
                  color: color ?? theme.colorScheme.onSurfaceVariant)
              : theme.textTheme.bodyMedium?.copyWith(color: color),
    );
  }
}

/// Compact inline decoration shared by the editable cells — the "wakeed"
/// field look: a filled, rounded field with a hairline outline that lights up
/// with the primary color on focus. All colors come from the theme.
InputDecoration gridCellDecoration(BuildContext context, {String? hint}) {
  final theme = Theme.of(context);
  OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
        borderRadius: AppRadius.brSm,
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: theme.colorScheme.surface,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
    border: border(context.semantic.border, 0.6),
    enabledBorder: border(context.semantic.border, 0.6),
    focusedBorder: border(theme.colorScheme.primary, 1.5),
  );
}

/// Inline free-text cell. Pass an external [controller] (the page owns it) or
/// a plain [value] (the cell owns its controller and reports via [onChanged]).
class AppGridTextCell extends StatefulWidget {
  const AppGridTextCell({
    this.controller,
    this.value,
    this.hint,
    this.onChanged,
    this.numeric = false,
    this.textAlign = TextAlign.start,
    super.key,
  }) : assert(controller == null || value == null,
            'Pass either controller or value, not both');

  final TextEditingController? controller;
  final String? value;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool numeric;
  final TextAlign textAlign;

  @override
  State<AppGridTextCell> createState() => _AppGridTextCellState();
}

class _AppGridTextCellState extends State<AppGridTextCell> {
  TextEditingController? _own;
  final _focus = FocusNode();

  TextEditingController get _ctrl =>
      widget.controller ?? (_own ??= TextEditingController(text: widget.value));

  @override
  void didUpdateWidget(covariant AppGridTextCell old) {
    super.didUpdateWidget(old);
    // External value changed while not editing → reflect it.
    if (widget.controller == null &&
        widget.value != old.value &&
        !_focus.hasFocus) {
      _own?.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _own?.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      focusNode: _focus,
      textAlign: widget.textAlign,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: gridCellDecoration(context, hint: widget.hint),
      keyboardType: widget.numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: widget.numeric
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      onChanged: widget.onChanged,
    );
  }
}

/// Inline numeric cell — [AppGridTextCell] with number keyboard/formatters and
/// a parsed-double callback.
class AppGridNumberCell extends StatelessWidget {
  const AppGridNumberCell({
    this.controller,
    this.value,
    this.hint,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final double? value;
  final String? hint;
  final ValueChanged<double>? onChanged;

  /// Plain parse-safe number text (no grouping separators).
  static String format(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  Widget build(BuildContext context) {
    return AppGridTextCell(
      controller: controller,
      value: value == null ? null : format(value!),
      hint: hint,
      numeric: true,
      onChanged: onChanged == null
          ? null
          : (s) {
              final d = double.tryParse(s.trim());
              if (d != null) onChanged!(d);
            },
    );
  }
}

/// Inline dropdown cell (unit, batch…). Underline-only like the other cells.
class AppGridDropdownCell<V> extends StatelessWidget {
  const AppGridDropdownCell({
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    super.key,
  });

  final List<(V, String)> items;
  final V? value;
  final ValueChanged<V?> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<V>(
      initialValue: value,
      isExpanded: true,
      isDense: true,
      hint: hint == null ? null : Text(hint!, style: theme.textTheme.bodySmall),
      style: theme.textTheme.bodyMedium,
      decoration: gridCellDecoration(context),
      items: [
        for (final (v, label) in items)
          DropdownMenuItem<V>(
            value: v,
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

/// Wakeed-style selector cell: a modern field with a search icon that opens a
/// picker (dialog/sheet) on tap — selection happens AT the cell. Shows [text]
/// when a value is chosen, otherwise the [hint].
class AppGridPickerCell extends StatelessWidget {
  const AppGridPickerCell({
    required this.onPick,
    this.text,
    this.hint,
    this.emphasizedHint = false,
    super.key,
  });

  final String? text;
  final String? hint;

  /// Opens the picker. The caller applies the selection and rebuilds.
  final Future<void> Function() onPick;

  /// Tint the empty state with the primary color (the "add here" row).
  final bool emphasizedHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = text != null && text!.isNotEmpty;
    return InkWell(
      onTap: onPick,
      borderRadius: AppRadius.brSm,
      child: InputDecorator(
        decoration: gridCellDecoration(context),
        child: Row(
          children: [
            Icon(
              hasValue ? Icons.edit_outlined : Icons.search,
              size: AppSizes.iconSm,
              color: emphasizedHint && !hasValue
                  ? theme.colorScheme.primary
                  : theme.hintColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                hasValue ? text! : (hint ?? ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: hasValue
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodySmall?.copyWith(
                        color: emphasizedHint
                            ? theme.colorScheme.primary
                            : theme.hintColor,
                        fontWeight: emphasizedHint ? FontWeight.w600 : null,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline date cell — shows the date (or a hint) and opens the date picker.
class AppGridDateCell extends StatelessWidget {
  const AppGridDateCell({
    required this.value,
    required this.onChanged,
    this.hint,
    super.key,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? hint;

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 15),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: AppRadius.brSm,
      child: InputDecorator(
        decoration: gridCellDecoration(context),
        child: Row(
          children: [
            Icon(Icons.event_outlined,
                size: AppSizes.iconSm, color: theme.hintColor),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                value != null ? _ymd(value!) : (hint ?? ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: value != null
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
