import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// App dialogs, exposed as `show…` helpers returning a result. Use these instead
/// of ad-hoc `showDialog` so confirmations/errors/successes look the same.
///
/// Windows-style popup: narrow fixed width, start-aligned header (icon + title
/// + small ✕ close button) and body text, small content-sized action buttons
/// aligned to the end — not a mobile alert (no centered icon/text, no
/// full-width stretched buttons).

/// Confirmation dialog. Returns `true` if confirmed, `false`/`null` otherwise.
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
  IconData icon = Icons.help_outline,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => _AppAlert(
      icon: icon,
      iconColor: destructive
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      title: title,
      message: message,
      actions: [
        _AlertButton(
          label: cancelLabel ?? AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        _AlertButton(
          label: confirmLabel ?? AppStrings.confirm,
          filled: true,
          danger: destructive,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Delete confirmation — a destructive [showConfirmationDialog] preset.
Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  String? itemName,
}) {
  return showConfirmationDialog(
    context,
    title: AppStrings.delete,
    message: itemName == null
        ? 'هل أنت متأكد من الحذف؟ لا يمكن التراجع عن هذا الإجراء.'
        : 'هل أنت متأكد من حذف "$itemName"؟ لا يمكن التراجع عن هذا الإجراء.',
    confirmLabel: AppStrings.delete,
    icon: Icons.delete_outline,
    destructive: true,
  );
}

/// Error dialog with a single dismiss action.
Future<void> showErrorDialog(
  BuildContext context, {
  required String message,
  String? title,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _AppAlert(
      icon: Icons.error_outline,
      iconColor: Theme.of(context).colorScheme.error,
      title: title ?? AppStrings.errorDefault,
      message: message,
      actions: [
        _AlertButton(
          label: AppStrings.ok,
          filled: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

/// Success dialog with a single dismiss action.
Future<void> showSuccessDialog(
  BuildContext context, {
  required String message,
  String? title,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _AppAlert(
      icon: Icons.check_circle_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      title: title ?? AppStrings.successDefault,
      message: message,
      actions: [
        _AlertButton(
          label: AppStrings.ok,
          filled: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

class _AppAlert extends StatelessWidget {
  const _AppAlert({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actions,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس بأسلوب نوافذ ويندوز: أيقونة + عنوان + زر إغلاق صغير.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(title,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      tooltip: AppStrings.close,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 34),
                child: Text(message, style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: AppSpacing.md),
              // أزرار بحجم محتواها بدل الممتدة — أسلوب نوافذ ويندوز.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actions[i],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر صغير بحجم محتواه لنوافذ [_AppAlert] — بنفس مقاس أزرار [showEntityFormDialog].
class _AlertButton extends StatelessWidget {
  const _AlertButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 100,
      height: 32,
      child: filled
          ? FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: theme.textTheme.bodyMedium,
                backgroundColor: danger ? theme.colorScheme.error : null,
                foregroundColor: danger ? theme.colorScheme.onError : null,
              ),
              onPressed: onPressed,
              child: Text(label),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: theme.textTheme.bodyMedium,
              ),
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}
