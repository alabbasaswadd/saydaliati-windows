import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/tutorials/tutorials.dart';
import 'package:saydaliati/shared/widgets/dialogs/adaptive_modal.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

// Re-export so screens can import this one file for both the button and the
// TutorialTopic enum.
export 'package:saydaliati/features/tutorials/tutorials.dart';

/// Opens a tutorial's YouTube Short in the external app/browser.
Future<void> openTutorial(BuildContext context, Tutorial t) async {
  final ok = await launchUrl(
    Uri.parse(t.url),
    mode: LaunchMode.externalApplication,
  );
  if (!ok && context.mounted) {
    AppSnackbar.error(context, 'تعذّر فتح الفيديو، تأكّد من الاتصال بالإنترنت');
  }
}

/// A compact sheet describing one lesson with a watch button + a link to the
/// full tutorials screen.
Future<void> showTutorialSheet(BuildContext context, TutorialTopic topic) {
  final t = tutorialFor(topic);
  return showAdaptiveModal<void>(
    context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TutorialThumbnail(tutorial: t, height: 180),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(t.icon, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(t.title,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  if (t.important) const _ImportantChip(),
                ],
              ),
              if (t.subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(t.subtitle!,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  openTutorial(context, t);
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('مشاهدة الفيديو'),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.push(AppRoutes.tutorials);
                },
                icon: const Icon(Icons.video_library_outlined),
                label: const Text('كل الشروحات التعليمية'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// A YouTube thumbnail with a play overlay and graceful fallback.
class TutorialThumbnail extends StatelessWidget {
  const TutorialThumbnail({super.key, required this.tutorial, this.height = 96});

  final Tutorial tutorial;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            tutorial.thumbnailUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: height,
              color: theme.colorScheme.primaryContainer,
              child: Icon(tutorial.icon,
                  size: 40, color: theme.colorScheme.primary),
            ),
            loadingBuilder: (c, child, p) => p == null
                ? child
                : Container(
                    height: height,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _ImportantChip extends StatelessWidget {
  const _ImportantChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
          SizedBox(width: 4),
          Text('مهم',
              style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

/// An AppBar action that (1) opens a help sheet for the screen's lesson, and
/// (2) shows a one-time hint the first time the screen is opened. Drop it into
/// any screen's `AppBar.actions`.
class TutorialHelpButton extends ConsumerStatefulWidget {
  const TutorialHelpButton(this.topic, {super.key});

  final TutorialTopic topic;

  @override
  ConsumerState<TutorialHelpButton> createState() => _TutorialHelpButtonState();
}

class _TutorialHelpButtonState extends ConsumerState<TutorialHelpButton> {
  @override
  void initState() {
    super.initState();
    // فيديوهات الشرح أُزيلت من نسخة الويندوز — فلا زرّ ولا تلميحٌ أوّل مرة
    // يُفتح على فيديوٍ لم يعد له مكان يُعرض فيه.
    if (Platform.isWindows) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowHint());
  }

  Future<void> _maybeShowHint() async {
    if (!mounted) return;
    final kv = ref.read(keyValueStoreProvider);
    final key = 'tut_hint_${widget.topic.name}';
    final seen = await kv.read(key);
    if (seen != null || !mounted) return;
    await kv.write(key, '1');
    if (!mounted) return;
    final t = tutorialFor(widget.topic);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        content: Text('💡 يوجد شرح مصوّر لهذه الصفحة: ${t.title}'),
        action: SnackBarAction(
          label: 'مشاهدة',
          textColor: Colors.white,
          onPressed: () => openTutorial(context, t),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // راجع ملاحظة initState: فيديوهات الشرح غير متاحة بنسخة الويندوز.
    if (Platform.isWindows) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'شرح مصوّر',
      icon: const Icon(Icons.ondemand_video_outlined),
      onPressed: () => showTutorialSheet(context, widget.topic),
    );
  }
}
