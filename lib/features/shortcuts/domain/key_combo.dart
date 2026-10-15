import 'package:flutter/services.dart';

/// المُعدِّل المسموح في التركيبة — واحد فقط، لأن الاختصار محدود برمزين.
enum ShortcutModifier {
  none('', ''),
  ctrl('Ctrl', 'Ctrl'),
  alt('Alt', 'Alt'),
  shift('Shift', 'Shift');

  const ShortcutModifier(this.wire, this.label);

  /// الصيغة المخزَّنة/المرسَلة للخادم.
  final String wire;

  /// ما يُعرض على مفتاح الشاشة.
  final String label;
}

/// تركيبة اختصار من رمزين كحدّ أقصى: مُعدِّل + مفتاح، أو مفتاح وحده.
///
/// المفتاح المفرد مقصور على مفاتيح الوظائف والتنقّل (F1..F12، Delete، Home…)
/// — حرف أو رقم وحده كان سيبتلع الكتابة داخل حقول الإدخال.
class KeyCombo {
  const KeyCombo({required this.key, this.modifier = ShortcutModifier.none});

  /// المفتاح بصيغة موحّدة: 'S' أو '1' أو 'F2' أو 'Delete'.
  final String key;
  final ShortcutModifier modifier;

  bool get hasModifier => modifier != ShortcutModifier.none;

  /// الصيغة المخزَّنة: "Ctrl+S" أو "F2".
  String get wire => hasModifier ? '${modifier.wire}+$key' : key;

  /// أجزاء العرض بالترتيب (لرسم كل جزء كمفتاح مستقل على الشاشة).
  List<String> get parts => hasModifier ? [modifier.label, key] : [key];

  /// مفاتيح تصلح وحدها بلا مُعدِّل.
  static const Set<String> standaloneKeys = {
    'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
    'Insert', 'Delete', 'Home', 'End',
  };

  /// مفاتيح يصحّ ضمّها إلى مُعدِّل.
  static const Set<String> modifiableKeys = {
    ...standaloneKeys,
    'Enter', 'Space',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  };

  /// صحّة التركيبة بنفس قاعدة الخادم — تُستعمل قبل الحفظ وقبل قبول تسجيل جديد.
  bool get isValid => hasModifier
      ? modifiableKeys.contains(key)
      : standaloneKeys.contains(key);

  /// يقرأ الصيغة المخزَّنة. يعيد `null` لأي نصّ لا يطابق القاعدة — فالاختصار
  /// التالف يُهمَل ويعود الإجراء لافتراضيّه بدل أن يكسر الشاشة.
  static KeyCombo? parse(String? raw) {
    final text = raw?.trim();
    if (text == null || text.isEmpty) return null;

    final parts = text.split('+');
    if (parts.length == 1) {
      final combo = KeyCombo(key: _normalizeKey(parts.first));
      return combo.isValid ? combo : null;
    }
    if (parts.length != 2) return null;

    final modifier = ShortcutModifier.values.firstWhere(
      (m) => m != ShortcutModifier.none &&
          m.wire.toLowerCase() == parts.first.trim().toLowerCase(),
      orElse: () => ShortcutModifier.none,
    );
    if (modifier == ShortcutModifier.none) return null;

    final combo = KeyCombo(key: _normalizeKey(parts.last), modifier: modifier);
    return combo.isValid ? combo : null;
  }

  static String _normalizeKey(String raw) {
    final k = raw.trim();
    if (k.length == 1) return k.toUpperCase();
    // F2 / Delete / Home… — حرف أول كبير والبقية صغيرة، وحالة خاصة لمفاتيح F.
    final upper = k.toUpperCase();
    if (RegExp(r'^F([1-9]|1[0-2])$').hasMatch(upper)) return upper;
    return k[0].toUpperCase() + k.substring(1).toLowerCase();
  }

