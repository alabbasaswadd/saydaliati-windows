import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A consistent icon button (optionally with a tooltip and a filled background).
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (filled) {
      return IconButton.filledTonal(
        icon: Icon(icon, size: AppSizes.iconMd),
        color: color,
        tooltip: tooltip,
        onPressed: onPressed,
      );
    }
    return IconButton(
      icon: Icon(icon, size: AppSizes.iconMd),
      color: color ?? scheme.onSurface,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
