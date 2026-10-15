import 'package:flutter/widgets.dart';
import 'package:trina_grid/trina_grid.dart';

/// تتبُّع «السطر النشِط» في شبكة فاتورة، ليعمل عليه اختصار تغيير الكمية
/// وحذف السطر.
///
/// **لماذا مشترك:** المنطق نفسه تحتاجه فاتورة المبيعات والمشتريات ومرتجعاهما.
/// ثلاث نسخ منه تعني أن إصلاح عيبٍ في واحدة يترك الثلاث الأخرى — وقد حدث:
/// كان يعمل في المبيعات وحدها.
///
/// **المشكلتان الحقيقيتان** التي يحلّهما:
///
/// 1. **مدير الشبكة يتغيّر مع كل إعادة بناء**، فالتحديد يضيع. لذا يُحفَظ
///    المُعرّف ويُعاد ضبط الخلية بعد اكتمال الإطار — أثناء `onLoaded` لم
///    تُركَّب الصفوف بعد.
///
/// 2. **لا تحديد بعد إضافة مادة.** فالأولوية: مؤشّر الشبكة، ثم المُعرّف
///    المحفوظ، ثم **آخر سطر** — لأن المقصود عملياً حين لا تحديد (أو حين
///    المؤشّر على صفّ الإضافة) هو السطر الذي أُضيف للتوّ.
class GridLineFocus {
  GridLineFocus({
    required this.idField,
    required this.qtyField,
    required this.rowIds,
    required this.isMounted,
    this.skipRowId,
  });

  /// اسم حقل مُعرّف السطر في الشبكة (عمود مخفيّ عادةً).
  final String idField;

  /// اسم حقل الكمية — الخلية التي يُنقَل إليها التركيز.
  final String qtyField;

  /// مُعرّفات الأسطر بترتيب عرضها — تُقرأ عند الحاجة لا تُخزَّن، فتبقى
  /// مطابقة للحالة بعد الإضافة والحذف.
  final List<String> Function() rowIds;

  /// هل الواجهة ما زالت مُركَّبة — يمنع لمس شبكة زالت.
  final bool Function() isMounted;

  /// مُعرّف «صفّ الإضافة» إن وُجد: لا يُعدّ سطراً نشِطاً.
  final String? skipRowId;

  TrinaGridStateManager? _grid;
  String? _savedId;

  TrinaGridStateManager? get grid => _grid;

  /// مُعرّف السطر الذي تعمل عليه الاختصارات.
  String? get currentId {
    final fromGrid = _grid?.currentRow?.cells[idField]?.value?.toString();
    if (fromGrid != null && fromGrid != skipRowId) return fromGrid;

    final ids = rowIds();
    if (_savedId != null && ids.contains(_savedId)) return _savedId;
    return ids.isEmpty ? null : ids.last;
  }

  /// يجعل [id] هو السطر النشِط — يُستدعى بعد إضافة مادة فيصبح السطر الجديد
  /// جاهزاً للاختصارات بلا نقرة.
  void select(String id) => _savedId = id;

  /// يُربَط بـ`AppGrid.onLoaded`: يُسجّل المدير الجديد ويعيد التحديد.
  void attach(TrinaGridStateManager manager) {
    _grid?.removeListener(_onSelectionChanged);
    _grid = manager;
    manager.addListener(_onSelectionChanged);
    _restore();
  }

  void dispose() {
    _grid?.removeListener(_onSelectionChanged);
    _grid = null;
  }

  /// ينقل التركيز إلى خلية كمية السطر النشِط، ويفتحها للتحرير عند
  /// [startEditing]. يعيد `false` إن لم يوجد سطر أو خلية.
  bool focusQty({required bool startEditing}) {
    final id = currentId;
    final grid = _grid;
    if (id == null || grid == null) return false;
    return _focus(grid, id, startEditing: startEditing);
  }

  /// بعد حذف سطر: ينقل التحديد إلى ما قبله (أو ما بعده) فيبقى الحذف
  /// المتتابع ممكناً بلا نقرة.
  void selectNeighbourOf(String removedId, List<String> idsBeforeRemoval) {
    final i = idsBeforeRemoval.indexOf(removedId);
    if (i < 0) {
      _savedId = null;
      return;
    }
    if (i > 0) {
      _savedId = idsBeforeRemoval[i - 1];
    } else if (idsBeforeRemoval.length > 1) {
      _savedId = idsBeforeRemoval[i + 1];
    } else {
      _savedId = null;
    }
  }

  void _onSelectionChanged() {
    final id = _grid?.currentRow?.cells[idField]?.value?.toString();
    if (id == null || id == skipRowId) return;
    _savedId = id;
  }

  void _restore() {
    final id = _savedId;
    final grid = _grid;
    if (id == null || grid == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted() || !identical(_grid, grid)) return;
      _focus(grid, id, startEditing: false);
    });
  }

  bool _focus(
    TrinaGridStateManager grid,
    String id, {
    required bool startEditing,
  }) {
    final index =
        grid.refRows.indexWhere((r) => r.cells[idField]?.value?.toString() == id);
    if (index < 0) return false;
    final cell = grid.refRows[index].cells[qtyField];
    if (cell == null) return false;

    // الشبكة قد تكون بلا تركيز (أُغلق منتقي الدواء للتوّ)، وبلا تركيزها لا
    // تستقبل خليةُ التحرير ما يُكتَب. وطلب التركيز يتأخّر إطاراً كاملاً،
    // فيأتي فتح التحرير بعده لا معه.
    if (startEditing) grid.setKeepFocus(true);
    grid.setCurrentCell(cell, index);
    if (!startEditing) return true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted() || !identical(_grid, grid)) return;
      grid.setEditing(true);
    });
    return true;
  }
}
