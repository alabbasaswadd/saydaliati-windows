import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/key_cap.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// جولة الترحيب عند أول فتح للتطبيق: لمحة مختصرة عن المزايا، ثم انتقال إلى
/// شاشة الاختصارات مع شرح موجز لها.
///
/// تُعرَض مرّة واحدة ويُحفظ ذلك محلياً. بطاقتان قصيرتان لا جولة إرشاد طويلة —
/// المستخدم جاء ليبيع، لا ليقرأ دليلاً.
abstract final class WelcomeTour {
  const WelcomeTour._();

  static const _doneKey = 'welcome_tour_done_v1';

  static Future<bool> isDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_doneKey) ?? false;
    } catch (_) {
      // تعذّر القراءة ⇒ لا نُزعج المستخدم بجولة قد تكون رآها.
      return true;
    }
  }

  static Future<void> markDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_doneKey, true);
    } catch (_) {
      // لا شيء: أسوأ الأحوال أن تُعرَض الجولة مرّة أخرى.
    }
  }

  /// يعيد تشغيل الجولة في الفتحة التالية (من الإعدادات مثلاً).
  static Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_doneKey);
    } catch (_) {}
  }

  /// يعرض الجولة كاملة. [ref] لا يُستعمل للقراءة بل ليبقى التوقيع موحّداً مع
  /// بقية نقاط الإقلاع في القشرة.
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    // مهلة قصيرة قبل العرض: القشرة تُبنى مباشرة بعد إعادة توجيه الراوتر، وأي
    // نافذة تُفتح في الإطار الأول قد يُزال مسارها قبل أن تظهر أصلاً.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!context.mounted) return;

    final wantsShortcuts = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _FeaturesDialog(),
    );

    // النافذة لا تُغلَق إلا بزرّ (barrierDismissible: false)، فالنتيجة `null`
    // تعني أن مسارها أُزيل قبل أن يراها المستخدم — لا نحرق الجولة حينها بل
    // نعيد المحاولة في الفتحة التالية.
    if (wantsShortcuts == null) return;
    await markDone();

    if (!context.mounted || !wantsShortcuts) return;

    // الانتقال لشاشة الاختصارات ثم شرحها فوقها — ليرى المستخدم ما نتحدّث عنه.
    context.go(AppRoutes.shortcuts);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ShortcutsDialog(),
    );
  }
}

// ─── البطاقة الأولى: لمحة عن المزايا ──────────────────────────────────────

class _Feature {
  const _Feature(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

const _features = <_Feature>[
  _Feature(
    Icons.point_of_sale_outlined,
    'بيع سريع',
    'فاتورة بتابات متعددة، باركود، ودفعات الصلاحية تُختار تلقائياً.',
  ),
  _Feature(
    Icons.inventory_2_outlined,
    'مخزون وصلاحيات',
    'كتالوغ دوائي جاهز، كميات ودفعات، وتنبيه ما قارب على الانتهاء.',
  ),
  _Feature(
    Icons.receipt_long_outlined,
    'فواتير ومرتجعات',
    'مبيعات ومشتريات ومرتجعاتها — كلّها قابلة للعرض والتعديل.',
  ),
  _Feature(
    Icons.account_balance_outlined,
    'حسابات وتقارير',
    'قيود مزدوجة وسندات ومصاريف، وتقارير أرباح ومخزون وجرد.',
  ),
  _Feature(
    Icons.cloud_off_outlined,
    'يعمل دون اتصال',
    'ينقطع الإنترنت فيُكمل البيع من البيانات المحفوظة ويُرحّل لاحقاً.',
  ),
];

class _FeaturesDialog extends StatelessWidget {
  const _FeaturesDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _TourDialog(
      icon: Icons.local_pharmacy_outlined,
      title: 'أهلاً بك في صيدليتي',
      subtitle: 'لمحة سريعة عمّا يقدّمه البرنامج — أقل من دقيقة.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final f in _features) ...[
            _FeatureRow(feature: f),
            if (f != _features.last) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('تخطّي'),
        ),
        const SizedBox(width: AppSpacing.sm),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.keyboard_outlined, size: AppSizes.iconXs),
          label: const Text('تابع: الاختصارات'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            textStyle: theme.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: AppRadius.brSm,
          ),
          child: Icon(feature.icon,
              size: AppSizes.iconXs, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(feature.title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              Text(feature.body, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── البطاقة الثانية: شرح الاختصارات ──────────────────────────────────────

class _ShortcutsDialog extends StatelessWidget {
  const _ShortcutsDialog();

  /// أمثلة حيّة من الكتالوغ نفسه — فلا تتناقض مع الاختصارات الفعلية إن تغيّرت.
  static const _samples = <(ShortcutAction, String)>[
    (ShortcutAction.invoiceAddItem, 'يفتح منتقي الدواء مباشرة'),
    (ShortcutAction.invoiceSave, 'يحفظ الفاتورة المفتوحة'),
    (ShortcutAction.navPurchases, 'ينتقل لفاتورة شراء من أي شاشة'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _TourDialog(
      icon: Icons.keyboard_outlined,
      title: 'اختصارات لوحة المفاتيح',
      subtitle: 'هذه الشاشة أمامك — كل إجراء هنا تستطيع ربطه بالمفاتيح التي تريحك.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (action, note) in _samples) ...[
            Row(
              children: [
                KeyComboView(action.defaultKeyCombo),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: action.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' — $note',
                        style: theme.textTheme.bodySmall,
                      ),
                    ]),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          const _Note(
            icon: Icons.touch_app_outlined,
            text: 'انقر أي سطر لتسجيل تركيبة جديدة، ثم «حفظ» لتصير فعّالة.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _Note(
            icon: Icons.rule_outlined,
            text: 'التركيبة رمزان كحدّ أقصى: Ctrl أو Alt أو Shift مع مفتاح، '
                'أو مفتاح وظيفي وحده.',
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          child: const Text('فهمت، لنبدأ'),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: AppSizes.iconXs, color: context.semantic.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}

// ─── الهيكل المشترك للبطاقتين ─────────────────────────────────────────────

class _TourDialog extends StatelessWidget {
  const _TourDialog({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.actions,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: size.height * 0.86,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Icon(icon, color: Colors.white, size: AppSizes.iconMd),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: theme.textTheme.titleLarge),
                        Text(subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Flexible(child: SingleChildScrollView(child: body)),
              const SizedBox(height: AppSpacing.xl),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
            ],
          ),
        ),
      ),
    );
  }
}
