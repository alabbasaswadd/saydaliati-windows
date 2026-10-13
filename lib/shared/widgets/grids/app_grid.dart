import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:trina_grid/trina_grid.dart';

/// الغريد الحقيقي الموحّد للمشروع — TrinaGrid (خليفة PlutoGrid المصان) مهيّأ
/// على ثيم التطبيق: أعمدة بفواصل، صف فلترة «يحتوي» تحت كل رأس، أسطر مفصولة،
/// صفوف مخططة، فرز وسحب للأعمدة، ودعم شجرة (فاتورة ← بنودها).
///
/// استخدم هذا الغلاف في كل الشاشات بدل استدعاء TrinaGrid مباشرة حتى يبقى
/// المظهر موحّداً ويُعدَّل من مكان واحد.
TrinaGridConfiguration appGridConfiguration(BuildContext context) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final border = context.semantic.border;
  return TrinaGridConfiguration(
    // تمدد تلقائي: الأعمدة تتوزّع على كامل عرض الشبكة بنسبة عرضها المحدد،
    // وتعديل عرض عمود يدوياً يدفع/يسحب جيرانه فيبقى الجدول مالئاً للشاشة.
    columnSize: const TrinaGridColumnSizeConfig(
      autoSizeMode: TrinaAutoSizeMode.scale,
      resizeMode: TrinaResizeMode.pushAndPull,
    ),
    style: TrinaGridStyleConfig(
      gridBackgroundColor: scheme.surface,
      rowColor: scheme.surface,
      // صفوف مخططة — قراءة أسهل للجداول الطويلة.
      oddRowColor: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
      activatedColor: scheme.primary.withValues(alpha: 0.08),
      activatedBorderColor: scheme.primary,
      inactivatedBorderColor: Colors.transparent,
      cellColorInReadOnlyState: Colors.transparent,
      // أثناء التحرير تبقى الخلية بمظهرها (خلفية السطح نفسها مع إطار التفعيل
      // الأخضر) بدل حقل أبيض غريب يغطي تصميم الخلية.
      cellColorInEditState: scheme.surface,
      cellActiveColor: scheme.primary.withValues(alpha: 0.08),
      gridBorderColor: border,
      borderColor: border,
      iconColor: scheme.primary,
      menuBackgroundColor: scheme.surface,
      columnTextStyle: theme.textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w700,
        color: scheme.onSurfaceVariant,
      ),
      cellTextStyle: theme.textTheme.bodyMedium!,
      columnHeight: 38,
      rowHeight: 36,
      columnFilterHeight: 36,
      defaultColumnFilterPadding: const EdgeInsets.all(4),
      enableColumnBorderVertical: true,
      enableColumnBorderHorizontal: true,
      enableCellBorderVertical: true,
      enableCellBorderHorizontal: true,
      gridBorderRadius: BorderRadius.circular(8),
      gridPopupBorderRadius: BorderRadius.circular(8),
    ),
    localeText: const TrinaGridLocaleText.arabic(),
  );
}

/// قائمة العمود المخصّصة: تضيف «ترتيب تصاعدي/تنازلي» فوق عناصر القائمة
/// الافتراضية (تجميد للبداية/النهاية، ملاءمة، إخفاء، تعيين الأعمدة، الفلترة).
class _AppColumnMenuDelegate implements TrinaColumnMenuDelegate<dynamic> {
  const _AppColumnMenuDelegate();

  static const _sortAsc = 'app_sortAsc';
  static const _sortDesc = 'app_sortDesc';
  static const _default = TrinaColumnMenuDelegateDefault();

