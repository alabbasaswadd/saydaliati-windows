import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// One-line feedback via a themed SnackBar. Use for transient success/error/info
/// messages (persistent problems belong in an `ErrorState`/dialog).
abstract final class AppSnackbar {
  const AppSnackbar._();

  /// الإشعار المعروض الآن — يُزال فور وصول غيره فلا تتراكم إشعارات فوق بعضها.
  static OverlayEntry? _active;

  /// نجاح.
  static void success(BuildContext context, String message) =>
      _toast(context, message, AppColors.success, Icons.check_circle_outline);

  /// خطأ أو فشل تحقّق — يصل عبر `showFailureSnackbar` أيضاً.
  static void error(BuildContext context, String message) =>
      _toast(context, message, AppColors.error, Icons.error_outline);

  static void info(BuildContext context, String message) =>
      _toast(context, message, AppColors.info, Icons.info_outline);

  /// إشعار عائم **أعلى وسط الشاشة**.
  ///
  /// كان النجاح في الزاوية اليسرى السفلى والخطأ شريطاً أسفل الشاشة — وكلاهما
  /// بعيد عن موضع نظر مَن يكتب فاتورة أو نموذجاً: العين على الحقول والأزرار
  /// في الوسط والأعلى، فيمرّ إشعار الفشل دون أن يُرى ويُعاد الحفظ ظنّاً أنه
  /// لم يُرسَل.
  ///
  /// وموضعٌ واحد لكل الأنواع يجعل المستخدم يتعلّم مكاناً واحداً ينظر إليه.
  static void _toast(
      BuildContext context, String message, Color color, IconData icon) {
    _active?.remove();
    _active = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        // يُترك فراغٌ لشريط العنوان المخصَّص فلا يغطّيه الإشعار.
        top: AppSpacing.lg + 8,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.topCenter,
          child: _FlashToast(
            message: message,
            icon: icon,
            color: color,
            onDone: () {
              entry.remove();
              if (_active == entry) _active = null;
            },
          ),
        ),
      ),
    );
    _active = entry;
    overlay.insert(entry);
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
        AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
    // ظهورٌ سريع، ثبات، ثم خفوت. وكان قبلها وميضٌ ثلاثيّ (سطوع ← خفوت ←
    // سطوع) يجذب العين مرّتين للرسالة نفسها — حركةٌ بلا معنى تُقرأ كعُطل.
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
          weight: 8),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 74),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
          weight: 18),
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
            // لونٌ **مصمَت** لا تلوينٌ بشفافية 12%.
            //
            // الأخضر عند 12% على خلفيةٍ فاتحة يكاد يكون أبيض، فرسالة النجاح
            // ورسالة الخطأ تبدوان بطاقةً شاحبةً واحدة ولا يُميَّز بينهما إلّا
            // بقراءة النصّ — وهو عكس الغرض من اللون. والآن: أخضر للنجاح،
            // أحمر للفشل، أزرق للتنويه — يُعرَف كلٌّ منها بلمحة واحدة.
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: AppRadius.brMd,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
