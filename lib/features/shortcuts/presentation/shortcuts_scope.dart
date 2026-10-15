import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcut_dispatcher.dart';
import 'package:saydaliati/features/shortcuts/shortcut_providers.dart';

/// معالج الاختصارات العام — يغلّف محتوى القشرة المكتبية.
///
/// يلتقط الضغطات من [HardwareKeyboard] مباشرة لا من سلسلة التركيز: الاختصار
/// العام يجب أن يعمل أياً كان العنصر المركَّز عليه (أو حين لا يكون شيء مركَّزاً
/// أصلاً، وهو الحال بعد نقرة على مساحة فارغة).
///
/// الحمايات المقصودة:
///  * شاشة حوار مفتوحة فوق القشرة ⇒ لا تُلتقط الاختصارات (الحوار هو السياق).
///  * تركيبة بلا مُعدِّل (F2، Delete…) أثناء الكتابة في حقل ⇒ تبقى للحقل.
class ShortcutsScope extends ConsumerStatefulWidget {
  const ShortcutsScope({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ShortcutsScope> createState() => _ShortcutsScopeState();
}

class _ShortcutsScopeState extends ConsumerState<ShortcutsScope> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التركيز التلقائي باقٍ كما كان في القشرة (قارئ الباركود وتمرير لوحة
    // المفاتيح يعتمدانه)؛ التقاط الاختصارات لم يعد مرتبطاً به.
    return Focus(autofocus: true, child: widget.child);
  }

  /// يعيد `true` إن استهلك الاختصار الضغطة.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!mounted) return false;

    // حوار أو صفحة مدفوعة فوق القشرة ⇒ السياق لها، لا للاختصارات العامة.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return false;

    final combo = KeyCombo.fromKeyEvent(event);
    if (combo == null) return false;

    final action = ref.read(shortcutLookupProvider)[combo];
    if (action == null) return false;

    // أثناء الكتابة في حقل (أو تحرير خلية في الجدول) تبقى للحقل: المفاتيح
    // المفردة، واختصارات التحرير القياسية (نسخ/قص/لصق/تراجع/تحديد الكل) —
    // وإلا ابتُلع Ctrl+C داخل خلية بدل أن ينسخ.
    if (_isTyping() && (!combo.hasModifier || _isEditingCombo(combo))) {
      return false;
    }

    if (_handleNavigation(action)) return true;

    return ref.read(shortcutHandlersProvider).invoke(action);
  }

  /// مفاتيح التحرير القياسية مع Ctrl — ملكٌ لحقل الإدخال وهو قيد الكتابة.
  static const _editingKeys = {'C', 'X', 'V', 'Z', 'A'};

  bool _isEditingCombo(KeyCombo combo) =>
      combo.modifier == ShortcutModifier.ctrl &&
      _editingKeys.contains(combo.key);

  /// هل التركيز داخل حقل إدخال نصّي الآن؟
  bool _isTyping() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    if (ctx == null) return false;
    if (ctx.widget is EditableText) return true;
    var found = false;
    ctx.visitChildElements((el) {
      if (!found && el.widget is EditableText) found = true;
    });
    return found;
  }

  /// إجراءات التنقّل — مركزية هنا لأنها تعمل من أي شاشة.
  bool _handleNavigation(ShortcutAction action) {
    final route = _routes[action];
    if (route == null) return false;
    context.go(route);
    return true;
  }

  static const Map<ShortcutAction, String> _routes = {
    ShortcutAction.navSales: AppRoutes.sales,
    ShortcutAction.navPurchases: AppRoutes.purchases,
    ShortcutAction.navSalesReturns: AppRoutes.salesReturns,
    ShortcutAction.navPurchaseReturns: AppRoutes.purchaseReturns,
    ShortcutAction.navMedicines: AppRoutes.products,
    ShortcutAction.navStock: AppRoutes.inventory,
    ShortcutAction.navAccounts: AppRoutes.accounts,
    ShortcutAction.navSalesReport: AppRoutes.salesReport,
  };
}

/// يربط معالجات اختصارات شاشة بعمرها: يسجّلها عند الإنشاء ويزيلها عند الإزالة.
///
/// يُستعمل من `State` الشاشة:
/// ```dart
/// late final _shortcuts = ShortcutRegistration(ref, this);
/// // في initState:  _shortcuts.bind({ShortcutAction.invoiceSave: _submit});
/// // في dispose:    _shortcuts.dispose();
/// ```
class ShortcutRegistration {
  /// يُحلّ السجلّ مرّة واحدة عند الإنشاء ويُحفَظ في حقل.
  ///
  /// قراءة مزوِّد داخل `State.dispose()` ممنوعة في Riverpod (الـ`BuildContext`
  /// يكون قد أُبطِل)، وكانت ترمي `Bad state: Using "ref" when a widget is
  /// about to or has been unmounted` فتنهار الشجرة كلّها. السجلّ مزوِّد
  /// `keepAlive` فنسخته ثابتة طوال عمر التطبيق — حفظها آمن تماماً.
  ShortcutRegistration(WidgetRef ref, this._owner)
      : _handlers = ref.read(shortcutHandlersProvider);

  final ShortcutHandlers _handlers;
  final Object _owner;

  void bind(Map<ShortcutAction, VoidCallback> handlers) =>
      _handlers.register(_owner, handlers);

  void dispose() => _handlers.unregister(_owner);
}
