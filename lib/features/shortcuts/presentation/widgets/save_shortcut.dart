import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/shortcut_providers.dart';

/// يربط اختصار «الحفظ» بزرّ حفظ الشاشة أو النافذة التي يغلّفها.
///
/// لماذا لا يكفي الموزِّع العام؟ لأنه يتنحّى عمداً حين تُفتح نافذة فوق القشرة
/// (السياق حينها للنافذة)، ولأن معظم شاشات الحفظ في المشروع نوافذ حوار. هذا
/// الغلاف يربط الاختصار **محلياً** عبر سلسلة التركيز، فيعمل داخل النوافذ
/// والصفحات على حدّ سواء.
///
/// التركيبة ليست ثابتة: تُقرأ من إعدادات الاختصارات، فتغييرها من شاشة
/// الاختصارات يسري هنا فوراً.
///
/// ```dart
/// SaveShortcut(
///   onSave: _submit,
///   enabled: !_saving,
///   child: AlertDialog(...),
/// )
/// ```
class SaveShortcut extends ConsumerWidget {
  const SaveShortcut({
    required this.onSave,
    required this.child,
    this.enabled = true,
    super.key,
  });

  /// ما يُنفَّذ عند الاختصار — نفس ما يفعله زرّ الحفظ تماماً.
  final VoidCallback onSave;

  /// `false` أثناء الحفظ أو حين يكون النموذج غير صالح ⇒ يُتجاهل الاختصار.
  final bool enabled;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combo = _resolveCombo(ref);
    final activator = _activatorFor(combo);
    if (activator == null || !enabled) return child;

    return CallbackShortcuts(
      bindings: {activator: onSave},
      // Focus يضع هذه العقدة في سلسلة التركيز فتصل إليها الضغطات الصاعدة من
      // الحقول داخل النموذج.
      child: Focus(autofocus: false, child: child),
    );
  }

  /// تركيبة الحفظ الفعّالة، أو الافتراضية ريثما تصل الإعدادات من الخادم.
  KeyCombo _resolveCombo(WidgetRef ref) {
    const action = ShortcutAction.invoiceSave;
    final bindings = ref.watch(shortcutBindingsProvider).value;
    if (bindings == null) return action.defaultKeyCombo;

    final binding =
        bindings.where((b) => b.action == action).firstOrNull;
    if (binding == null || !binding.isEnabled) return action.defaultKeyCombo;
    return binding.combo;
  }

  static SingleActivator? _activatorFor(KeyCombo combo) {
    final key = combo.logicalKey;
    if (key == null) return null;
    return SingleActivator(
      key,
      control: combo.modifier == ShortcutModifier.ctrl,
      alt: combo.modifier == ShortcutModifier.alt,
      shift: combo.modifier == ShortcutModifier.shift,
    );
  }
}
