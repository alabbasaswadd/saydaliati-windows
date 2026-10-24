import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/utils/whatsapp.dart';
import 'package:saydaliati/shared/widgets/dialogs/adaptive_modal.dart';

/// عنصر غير مرئي يُوضع داخل الصفحة الرئيسية: أول وصول فعلي بعد الدخول —
/// سياق الصفحة الرئيسية مستقرّ لا يُستبدَل لحظة المصادقة كصفحة الدخول
/// نفسها (كانت `context` هناك تُهدَم أثناء انتقال الراوتر التلقائي، فينتهي
/// `maybeShowMigrationOffer` بصمت دون عرض شيء رغم تعليم العرض كـ«شوهد»).
class MigrationOfferGate extends ConsumerStatefulWidget {
  const MigrationOfferGate({super.key});

  @override
  ConsumerState<MigrationOfferGate> createState() => _MigrationOfferGateState();
}

class _MigrationOfferGateState extends ConsumerState<MigrationOfferGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => maybeShowMigrationOffer(context, ref));
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// يعرض عرض «ننقل مخزونك» مرّة واحدة فقط — أوّل وصول للصفحة الرئيسية على
/// هذا الجهاز، ثم لا يظهر ثانيةً.
Future<void> maybeShowMigrationOffer(BuildContext context, WidgetRef ref) async {
  final kv = ref.read(keyValueStoreProvider);
  final seen = await kv.read(AppConstants.migrationOfferSeenKey);
  if (seen != null) return;
  await kv.write(AppConstants.migrationOfferSeenKey, '1');
  if (!context.mounted) return;
  await showAdaptiveModal<void>(
    context,
    maxWidth: 440,
    builder: (_) => const MigrationOfferContent(),
  );
}

/// محتوى العرض — بطاقة بأيقونة ونصّ قصير وزرّي واتساب، قابلة لإعادة
/// الاستخدام من شاشة الدعم الفني بلا تكرار (فرق الوحيد: زرّ «لاحقاً» هنا).
class MigrationOfferContent extends StatelessWidget {
  const MigrationOfferContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.sync_alt_rounded,
                  size: 40, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'عندك مخزون جاهز بمكان ثاني؟',
            textAlign: TextAlign.center,
            style:
                theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _OfferPoint(
            icon: Icons.sync_alt_outlined,
            text: 'جاهزون لنقل مخزونك من أيّ برنامج محاسبة آخر تستخدمه.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _OfferPoint(
            icon: Icons.table_chart_outlined,
            text: 'عندك ملف إكسل بأدويتك؟ جاهزون نُدخلها لك منه مباشرة.',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'تواصل مع الدعم الفني',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final number in AppConstants.supportWhatsAppNumbers) ...[
            _WhatsAppButton(number: number),
            const SizedBox(height: AppSpacing.sm),
          ],
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('لاحقاً'),
          ),
        ],
      ),
    );
  }
}

/// سطر نقطة واحدة من نقاط العرض — أيقونة دائرية صغيرة + نصّ، محاذاة يمين
/// (لا توسيط) حتى تُقرأ كقائمة مرتّبة لا كجملة طويلة واحدة.
class _OfferPoint extends StatelessWidget {
  const _OfferPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.onSecondaryContainer),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

/// زرّ تواصل واتساب برقمٍ واحد — أخضر واتساب، والرقم ظاهر LTR (أرقام هاتف
/// بسياق RTL تُقرأ معكوسة لولا هذا، نفس حلّ بقية أرقام الهاتف بالتطبيق).
class _WhatsAppButton extends StatelessWidget {
  const _WhatsAppButton({required this.number});

  final String number;

  static const _whatsappGreen = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => openWhatsApp(context, number),
      style: FilledButton.styleFrom(
        backgroundColor: _whatsappGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
      icon: const Icon(Icons.chat_outlined),
      label: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(formatWhatsAppNumber(number)),
      ),
    );
  }
}
