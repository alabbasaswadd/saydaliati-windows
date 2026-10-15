import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';

/// ربط إجراء بتركيبة مفاتيح — الحالة الفعّالة بعد دمج المخزَّن مع الافتراضي.
class ShortcutBinding {
  const ShortcutBinding({
    required this.action,
    required this.combo,
    this.isEnabled = true,
    this.isCustom = false,
  });

  /// ربط الإجراء بافتراضيّه (لا تخصيص مخزَّن).
  ShortcutBinding.fromDefault(this.action)
      : combo = action.defaultKeyCombo,
        isEnabled = true,
        isCustom = false;

  final ShortcutAction action;
  final KeyCombo combo;

  /// الاختصار معطَّل: يبقى معروضاً في الإعدادات لكنه لا يستجيب للمفاتيح.
  final bool isEnabled;

  /// خصّصه المستخدم (يختلف عن الافتراضي أو معطَّل) ⇐ يُرسَل للخادم.
  final bool isCustom;

  bool get isDefault => !isCustom;

  ShortcutBinding copyWith({
    KeyCombo? combo,
    bool? isEnabled,
    bool? isCustom,
  }) =>
      ShortcutBinding(
        action: action,
        combo: combo ?? this.combo,
        isEnabled: isEnabled ?? this.isEnabled,
        isCustom: isCustom ?? this.isCustom,
      );

  @override
  bool operator ==(Object other) =>
      other is ShortcutBinding &&
      other.action == action &&
      other.combo == combo &&
      other.isEnabled == isEnabled;

  @override
  int get hashCode => Object.hash(action, combo, isEnabled);
}
