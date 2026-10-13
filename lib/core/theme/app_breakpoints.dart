import 'package:flutter/widgets.dart';

/// Window-width breakpoints for the desktop-first responsive system.
///
/// The app targets Windows (min window 1280×720, typical 1366/1920), but
/// pages can also render inside narrower panes (split views, future web).
/// Pick layouts by the AVAILABLE width, not the device:
///
///  * `< medium`  (compact): single column, drawers for filters, stacked forms.
///  * `≥ medium`  (medium):  inline filter bars, 2-column forms, KPI rows.
///  * `≥ expanded` (wide):   side panels (master/detail, summary rails).
abstract final class AppBreakpoints {
  const AppBreakpoints._();

  static const double medium = 900;
  static const double expanded = 1280;

  /// Max width for page content that reads poorly when stretched
  /// (forms, settings lists, detail cards). Tables/grids may exceed it.
  static const double maxContentWidth = 1100;

  /// Max width for standalone forms (add stock, medicine form…).
  static const double maxFormWidth = 720;
}

/// Responsive helpers — read the WINDOW width. For a widget that must adapt
/// to its own pane (e.g. inside a split view), prefer [LayoutBuilder].
extension ResponsiveContext on BuildContext {
  double get windowWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => windowWidth < AppBreakpoints.medium;
  bool get isMedium =>
      windowWidth >= AppBreakpoints.medium &&
      windowWidth < AppBreakpoints.expanded;
  bool get isWide => windowWidth >= AppBreakpoints.expanded;
}

/// Centers [child] and caps its width — the standard wrapper for page bodies
/// that shouldn't stretch across the whole window (forms, hubs, detail pages).
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
