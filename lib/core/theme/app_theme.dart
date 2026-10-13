import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/theme/app_typography.dart';

/// Central Material 3 theme built from the app's tokens. Widgets should read
/// styling from `Theme.of(context)` / `context.semantic` rather than hard-coding
/// colors, so the whole app stays consistent and themeable.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        scaffold: AppColors.background,
        textTheme: AppTypography.light,
        semantic: const AppSemanticColors(
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
          border: AppColors.border,
          card: AppColors.card,
          textSecondary: AppColors.textSecondary,
        ),
        borderColor: AppColors.border,
        mutedText: AppColors.textSecondary,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          onPrimary: Color(0xFF05231A),
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onPrimary,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        scaffold: AppColors.backgroundDark,
        textTheme: AppTypography.dark,
        semantic: const AppSemanticColors(
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
          border: AppColors.borderDark,
          card: AppColors.cardDark,
          textSecondary: AppColors.textSecondaryDark,
        ),
        borderColor: AppColors.borderDark,
        mutedText: AppColors.textSecondaryDark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffold,
    required TextTheme textTheme,
    required AppSemanticColors semantic,
    required Color borderColor,
    required Color mutedText,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      dividerColor: brightness == Brightness.light
          ? AppColors.divider
          : AppColors.dividerDark,
    );

    OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      extensions: [semantic],
      appBarTheme: AppBarTheme(
        backgroundColor: semantic.card,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: semantic.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: borderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semantic.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: mutedText),
        labelStyle: textTheme.bodyMedium?.copyWith(color: mutedText),
        border: inputBorder(borderColor),
        enabledBorder: inputBorder(borderColor),
        focusedBorder: inputBorder(scheme.primary, width: 1.6),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, width: 1.6),
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: BorderSide(color: borderColor),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.labelLarge),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
        side: BorderSide(color: borderColor),
        backgroundColor: semantic.card,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: semantic.card,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      dividerTheme: DividerThemeData(
        color: base.dividerColor,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: semantic.card,
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: scheme.primary),
    );
  }
}
