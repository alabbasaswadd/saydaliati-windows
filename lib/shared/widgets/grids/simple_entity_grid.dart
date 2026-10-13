import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// عمود نصي بسيط لغريد كيانات إدارة البيانات.
class SimpleEntityColumn<T> {
  const SimpleEntityColumn(
    this.title,
    this.value, {
    this.width = 160,
    this.hide = false,
  });

  final String title;
  final String Function(T row) value;
  final double width;
  final bool hide;
}

/// غريد كيانات إدارة البيانات (موردون/زبائن/أصناف/شركات/وحدات…) — القالب
/// الموحّد: زر «الأعمدة» أعلى الجدول، فلترة لكل عمود، نقرة مزدوجة أو زر قلم
/// للتعديل، وزر حذف أحمر. يبني الصفوف من [columns] مباشرة بلا أي تخصيص إضافي.
class SimpleEntityGrid<T> extends StatefulWidget {
  const SimpleEntityGrid({
    required this.items,
    required this.columns,
    required this.idOf,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<T> items;
  final List<SimpleEntityColumn<T>> columns;
  final String Function(T row) idOf;
  final void Function(T row) onEdit;
  final void Function(T row) onDelete;

  @override
  State<SimpleEntityGrid<T>> createState() => _SimpleEntityGridState<T>();
}

class _SimpleEntityGridState<T> extends State<SimpleEntityGrid<T>> {
  TrinaGridStateManager? _manager;

  static const _fId = '_id';
  static const _fActions = '_actions';

  @override
  Widget build(BuildContext context) {
    final byId = {for (final it in widget.items) widget.idOf(it): it};
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AppGridColumnsButton(managerGetter: () => _manager),
          ),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: AppGrid(
              key: ValueKey(widget.items.length ^ widget.items.hashCode),
              columns: [
                for (var i = 0; i < widget.columns.length; i++)
                  appGridTextColumn(
                    widget.columns[i].title,
                    'c$i',
                    width: widget.columns[i].width,
                    hide: widget.columns[i].hide,
                  ),
                TrinaColumn(
                  title: '',
                  field: _fActions,
                  type: TrinaColumnType.text(),
                  width: 90,
                  enableEditingMode: false,
                  enableContextMenu: false,
                  enableFilterMenuItem: false,
                  enableSorting: false,
                  renderer: (ctx) {
                    final it = byId[ctx.row.cells[_fId]?.value];
                    if (it == null) return const SizedBox.shrink();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          visualDensity: VisualDensity.compact,
                          tooltip: AppStrings.edit,
                          onPressed: () => widget.onEdit(it),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.error),
                          visualDensity: VisualDensity.compact,
                          tooltip: AppStrings.delete,
                          onPressed: () => widget.onDelete(it),
                        ),
                      ],
                    );
                  },
                ),
                TrinaColumn(
                    title: '',
                    field: _fId,
                    type: TrinaColumnType.text(),
                    hide: true),
              ],
              rows: [
                for (final it in widget.items)
                  TrinaRow(cells: {
                    for (var i = 0; i < widget.columns.length; i++)
                      'c$i': TrinaCell(value: widget.columns[i].value(it)),
                    _fId: TrinaCell(value: widget.idOf(it)),
                  }),
              ],
              onLoaded: (m) => _manager = m,
              onRowDoubleTap: (e) {
                final it = byId[e.row.cells[_fId]?.value];
                if (it != null) widget.onEdit(it);
              },
            ),
          ),
        ],
      ),
    );
  }
}
