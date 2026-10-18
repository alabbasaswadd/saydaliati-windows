import 'package:flutter/material.dart';
import 'package:saydaliati/app/shell/widgets/window_controls.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:window_manager/window_manager.dart';

/// Shared chrome for login/register.
///
/// Responsive:
///  - Wide windows (desktop) → split layout: the form pane sits on the RIGHT
///    (the start side in RTL) and a branded gradient panel fills the LEFT.
///  - Narrow windows → a single scrollable column with a compact branded
///    header above the form card (the previous mobile-style layout).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  /// Below this width the split collapses into the stacked layout.
  static const double _splitBreakpoint = 880;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= _splitBreakpoint;
    return Scaffold(
      body: Stack(
        children: [
          if (wide)
            Row(
              children: [
                // RTL: the first child is the RIGHT pane — the form side.
                Expanded(
                  flex: 5,
                  child: _FormPane(title: title, subtitle: subtitle, child: child),
                ),
                const Expanded(flex: 6, child: _BrandPane()),
              ],
            )
          else
            _CompactLayout(title: title, subtitle: subtitle, child: child),
          // شاشات الدخول بلا شريط عنوان (TitleBarStyle.hidden) — شريطٌ شفّاف
          // يُبقي النافذة قابلة للسحب.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 32,
            child: DragToMoveArea(child: SizedBox.expand()),
          ),
          // وأزرار النافذة فوقه: بدونها لا يجد مَن يقف عند تسجيل الدخول
          // سبيلاً إلى تصغير النافذة ولا تكبيرها ولا إغلاقها إلّا بـAlt+F4.
          //
          // لونها يتبع ما تحتها: في العرض الواسع أعلى اليمين لوحةُ النموذج
          // (سطحٌ فاتح)، وفي الضيّق تدرّجُ العلامة الأخضر — فأيقونةٌ داكنة
          // هناك تذوب فيه.
          Positioned(
            top: 0,
            right: 0,
            child: WindowControls(
              height: 32,
              foreground: wide
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Right pane: the form ───────────────────────────────────────────────────

class _FormPane extends StatelessWidget {
  const _FormPane({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle ?? AppStrings.appTagline,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Brand accent under the heading.
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Left pane: brand panel ─────────────────────────────────────────────────

class _BrandPane extends StatelessWidget {
  const _BrandPane();

  static const List<(IconData, String)> _features = [
    (Icons.point_of_sale_outlined, 'نقطة بيع سريعة تعمل دون اتصال'),
    (Icons.inventory_2_outlined, 'إدارة المخزون وتنبيهات النواقص والصلاحية'),
    (Icons.receipt_long_outlined, 'فواتير وتقارير PDF باللغة العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Soft decorative circles.
          const _DecorCircle(top: -90, start: -70, size: 300, alpha: 0.08),
          const _DecorCircle(bottom: -120, end: -90, size: 380, alpha: 0.07),
          const _DecorCircle(top: 140, end: 60, size: 90, alpha: 0.10),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _BrandLogo(size: 92),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppStrings.appTagline,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    for (final (icon, label) in _features) ...[
                      _FeatureRow(icon: icon, label: label),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: AppRadius.brLg,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: AppSizes.iconMd),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({
    required this.size,
    required this.alpha,
    this.top,
    this.bottom,
    this.start,
    this.end,
  });

  final double size;
  final double alpha;
  final double? top;
  final double? bottom;
  final double? start;
  final double? end;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: top,
      bottom: bottom,
      start: start,
      end: end,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg + 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        'assets/icon/app_icon.png',
        width: size,
        height: size,
        errorBuilder: (_, _, _) => Icon(
          Icons.local_pharmacy_outlined,
          size: size,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─── Narrow windows: stacked layout ─────────────────────────────────────────

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              const _BrandLogo(size: 52),
              const SizedBox(height: AppSpacing.md),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                AppStrings.appTagline,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: AppSpacing.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
