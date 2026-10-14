import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// One-line feedback via a themed SnackBar. Use for transient success/error/info
/// messages (persistent problems belong in an `ErrorState`/dialog).
abstract final class AppSnackbar {
  const AppSnackbar._();

  // النجاح خفيف (خلفية فاتحة عائمة) بدل شريط ملوَّن ثقيل أسفل الشاشة — واضح
  // دون أن يُحجب ما تحته، ويختفي بسرعة فلا يعيق الاستمرار بعمل آخر.
  static void success(BuildContext context, String message) => _show(
      context, message, AppColors.success, Icons.check_circle_outline,
      light: true);

  static void error(BuildContext context, String message) =>
      _show(context, message, AppColors.error, Icons.error_outline);

  static void info(BuildContext context, String message) =>
      _show(context, message, AppColors.info, Icons.info_outline);

  static void _show(
      BuildContext context, String message, Color color, IconData icon,
      {bool light = false}) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    if (!light) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color.withValues(alpha: 0.12),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
