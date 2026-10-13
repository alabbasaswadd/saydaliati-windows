import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// One spotlight step: a target widget (by [key]) with an Arabic title + text.
class CoachStep {
  const CoachStep({
    required this.key,
    required this.title,
    required this.text,
    this.shape = ShapeLightFocus.RRect,
    this.align = ContentAlign.bottom,
  });

  final GlobalKey key;
  final String title;
  final String text;
  final ShapeLightFocus shape;
  final ContentAlign align;
}

/// Shows a dim overlay that spotlights each step's target in order, with an
/// Arabic explanation bubble and a «التالي» button. [onFinish] fires when the
/// last step is passed; [onSkip] when the user taps «تخطّي».
void showCoach(
  BuildContext context, {
  required List<CoachStep> steps,
  VoidCallback? onFinish,
  VoidCallback? onSkip,
}) {
  final targets = [
    for (final s in steps)
      TargetFocus(
        identify: s.key,
        keyTarget: s.key,
        shape: s.shape,
        radius: 12,
        paddingFocus: 8,
        contents: [
          TargetContent(
            align: s.align,
            builder: (ctx, controller) => _CoachBubble(
              title: s.title,
              text: s.text,
              onNext: controller.next,
            ),
          ),
        ],
      ),
  ];

  TutorialCoachMark(
    targets: targets,
    colorShadow: Colors.black,
    opacityShadow: 0.82,
    textSkip: AppStrings.skip,
    hideSkip: false,
    onFinish: () => onFinish?.call(),
    onSkip: () {
      onSkip?.call();
      return true;
    },
  ).show(context: context);
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({
    required this.title,
    required this.text,
    required this.onNext,
  });

  final String title;
  final String text;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: onNext,
              child: const Text(AppStrings.next),
            ),
          ),
        ],
      ),
    );
  }
}
