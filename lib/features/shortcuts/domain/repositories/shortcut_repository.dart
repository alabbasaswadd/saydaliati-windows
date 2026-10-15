import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/shortcuts/domain/entities/shortcut_binding.dart';

/// مصدر حالة الاختصارات الفعّالة.
///
/// الكتالوغ والافتراضيات تعيش في الواجهة ([ShortcutAction])؛ الخادم يخزّن
/// التخصيصات فقط. المستودع هو من يدمج الاثنين فيعيد دوماً قائمة كاملة بكل
/// الإجراءات — فلا تحتاج الشاشات أن تعرف أيّها مخصَّص وأيّها افتراضي.
abstract interface class ShortcutRepository {
  /// كل الإجراءات بتركيباتها الفعّالة (مخزَّن إن وُجد، وإلا الافتراضي).
  /// تعذُّر الوصول للخادم يسقط على آخر نسخة محفوظة محلياً، ثم الافتراضيات —
  /// فالاختصارات تعمل دون اتصال.
  Future<Result<List<ShortcutBinding>>> getBindings();

  /// يحفظ التخصيصات (ما يختلف عن الافتراضي) ويعيد الحالة بعد الحفظ.
  Future<Result<List<ShortcutBinding>>> save(List<ShortcutBinding> bindings);

  /// يعيد الكل لافتراضيّه.
  Future<Result<List<ShortcutBinding>>> resetToDefaults();
}
