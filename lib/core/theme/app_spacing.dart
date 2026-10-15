import 'package:flutter/widgets.dart';

/// Spacing scale — use these instead of ad-hoc numbers so padding/gaps are
/// consistent everywhere. 4-pt based.
abstract final class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Ready-made gap widgets (vertical / horizontal).
  static const Widget gapXs = SizedBox(height: xs, width: xs);
  static const Widget gapSm = SizedBox(height: sm, width: sm);
  static const Widget gapMd = SizedBox(height: md, width: md);
  static const Widget gapLg = SizedBox(height: lg, width: lg);
  static const Widget gapXl = SizedBox(height: xl, width: xl);

  static const Widget vSm = SizedBox(height: sm);
  static const Widget vMd = SizedBox(height: md);
  static const Widget vLg = SizedBox(height: lg);
  static const Widget vXl = SizedBox(height: xl);

  static const Widget hSm = SizedBox(width: sm);
  static const Widget hMd = SizedBox(width: md);
  static const Widget hLg = SizedBox(width: lg);
}

/// Corner radii.
abstract final class AppRadius {
  const AppRadius._();

  /// استدارة خفيفة جداً — لعناصر شريط أدوات الفاتورة: تكسر حدّة الزاوية
  /// وتُبقي الحقل مستطيلاً واضح الإطار.
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;

  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
}

/// Fixed component sizes (heights, icon sizes) for a consistent rhythm.
abstract final class AppSizes {
  const AppSizes._();

  static const double buttonHeight = 50;
  static const double buttonHeightSm = 40;
  static const double inputHeight = 54;

  /// ارتفاع عناصر شريط أدوات الفاتورة (تاريخ/عملة/عميل/حساب/طريقة دفع/وصفة).
  /// قيمة واحدة لكل العناصر حتى تتحاذى رأسياً على خط واحد بلا تفاوت.
  static const double toolbarFieldHeight = 48;

  static const double iconXs = 16;
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;

  /// Max content width on large screens (keeps forms readable on tablet/desktop).
  static const double maxContentWidth = 560;
}

/// Desktop-specific layout dimensions.
abstract final class AppDesktopSizes {
  const AppDesktopSizes._();

  static const double titleBarHeight = 40;
  static const double sidebarExpanded = 240;
  static const double sidebarCollapsed = 64;
  static const double sidebarItemHeight = 40;
  static const double sidebarSectionHeaderHeight = 28;

  /// Minimum supported window width.
  static const double minWindowWidth = 1280;
}
