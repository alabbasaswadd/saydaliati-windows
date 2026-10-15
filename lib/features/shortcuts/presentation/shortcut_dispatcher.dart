import 'package:flutter/widgets.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';

/// سجلّ معالجات الاختصارات التي تُسجّلها الشاشات أثناء وجودها.
///
/// إجراءات التنقّل يُنفّذها `ShortcutsScope` مركزياً، أمّا إجراءات الفاتورة
/// (حفظ، حذف سطر، تعديل كمية…) فلا تعرفها إلا شاشة الفاتورة نفسها — فتُسجّل
/// معالجاتها هنا عند `initState` وتُزيلها عند `dispose`.
///
/// خدمة عادية لا `Notifier`: التسجيل يقع داخل دورة حياة الودجت (`initState`
/// و`didUpdateWidget`)، وتعديل حالة مزوِّد هناك ممنوع في Riverpod. ولا شيء
/// يحتاج أن «يستمع» لتغيّر المعالجات أصلاً — تُقرأ لحظة ضغط المفتاح فقط.
class ShortcutHandlers {
  final Map<ShortcutAction, VoidCallback> _handlers = {};

  /// صاحب كل تسجيل — لمنع تاب مُغلَق من إلغاء معالج تابٍ آخر.
  final Map<ShortcutAction, Object> _owners = {};

  /// يسجّل (أو يستبدل) معالجات [owner]. آخر من يسجّل على إجراء هو صاحبه.
  void register(Object owner, Map<ShortcutAction, VoidCallback> handlers) {
    for (final entry in handlers.entries) {
      _handlers[entry.key] = entry.value;
      _owners[entry.key] = owner;
    }
  }

  /// يزيل ما سجّله [owner] فقط.
  void unregister(Object owner) {
    for (final action in ShortcutAction.values) {
      if (identical(_owners[action], owner)) {
        _handlers.remove(action);
        _owners.remove(action);
      }
    }
  }

  /// ينفّذ معالج [action] إن كان مسجَّلاً. يعيد `true` إن استُهلك الاختصار.
  bool invoke(ShortcutAction action) {
    final handler = _handlers[action];
    if (handler == null) return false;
    handler();
    return true;
  }
}
