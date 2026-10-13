import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Button style variants.
enum AppButtonVariant { primary, secondary, outline, danger, text }

/// The single button used across the app. Covers primary / secondary / outline /
/// danger / text styles, plus loading, disabled, icon, full-width and size — so
/// features never hand-roll `FilledButton`/`OutlinedButton`/`TextButton`.
///
/// Convenience constructors: [AppButton.primary], `.secondary`, `.outline`,
/// `.danger`, `.text`. Passing `isLoading: true` gives the "LoadingButton"
/// behaviour (spinner + disabled).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.small = false,
    this.backgroundColor,
    super.key,
  });

  const AppButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.small = false,
    this.backgroundColor,
    super.key,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.small = false,
    super.key,
  })  : variant = AppButtonVariant.secondary,
        backgroundColor = null;

  const AppButton.outline({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.small = false,
    super.key,
  })  : variant = AppButtonVariant.outline,
        backgroundColor = null;

  const AppButton.danger({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = true,
    this.small = false,
    super.key,
  })  : variant = AppButtonVariant.danger,
        backgroundColor = null;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    this.small = false,
    super.key,
  })  : variant = AppButtonVariant.text,
        backgroundColor = null;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final bool small;

  /// Optional override for the filled background (primary variant). When set,
  /// the foreground is forced to white.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = !isDisabled && !isLoading && onPressed != null;
    final onTap = enabled ? onPressed : null;
    final height = small ? AppSizes.buttonHeightSm : AppSizes.buttonHeight;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _spinnerColor(context),
            ),
          )
        : _content();

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: onTap,
          style: backgroundColor == null
              ? null
              : FilledButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: Colors.white,
                ),
          child: child,
        ),
      AppButtonVariant.secondary => FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.secondary,
            foregroundColor: scheme.onSecondary,
          ),
          child: child,
        ),
      AppButtonVariant.outline =>
        OutlinedButton(onPressed: onTap, child: child),
      AppButtonVariant.danger => FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          child: child,
        ),
      AppButtonVariant.text => TextButton(onPressed: onTap, child: child),
    };

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: button,
    );
  }

  Widget _content() {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: AppSizes.iconSm),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Color _spinnerColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (variant) {
      AppButtonVariant.outline || AppButtonVariant.text => scheme.primary,
      _ => Colors.white,
    };
  }
}
