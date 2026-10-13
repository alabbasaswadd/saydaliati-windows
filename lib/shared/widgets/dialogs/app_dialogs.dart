import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';

/// App dialogs, exposed as `show…` helpers returning a result. Use these instead
/// of ad-hoc `showDialog` so confirmations/errors/successes look the same.

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
        AppButton.outline(
          label: cancelLabel ?? AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(false),
          fullWidth: false,
        ),
        if (destructive)
          AppButton.danger(
            label: confirmLabel ?? AppStrings.confirm,
            onPressed: () => Navigator.of(context).pop(true),
            fullWidth: false,
          )
        else
          AppButton.primary(
            label: confirmLabel ?? AppStrings.confirm,
            onPressed: () => Navigator.of(context).pop(true),
            fullWidth: false,
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
        AppButton.primary(
          label: AppStrings.ok,
          onPressed: () => Navigator.of(context).pop(),
          fullWidth: false,
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
        AppButton.primary(
          label: AppStrings.ok,
          onPressed: () => Navigator.of(context).pop(),
          fullWidth: false,
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
    return AlertDialog(
      icon: Icon(icon, color: iconColor, size: 36),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      actions: [
        Row(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(child: actions[i]),
            ],
          ],
        ),
      ],
    );
  }
}