  /// يبني تركيبة من حدث لوحة مفاتيح فعلي، أو `null` إن كان الحدث مُعدِّلاً
  /// وحده أو مفتاحاً غير مدعوم.
  static KeyCombo? fromKeyEvent(KeyEvent event) {
    final key = _keyName(event.logicalKey);
    if (key == null) return null;

    final pressed = HardwareKeyboard.instance;
    // مُعدِّل واحد فقط: ضغط أكثر من واحد يتجاوز حدّ الرمزين.
    final modifiers = [
      if (pressed.isControlPressed) ShortcutModifier.ctrl,
      if (pressed.isAltPressed) ShortcutModifier.alt,
      if (pressed.isShiftPressed) ShortcutModifier.shift,
    ];
    if (modifiers.length > 1) return null;

    return KeyCombo(
      key: key,
      modifier: modifiers.isEmpty ? ShortcutModifier.none : modifiers.first,
    );
  }

  /// اسم المفتاح الموحّد، أو `null` للمفاتيح غير المدعومة (والمُعدِّلات نفسها).
  static String? _keyName(LogicalKeyboardKey logical) {
    final named = _namedKeys[logical];
    if (named != null) return named;

    final label = logical.keyLabel;
    if (label.length == 1) {
      final c = label.toUpperCase();
      if (RegExp(r'^[A-Z0-9]$').hasMatch(c)) return c;
    }
    return null;
  }

  static final Map<LogicalKeyboardKey, String> _namedKeys = {
    LogicalKeyboardKey.f1: 'F1',
    LogicalKeyboardKey.f2: 'F2',
    LogicalKeyboardKey.f3: 'F3',
    LogicalKeyboardKey.f4: 'F4',
    LogicalKeyboardKey.f5: 'F5',
    LogicalKeyboardKey.f6: 'F6',
    LogicalKeyboardKey.f7: 'F7',
    LogicalKeyboardKey.f8: 'F8',
    LogicalKeyboardKey.f9: 'F9',
    LogicalKeyboardKey.f10: 'F10',
    LogicalKeyboardKey.f11: 'F11',
    LogicalKeyboardKey.f12: 'F12',
    LogicalKeyboardKey.insert: 'Insert',
    LogicalKeyboardKey.delete: 'Delete',
    LogicalKeyboardKey.home: 'Home',
    LogicalKeyboardKey.end: 'End',
    LogicalKeyboardKey.enter: 'Enter',
    LogicalKeyboardKey.numpadEnter: 'Enter',
    LogicalKeyboardKey.space: 'Space',
  };

  /// المفتاح المنطقي المقابل — لبناء [SingleActivator] حين يُربَط الاختصار
  /// محلياً داخل شاشة أو نافذة (لا عبر الموزِّع العام).
  LogicalKeyboardKey? get logicalKey {
    for (final e in _namedKeys.entries) {
      if (e.value == key) return e.key;
    }
    if (key.length != 1) return null;
    final lower = key.toLowerCase();
    return _singleCharKeys[lower];
  }

  static final Map<String, LogicalKeyboardKey> _singleCharKeys = {
    for (final k in [
      LogicalKeyboardKey.keyA, LogicalKeyboardKey.keyB, LogicalKeyboardKey.keyC,
      LogicalKeyboardKey.keyD, LogicalKeyboardKey.keyE, LogicalKeyboardKey.keyF,
      LogicalKeyboardKey.keyG, LogicalKeyboardKey.keyH, LogicalKeyboardKey.keyI,
      LogicalKeyboardKey.keyJ, LogicalKeyboardKey.keyK, LogicalKeyboardKey.keyL,
      LogicalKeyboardKey.keyM, LogicalKeyboardKey.keyN, LogicalKeyboardKey.keyO,
      LogicalKeyboardKey.keyP, LogicalKeyboardKey.keyQ, LogicalKeyboardKey.keyR,
      LogicalKeyboardKey.keyS, LogicalKeyboardKey.keyT, LogicalKeyboardKey.keyU,
      LogicalKeyboardKey.keyV, LogicalKeyboardKey.keyW, LogicalKeyboardKey.keyX,
      LogicalKeyboardKey.keyY, LogicalKeyboardKey.keyZ,
      LogicalKeyboardKey.digit0, LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2, LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4, LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6, LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8, LogicalKeyboardKey.digit9,
    ])
      k.keyLabel.toLowerCase(): k,
  };

  @override
  bool operator ==(Object other) =>
      other is KeyCombo && other.key == key && other.modifier == modifier;

  @override
  int get hashCode => Object.hash(key, modifier);

  @override
  String toString() => wire;
}
