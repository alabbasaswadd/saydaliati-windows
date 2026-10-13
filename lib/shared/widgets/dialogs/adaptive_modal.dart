import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Shows [builder]'s content as a centered dialog on desktop-width windows,
/// falling back to a bottom sheet on compact widths. Use this instead of
/// calling `showModalBottomSheet` directly — sheets sliding up from the bottom
/// of a 1366px window are a mobile pattern.
///
/// The content is given at most [maxWidth]×[maxHeightFactor] of the window in
/// dialog mode and should size itself (e.g. `Column(mainAxisSize: min)` or an
/// internal scroll view).
Future<R?> showAdaptiveModal<R>(
  BuildContext context, {
  required WidgetBuilder builder,
  double maxWidth = 560,
  double maxHeightFactor = 0.8,
}) {
  if (context.isCompact) {
    return showModalBottomSheet<R>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: builder,
    );
  }
  return showDialog<R>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: MediaQuery.sizeOf(ctx).height * maxHeightFactor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: builder(ctx),
        ),
      ),
    ),
  );
}
