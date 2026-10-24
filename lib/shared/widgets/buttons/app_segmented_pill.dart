import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// عنصر تبديل مجزّأ بأسلوب التطبيق الخاص — تعبئة أساسية@12% + نص أساسي
/// غامق بالحالة المختارة (نفس معاملة العنصر النشِط بالشريط الجانبي)، بدل
/// كروم [SegmentedButton] القياسي العام الذي يبدو غريباً بجانب صفحات مصمَّمة
/// يدوياً. استُخرج من مُنتقي الفترة بقسم الربح بالشاشة الرئيسية ليُستعمَل في
/// أي تبديلٍ ثنائي أو متعدّد مشابه (مثل أساس التسعير بتقرير الجرد).
class AppSegmentedPill<T> extends StatelessWidget {
  const AppSegmentedPill({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// (القيمة، التسمية المعروضة) لكل خيار — بترتيب العرض.
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: sem.border),
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (value, label) in options)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () => onChanged(value),
                borderRadius: AppRadius.brSm,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: value == selected
                        ? theme.colorScheme.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: AppRadius.brSm,
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: value == selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          value == selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
