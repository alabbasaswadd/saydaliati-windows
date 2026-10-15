import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// صفحة التابّ الجديد — فارغة عن قصد.
///
/// لا قائمة صفحات هنا: القائمة الجانبية حاضرة بجانبها دائماً وهي المكان
/// الذي يعرفه المستخدم، فقائمةٌ ثانية تُكرّرها وتُشتّت الاختيار بين موضعين.
/// التابّ يبقى فارغاً حتى يختار صاحبه، ثم يسكنه ما اختاره.
class NewTabPage extends StatelessWidget {
  const NewTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tab_outlined,
                size: 34,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'تابّ جديد',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'اختر صفحةً من القائمة الجانبية لتُفتح هنا.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'و Ctrl + نقر على عنصر القائمة يفتحه في تابّ جديد دون مغادرة مكانك.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
