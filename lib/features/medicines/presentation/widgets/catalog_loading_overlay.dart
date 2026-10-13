import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Friendly full-screen overlay shown the FIRST time the medicine library is
/// downloaded after login (the catalog is large). A gentle pulse + rotating ring
/// keeps the user engaged, with copy that reassures this happens only once.
class CatalogLoadingOverlay extends StatefulWidget {
  const CatalogLoadingOverlay({super.key});

  @override
  State<CatalogLoadingOverlay> createState() => _CatalogLoadingOverlayState();
}

class _CatalogLoadingOverlayState extends State<CatalogLoadingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Material(
      color: theme.scaffoldBackgroundColor.withValues(alpha: 0.98),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating ring
                    RotationTransition(
                      turns: _spin,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(colors: [
                            primary.withValues(alpha: 0.0),
                            primary.withValues(alpha: 0.6),
                            primary,
                          ]),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    // Pulsing pill icon
                    ScaleTransition(
                      scale: Tween(begin: 0.82, end: 1.12).animate(
                          CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withValues(alpha: 0.12),
                        ),
                        child: Transform.rotate(
                          angle: -math.pi / 6,
                          child: Icon(Icons.medication_rounded,
                              size: 38, color: primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'جارٍ تحضير مكتبة الأدوية 💊',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'نقوم بتحميل الأدوية لأول مرة فقط.\nقد يستغرق بضع ثوانٍ، وبعدها سيفتح التطبيق فوراً في كل مرة.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _AnimatedDots(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three dots that fade in sequence — a lightweight "working…" indicator.
class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final t = (_c.value - i * 0.2) % 1.0;
          final op = (0.3 + 0.7 * (1 - (t - 0.5).abs() * 2)).clamp(0.3, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Opacity(
              opacity: op,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              ),
            ),
          );
        }),
      ),
    );
  }
}
