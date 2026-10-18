import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shortcut_hints_setting.g.dart';

/// إظهار شريط تلميحات اختصارات الفاتورة على الشاشة.
///
/// **محلّي لا على الخادم** عن قصد: هذا تفضيل عرضٍ لجهازٍ بعينه لا سياسة
/// صيدلية. فكاشير جديد يُبقيه ظاهراً حتى يحفظ الاختصارات، وآخر مُتمكِّن
/// يُخفيه ليكسب سطراً من الشاشة — ولا معنى لمزامنة ذلك بين الأجهزة.
///
/// الافتراضي **ظاهر**: الاختصارات ميزةٌ لا يعرفها مَن لا يراها، وإخفاؤها
/// افتراضياً يجعلها حبيسة شاشة الإعدادات.
@Riverpod(keepAlive: true)
class ShowShortcutHints extends _$ShowShortcutHints {
  static const _key = 'show_invoice_shortcut_hints';

  @override
  bool build() {
    // القراءة غير متزامنة، فتبدأ الحالة بالافتراضي ثم تُصحَّح إن خُزِّن غيره.
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(_key);
    if (stored != null && stored != state) state = stored;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  Future<void> toggle() => set(!state);
}
