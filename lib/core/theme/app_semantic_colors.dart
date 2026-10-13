import 'package:flutter/material.dart';

/// Extra semantic colors that don't fit the Material [ColorScheme] slots
/// (success / warning / info / border / card / muted text). Exposed as a
/// [ThemeExtension] so widgets read them from the theme, not from raw tokens:
///
/// ```dart
/// final semantic = Theme.of(context).extension<AppSemanticColors>()!;
/// // or: context.semantic.success
/// ```
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.border,
    required this.card,
    required this.textSecondary,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color border;
  final Color card;
  final Color textSecondary;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? border,
    Color? card,
    Color? textSecondary,
  }) =>
      AppSemanticColors(
        success: success ?? this.success,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        border: border ?? this.border,
        card: card ?? this.card,
        textSecondary: textSecondary ?? this.textSecondary,
      );

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      border: Color.lerp(border, other.border, t)!,
      card: Color.lerp(card, other.card, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

/// Convenience accessor: `context.semantic.success`.
extension SemanticColorsX on BuildContext {
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
