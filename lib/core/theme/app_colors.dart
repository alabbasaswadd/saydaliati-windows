import 'package:flutter/material.dart';

/// The app's color tokens — a fresh, clinical palette for a pharmacy app.
/// A clean emerald-green primary (health / medical) with a calm blue accent and
/// clear semantic colors; professional, never loud.
///
/// Tokens are grouped as light and dark sets and assembled into [ColorScheme]s
/// in `app_theme.dart`. Prefer `Theme.of(context).colorScheme` in widgets; use
/// these raw tokens only for the semantic extras (success/warning/info/border).
abstract final class AppColors {
  const AppColors._();

  // ---- Brand (pharmacy emerald green) ----
  static const Color primary = Color(0xFF0FA06A); // emerald green
  static const Color primaryDark = Color(0xFF0B7A50);
  static const Color primaryLight = Color(0xFF45C295);
  static const Color secondary = Color(0xFF2F80ED); // medical blue accent

  // ---- Semantic ----
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFE0A400);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // ---- Light neutrals (a hint of mint in the background) ----
  static const Color background = Color(0xFFF4F8F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF12261E);
  static const Color textSecondary = Color(0xFF5E7469);
  static const Color border = Color(0xFFE1EAE5);
  static const Color divider = Color(0xFFEDF3EF);
  static const Color disabled = Color(0xFFBAC7C0);

  // ---- Dark neutrals ----
  static const Color backgroundDark = Color(0xFF0E1613);
  static const Color surfaceDark = Color(0xFF14201B);
  static const Color cardDark = Color(0xFF192720);
  static const Color textPrimaryDark = Color(0xFFE6F0EB);
  static const Color textSecondaryDark = Color(0xFF93A89F);
  static const Color borderDark = Color(0xFF263831);
  static const Color dividerDark = Color(0xFF21322B);

  // Neutral "on" colors.
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFFFFFFFF);
}
