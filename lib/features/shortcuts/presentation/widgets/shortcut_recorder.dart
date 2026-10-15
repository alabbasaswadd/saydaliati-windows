import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/domain/key_combo.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/key_cap.dart';

/// يفتح لاقط التركيبة ويعيد ما سجّله المستخدم، أو `null` إن ألغى.
Future<KeyCombo?> showShortcutRecorder(
  BuildContext context, {
  required ShortcutAction action,
}) {
  return showDialog<KeyCombo>(
    context: context,
    builder: (_) => _ShortcutRecorderDialog(action: action),
  );
}

/// نافذة تسجيل تركيبة: تلتقط ضغطة المستخدم وتعرضها كمفاتيح، وتشرح سبب رفض
/// التركيبات غير الصالحة بدل أن تتجاهلها بصمت.
class _ShortcutRecorderDialog extends StatefulWidget {
  const _ShortcutRecorderDialog({required this.action});

  final ShortcutAction action;

  @override
  State<_ShortcutRecorderDialog> createState() =>
      _ShortcutRecorderDialogState();
}

class _ShortcutRecorderDialogState extends State<_ShortcutRecorderDialog> {
  final _focus = FocusNode();
  KeyCombo? _captured;
  String? _error;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.handled;

    // Escape يغلق بلا تغيير — ولا يُسجَّل كتركيبة.
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    final combo = KeyCombo.fromKeyEvent(event);
    if (combo == null) {
      // مُعدِّل وحده أو أكثر من مُعدِّل أو مفتاح غير مدعوم.
      setState(() {
        _captured = null;
        _error = _pressedModifierCount() > 1
            ? 'مُعدِّل واحد فقط — الاختصار رمزان كحدّ أقصى'
            : null;
      });
      return KeyEventResult.handled;
    }

    setState(() {
      if (combo.isValid) {
        _captured = combo;
        _error = null;
      } else {
        _captured = null;
        _error = combo.hasModifier
            ? 'هذا المفتاح لا يصلح للاختصارات'
            : 'الحرف أو الرقم وحده يبتلع الكتابة — أضف Ctrl أو Alt أو Shift، '
                'أو استخدم مفتاحاً وظيفياً مثل F2';
      }
    });
    return KeyEventResult.handled;
  }

  int _pressedModifierCount() {
    final k = HardwareKeyboard.instance;
    return [k.isControlPressed, k.isAltPressed, k.isShiftPressed]
        .where((p) => p)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Focus(
          focusNode: _focus,
          autofocus: true,
          onKeyEvent: _onKey,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(widget.action.icon, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(widget.action.label,
                          style: theme.textTheme.titleMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // لوحة الالتقاط — تملأ بالمفاتيح الملتقَطة فور ضغطها.
                Container(
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: _error != null
                          ? theme.colorScheme.error.withValues(alpha: 0.5)
                          : _captured != null
                              ? theme.colorScheme.primary.withValues(alpha: 0.5)
                              : context.semantic.border,
                    ),
                    borderRadius: AppRadius.brSm,
                  ),
                  child: _captured != null
                      ? KeyComboView(_captured!, tone: KeyCapTone.active)
                      : Text(
                          'اضغط التركيبة الآن…',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: context.semantic.textSecondary),
                        ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),
                Text(
                  'الحالي: ${widget.action.defaultCombo} افتراضياً · Esc للإلغاء',
                  style: theme.textTheme.bodySmall,
                ),

                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: _captured == null
                          ? null
                          : () => Navigator.of(context).pop(_captured),
                      child: const Text('اعتماد'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
