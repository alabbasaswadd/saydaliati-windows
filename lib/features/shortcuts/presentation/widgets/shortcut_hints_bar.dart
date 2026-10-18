import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcut_hints_setting.dart';
import 'package:saydaliati/features/shortcuts/shortcut_providers.dart';

/// شريط تلميحات اختصارات الفاتورة — **سطر واحد** أسفل شريط الأدوات.
///
/// يقرأ الارتباطات **الفعلية** لا قائمةً مكتوبة يدوياً: فمن غيّر «حفظ» إلى
/// مفتاح آخر يرى مفتاحه هو، ولو كُتبت الاختصارات نصّاً لكذب الشريط على
/// صاحبه عند أوّل تعديل.
///
/// وتصميمه مقصودٌ أن **لا يُزعج**: ارتفاع ٢٤، خطّ صغير، ألوان هادئة من
/// السمة، بلا إطار ولا ظلّ — حدٌّ أعلى رقيق يفصله عمّا فوقه، ويُمرَّر أفقياً
/// إن ضاقت الشاشة فلا يقتطع من الجدول سطراً ثانياً.
class ShortcutHintsBar extends ConsumerWidget {
  const ShortcutHintsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showShortcutHintsProvider)) return const SizedBox.shrink();

    final bindings = ref.watch(shortcutBindingsProvider).value;
    if (bindings == null) return const SizedBox.shrink();

    // قسم الفاتورة وحده: اختصارات التنقّل لا تخصّ مَن يكتب فاتورة.
    final hints = bindings
        .where((b) => b.action.section == ShortcutSection.invoice)
        .where((b) => b.isEnabled)
        .toList();
    if (hints.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final border = theme.extension<AppSemanticColors>()!.border;

    return Container(
      height: 24,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            for (var i = 0; i < hints.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text('·',
                      style: TextStyle(
                          color: theme.hintColor, fontSize: 11, height: 1)),
                ),
              _Hint(
                keys: hints[i].combo.parts.join('+'),
                label: hints[i].action.label,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// تلميح واحد: المفتاح ثم ما يفعله — بلا مكوّن مفاتيح مزخرف.
///
/// `KeyCap` مصمَّم لشاشة الإعدادات (حدود وخلفية وحشو)، ويرفع ارتفاع السطر
/// إلى ضعفه. فالمفتاح هنا نصٌّ أثقل وزناً بلون أساسي — يُقرأ ولا يُزاحم.
class _Hint extends StatelessWidget {
  const _Hint({required this.keys, required this.label});

  final String keys;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          keys,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}
