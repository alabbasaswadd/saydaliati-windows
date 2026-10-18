import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/errors/failure.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';

/// Centered loading indicator with an optional message. One loading look app-wide.
class LoadingState extends StatefulWidget {
  const LoadingState({this.message, super.key});

  final String? message;

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  /// تأخير قصير قبل الظهور.
  ///
  /// أكثر القراءات تعود من الكاش في أجزاء من الثانية، وإظهار مؤشّر لها
  /// يُنتج وميضاً يجعل الشاشة تبدو مضطربة. فما يسبق هذا التأخير لا يُرى
  /// أصلاً، وما يتجاوزه يظهر مرّةً واحدة بهدوء.
  static const _delay = Duration(milliseconds: 180);

  bool _visible = false;
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    Future<void>.delayed(_delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة الصيدلية لا دائرة دوّارة: الدائرة عامّة تُستعمل في كل
            // تطبيق، والأيقونة تقول **أين** أنت أثناء الانتظار. وتتنفّس
            // برفق (تكبير طفيف) بدل أن تدور — فالدوران يُلحّ على العين
            // والتنفّس يُطمئن.
            ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.06).animate(
                CurvedAnimation(
                  parent: _c,
                  curve: Curves.easeInOut,
                  reverseCurve: Curves.easeInOut,
                ),
              ),
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.09),
                ),
                child: Icon(Icons.local_pharmacy_rounded,
                    size: 28, color: primary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.message ?? AppStrings.loading,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                const SizedBox(width: 6),
                // ثلاث نقاط تتعاقب — تُظهر أن العمل جارٍ بلا ضجيج بصري.
                _Dots(controller: _c, color: primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ثلاث نقاط تُضيء بالتعاقب على إيقاع المتحكّم نفسه.
class _Dots extends StatelessWidget {
  const _Dots({required this.controller, required this.color});

  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value * 3; // ثلاث مراحل في الدورة
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 3),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(
                    // النقطة التي حان دورها أوضح، والبقية باهتة.
                    alpha: (t.floor() % 3) == i ? 0.95 : 0.25,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Empty-data placeholder: icon + message + optional action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.hintColor),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? AppStrings.emptyDefault,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.outline(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error placeholder. Prefer [ErrorState.fromError] so a [Failure] renders its
/// message (and connectivity errors get the "no internet" treatment).
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    super.key,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  /// Renders a [Failure] as the right state. Connectivity failures (no internet
  /// / timeout) get the animated [OfflineState]; everything else the plain error.
  static Widget fromError(Object error, {VoidCallback? onRetry}) {
    if (error is NetworkFailure || error is TimeoutFailure) {
      return OfflineState(onRetry: onRetry);
    }
    final message =
        error is Failure ? error.displayMessage : AppStrings.errorDefault;
    return ErrorState(message: message, onRetry: onRetry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.outline(
                label: AppStrings.retry,
                onPressed: onRetry,
                icon: Icons.refresh,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated "no internet" state for online-only screens. A wifi-off glyph with
/// pulsing signal rings — evokes "searching for a connection" — plus a hint and a
/// retry action. Shown by [ErrorState.fromError] for connectivity failures.
class OfflineState extends StatefulWidget {
  const OfflineState({this.message, this.onRetry, super.key});

  final String? message;
  final VoidCallback? onRetry;

  @override
  State<OfflineState> createState() => _OfflineStateState();
}

class _OfflineStateState extends State<OfflineState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => CustomPaint(
                  painter: _SignalPulsePainter(
                    progress: _controller.value,
                    color: color,
                  ),
                  child: child,
                ),
                child: Center(
                  child: Icon(Icons.wifi_off_rounded, size: 48, color: color),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.noInternet,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.message ?? AppStrings.noInternetHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            if (widget.onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.outline(
                label: AppStrings.retry,
                onPressed: widget.onRetry,
                icon: Icons.refresh,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Paints staggered rings expanding + fading outward, driven by a 0→1 progress.
class _SignalPulsePainter extends CustomPainter {
  const _SignalPulsePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const rings = 3;
    const minRadius = 28.0;
    final maxRadius = size.width / 2;
    for (var i = 0; i < rings; i++) {
      final t = (progress + i / rings) % 1.0;
      final radius = minRadius + (maxRadius - minRadius) * t;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color.withValues(alpha: (1 - t) * 0.35);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignalPulsePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Success placeholder (e.g. after completing a flow on its own screen).
class SuccessState extends StatelessWidget {
  const SuccessState({this.message, this.actionLabel, this.onAction, super.key});

  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text(message ?? AppStrings.successDefault,
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                  label: actionLabel!, onPressed: onAction, fullWidth: false),
            ],
          ],
        ),
      ),
    );
  }
}
