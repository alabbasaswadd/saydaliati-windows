import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_colors.dart';

/// Cairo-based typography. One family across the whole app; a clear hierarchy
/// from display → body → label. Weights come from Cairo's variable weight axis.
abstract final class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Cairo';

  static TextTheme textTheme(Color primary, Color secondary) {
    TextStyle base(double size, FontWeight weight,
            {Color? color, double? height}) =>
        TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: weight,
          color: color ?? primary,
          height: height,
        );

    return TextTheme(
      displaySmall: base(30, FontWeight.w700, height: 1.25),
      headlineMedium: base(24, FontWeight.w700, height: 1.3),
      headlineSmall: base(20, FontWeight.w700, height: 1.3),
      titleLarge: base(18, FontWeight.w600, height: 1.35),
      titleMedium: base(16, FontWeight.w600, height: 1.4),
      titleSmall: base(14, FontWeight.w600, color: secondary, height: 1.4),
      bodyLarge: base(16, FontWeight.w400, height: 1.5),
      bodyMedium: base(14, FontWeight.w400, height: 1.5),
      bodySmall: base(12, FontWeight.w400, color: secondary, height: 1.45),
      labelLarge: base(14, FontWeight.w600, height: 1.2),
      labelMedium: base(12, FontWeight.w500, color: secondary, height: 1.2),
      labelSmall: base(11, FontWeight.w500, color: secondary, height: 1.2),
    );
  }

  static TextTheme get light =>
      textTheme(AppColors.textPrimary, AppColors.textSecondary);

  static TextTheme get dark =>
      textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark);
}
