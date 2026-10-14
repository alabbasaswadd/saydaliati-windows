import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// One-line feedback via a themed SnackBar. Use for transient success/error/info
/// messages (persistent problems belong in an `ErrorState`/dialog).
abstract final class AppSnackbar {
  const AppSnackbar._();

  /// آخر إشعار نجاح معروض — يُزال فوراً عند استدعاء [success] مرة أخرى حتى لا
  /// تتراكم إشعارات فوق بعضها.
  static OverlayEntry? _activeSuccessEntry;

  // النجاح إشعار عائم بالزاوية اليسرى السفلى (بدل شريط أسفل الشاشة) بوميض
  // لحظي عند الظهور يجذب العين دون أن يحجب شيئاً، ثم يخفت ويغيب تلقائياً.
  static void success(BuildContext context, String message) {
    _activeSuccessEntry?.remove();
    _activeSuccessEntry = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 24,
        bottom: 24,
        child: _FlashToast(
          message: message,
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          onDone: () {
            entry.remove();
            if (_activeSuccessEntry == entry) _activeSuccessEntry = null;
          },
        ),
      ),
    );
    _activeSuccessEntry = entry;
    overlay.insert(entry);
  }

  static void error(BuildContext context, String message) =>
      _show(context, message, AppColors.error, Icons.error_outline);

  static void info(BuildContext context, String message) =>
      _show(context, message, AppColors.info, Icons.info_outline);

  static void _show(
      BuildContext context, String message, Color color, IconData icon) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
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
  }
}

/// بطاقة إشعار تظهر بوميض لحظي (ارتفاع سطوع سريع) ثم تثبت، تبقى قصيراً، ثم
/// تخفت وتُزال تلقائياً عبر [onDone] — بلا تفاعل من المستخدم.
class _FlashToast extends StatefulWidget {
  const _FlashToast({
    required this.message,
    required this.icon,
    required this.color,
    required this.onDone,
  });

  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback onDone;

  @override
  State<_FlashToast> createState() => _FlashToastState();
}

class _FlashToastState extends State<_FlashToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _opacity = TweenSequence<double>([
      // وميض: صعود سريع، خفوت جزئي، ثم ثبات على السطوع الكامل.
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
          weight: 7),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.3).chain(CurveTween(curve: Curves.easeIn)),
          weight: 7),
      TweenSequenceItem(
          tween: Tween(begin: 0.3, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
          weight: 7),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 54),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
          weight: 25),
    ]).animate(_controller);
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, _) => Opacity(
          opacity: _opacity.value.clamp(0.0, 1.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              borderRadius: AppRadius.brMd,
              border: Border.all(color: widget.color.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: widget.color, size: 20),
                const SizedBox(width: 8),
                Text(widget.message,
                    style:
                        TextStyle(color: widget.color, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