  @override
  List<PopupMenuEntry<dynamic>> buildMenuItems({
    required TrinaGridStateManager stateManager,
    required TrinaColumn column,
  }) {
    return [
      if (column.enableSorting) ...[
        const PopupMenuItem<dynamic>(
          value: _sortAsc,
          height: 36,
          child: Row(
            children: [
              Icon(Icons.arrow_upward, size: 15),
              SizedBox(width: 8),
              Text('ترتيب تصاعدي', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuItem<dynamic>(
          value: _sortDesc,
          height: 36,
          child: Row(
            children: [
              Icon(Icons.arrow_downward, size: 15),
              SizedBox(width: 8),
              Text('ترتيب تنازلي', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuDivider(),
      ],
      ..._default.buildMenuItems(stateManager: stateManager, column: column),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required TrinaGridStateManager stateManager,
    required TrinaColumn column,
    required bool mounted,
    required dynamic selected,
  }) {
    switch (selected) {
      case _sortAsc:
        stateManager.sortAscending(column);
      case _sortDesc:
        stateManager.sortDescending(column);
      default:
        _default.onSelected(
          context: context,
          stateManager: stateManager,
          column: column,
          mounted: mounted,
          selected: selected,
        );
    }
  }
}

class AppGrid extends StatelessWidget {
  const AppGrid({
    required this.columns,
    required this.rows,
    this.onLoaded,
    this.rowColorCallback,
    this.onRowDoubleTap,
    this.onChanged,
    this.showColumnFilter = true,
    this.tree = false,
    super.key,
  });

  /// تغيّرت قيمة خلية قابلة للتعديل (بعد الخروج منها/Enter).
  final void Function(TrinaGridOnChangedEvent event)? onChanged;

  final List<TrinaColumn> columns;
  final List<TrinaRow<dynamic>> rows;

  /// نقرة مزدوجة على صف (فتح التفاصيل…).
  final TrinaOnRowDoubleTapEventCallback? onRowDoubleTap;

  /// يُستدعى بعد تهيئة الشبكة (للاحتفاظ بالـ state manager مثلاً).
  final void Function(TrinaGridStateManager manager)? onLoaded;

  /// تلوين صف حسب حالته (بيع بخسارة…) — يسبق التخطيط.
  final TrinaRowColorCallback? rowColorCallback;

  /// صف الفلترة «يحتوي» تحت رؤوس الأعمدة.
  final bool showColumnFilter;

  /// شجرة: صفوف `TrinaRowType.group` تتوسّع لأبنائها بأيقونة على أول عمود.
  final bool tree;

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      columns: columns,
      rows: rows,
      configuration: appGridConfiguration(context),
      columnMenuDelegate: const _AppColumnMenuDelegate(),
      rowColorCallback: rowColorCallback,
      onRowDoubleTap: onRowDoubleTap,
      onChanged: onChanged,
      onLoaded: (TrinaGridOnLoadedEvent event) {
        final m = event.stateManager;
        m.setShowColumnFilter(showColumnFilter);
        if (tree) {
          m.setRowGroup(
            TrinaRowGroupTreeDelegate(
              resolveColumnDepth: (column) => m.columnIndex(column),
              showText: (cell) => true,
              showFirstExpandableIcon: true,
            ),
          );
        }
        onLoaded?.call(m);
      },
    );
  }
}

/// عمود نصي جاهز للقراءة فقط.
TrinaColumn appGridTextColumn(
  String title,
  String field, {
  double width = 140,
  bool flexible = false,
  bool hide = false,
  TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.right,
  Widget Function(TrinaColumnRendererContext ctx)? renderer,
}) {
  return TrinaColumn(
    title: title,
    field: field,
    type: TrinaColumnType.text(),
    textAlign: textAlign,
    enableEditingMode: false,
    width: width,
    minWidth: flexible ? width : 60,
    hide: hide,
    renderer: renderer,
  );
}

/// عمود أرقام/مبالغ جاهز للقراءة فقط.
///
/// `locale: 'en'` + إلغاء التنسيق على التهيئة: تنسيق intl العربي يسبق إشارة
/// السالب بمحرف LRM فيفسد إعادة التحليل ويحوّل السوالب أصفاراً (نفس علاج وكيد).
TrinaColumn appGridNumberColumn(
  String title,
  String field, {
  double width = 110,
  String format = '#,##0.##',
  bool hide = false,
  // صفر = خلية فارغة (في كل التقارير والجداول) ما لم يُمرَّر renderer خاص.
  bool zeroAsBlank = true,
  Widget Function(TrinaColumnRendererContext ctx)? renderer,
}) {
  return TrinaColumn(
    title: title,
    field: field,
    type: TrinaColumnType.number(
      format: format,
      locale: 'en',
      applyFormatOnInit: false,
    ),
    textAlign: TrinaColumnTextAlign.center,
    enableEditingMode: false,
    width: width,
    hide: hide,
    renderer: renderer ?? (zeroAsBlank ? _zeroAsBlankNumberRenderer : null),
  );
}

/// عرض افتراضي لأعمدة الأرقام: خلية فارغة عند الصفر/الفراغ، وإلا رقم LTR
/// (حتى لا تظهر إشارة السالب بموضع مضلِّل وسط سياق RTL).
Widget _zeroAsBlankNumberRenderer(TrinaColumnRendererContext ctx) {
  final v = ctx.cell.value;
  final n = v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '');
  if (n == null || n == 0) return const SizedBox.shrink();
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Text(Formatters.number(n), textAlign: TextAlign.center),
  );
}

/// زر «الأعمدة»: يفتح نافذة إظهار/إخفاء أعمدة الشبكة (TrinaGrid المدمجة).
class AppGridColumnsButton extends StatelessWidget {
  const AppGridColumnsButton({required this.managerGetter, super.key});

  /// يُرجع مدير الشبكة المحفوظ من [AppGrid.onLoaded] (أو null قبل التهيئة).
  final TrinaGridStateManager? Function() managerGetter;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'إظهار/إخفاء الأعمدة',
      icon: const Icon(Icons.view_column_outlined),
      onPressed: () => managerGetter()?.showSetColumnsPopup(context),
    );
  }
}
