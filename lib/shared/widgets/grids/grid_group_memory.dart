import 'package:flutter/widgets.dart';
import 'package:trina_grid/trina_grid.dart';

/// ذاكرة شجرة الشبكة: تُبقي المجموعات المفتوحة والفلترة عبر إعادة البناء.
///
/// **المشكلة التي تحلّها:** مفتاح الشبكة يُشتقّ من البيانات المعروضة (العملة،
/// أساس التسعير، عدد الأسطر…) لأن `TrinaGrid` لا تلتقط صفوفاً جديدة بلا
/// تغيّر مفتاح. فكل تبديل خيارٍ يُعيد بناء الشبكة من الصفر، وتُطوى الشجرة
/// وتُمحى الفلترة — ويعود المستخدم إلى الصفر بعد كل نقرة.
///
/// **لماذا مشتركة:** احتاجتها صفحة الحسابات وتقرير الجرد، وكلّ نسخةٍ ثالثة
/// تعني أن إصلاح عيبٍ في واحدة يترك البقية.
///
/// **كيف تُستعمَل:**
/// ```dart
/// late final _groups = GridGroupMemory(
///   keyField: _fName,              // الحقل الذي يُعرَّف به صفّ المجموعة
///   isMounted: () => mounted,
/// );
/// // في الشبكة:  onLoaded: _groups.attach
/// // في dispose: _groups.dispose()
/// ```
class GridGroupMemory {
  GridGroupMemory({
    required this.keyField,
    required this.isMounted,
    this.rememberFilters = true,
  });

  /// الحقل الذي يُميَّز به صفّ المجموعة (معرّف مخفيّ أو اسم).
  final String keyField;

  /// هل الواجهة ما زالت مُركَّبة — يمنع لمس شبكة زالت.
  final bool Function() isMounted;

  /// حفظ فلترة الأعمدة أيضاً (البحث داخل الشبكة).
  final bool rememberFilters;

  TrinaGridStateManager? _grid;
  final Set<String> _expanded = {};
  List<TrinaRow<dynamic>>? _filters;

  /// أثناء الاستعادة لا تُسجَّل الحالة: الشبكة الجديدة تبدأ مطويّةً بلا
  /// فلترة، فتسجيلها حينها يمحو ما نحاول استعادته.
  bool _restoring = false;

  /// يُربَط بـ`AppGrid.onLoaded`.
  void attach(TrinaGridStateManager manager) {
    _grid?.removeListener(_onChanged);
    _grid = manager;
    manager.addListener(_onChanged);

    if (_expanded.isEmpty && (_filters == null || _filters!.isEmpty)) return;

    // بعد اكتمال الإطار: المجموعات لم تُركَّب بعد أثناء `onLoaded`.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted() || !identical(_grid, manager)) return;
      _restore(manager);
    });
  }


  /// يستبدل صفوف الشبكة **في مكانها** بلا إعادة بنائها.
  ///
  /// البديل كان مفتاحاً مشتقّاً من البيانات يُجبر `TrinaGrid` على إعادة
  /// البناء كي تلتقط الصفوف الجديدة — فيومض الجدول، ويضيع موضع التمرير
  /// وعرض الأعمدة، وتُطوى الشجرة. وهنا تُمحى الصفوف وتُضاف الجديدة على
  /// المدير نفسه، ثم يُعاد فتح ما كان مفتوحاً.
  ///
  /// يعيد `false` إن لم تكن الشبكة مُركَّبة بعد — فيتولّى المفتاح الأمر.
  bool replaceRows(List<TrinaRow<dynamic>> rows) {
    final m = _grid;
    if (m == null) return false;

    // الحالة تُلتقط قبل المحو: الصفوف القديمة هي التي تحمل ما كان مفتوحاً.
    _onChanged();

    _restoring = true;
    try {
      m.removeAllRows(notify: false);
      m.appendRows(rows);
    } finally {
      _restoring = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted() || !identical(_grid, m)) return;
      _restore(m);
    });
    return true;
  }

  void dispose() {
    _grid?.removeListener(_onChanged);
    _grid = null;
  }

  void _onChanged() {
    if (_restoring) return;
    final m = _grid;
    if (m == null) return;

    if (rememberFilters) _filters = List<TrinaRow<dynamic>>.of(m.filterRows);

    _expanded
      ..clear()
      ..addAll(_keysOfExpanded(m));
  }

  void _restore(TrinaGridStateManager m) {
    _restoring = true;
    try {
      final filters = _filters;
      if (rememberFilters && filters != null && filters.isNotEmpty) {
        m.setFilterWithFilterRows(filters, notify: false);
      }

      // التمدّد يُطبَّق على **كل** مجموعة لا على الظاهر فقط: الحفيد لا يظهر
      // قبل فتح أبيه، فالمرور على الظاهر وحده يفتح المستوى الأول فقط.
      for (final row in m.iterateAllRowGroup) {
        final key = row.cells[keyField]?.value?.toString();
        if (key == null || !_expanded.contains(key)) continue;
        m.toggleExpandedRowGroup(rowGroup: row, expanded: true, notify: false);
      }

      m.notifyListeners();
    } finally {
      _restoring = false;
    }
  }

  Iterable<String> _keysOfExpanded(TrinaGridStateManager m) sync* {
    for (final row in m.iterateAllRowGroup) {
      if (!row.type.group.expanded) continue;
      final key = row.cells[keyField]?.value?.toString();
      if (key != null) yield key;
    }
  }
}
