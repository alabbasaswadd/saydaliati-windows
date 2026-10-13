import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/period_menu_chip.dart';
import 'package:saydaliati/features/reports/presentation/widgets/period_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/filter_bar.dart';

/// Shared chrome for report screens.
///
/// Responsive: on medium/wide windows the period (and [inlineFilters]) render
/// in an inline [FilterBar] above the body — desktop style; on compact widths
/// they fall back to the period end-drawer behind an app-bar chip.
class ReportScaffold extends StatelessWidget {
  const ReportScaffold({
    required this.title,
    required this.body,
    this.period,
    this.onPeriodChanged,
    this.onRefresh,
    this.bottom,
    this.endDrawerExtra = const [],
    this.inlineFilters = const [],
    this.actions = const [],
    super.key,
  });

  /// Extra leading app-bar actions (e.g. a tutorial help button).
  final List<Widget> actions;

  final String title;
  final Widget body;

  /// When provided, a period selector is shown (inline bar on wide widths,
  /// end-drawer chip on compact).
  final ReportPeriod? period;
  final ValueChanged<ReportPeriod>? onPeriodChanged;
  final VoidCallback? onRefresh;

  /// Extra controls appended inside the period side sheet (compact widths).
  final List<Widget> endDrawerExtra;

  /// Extra chips/controls for the inline filter bar (wide widths) — the
  /// inline counterparts of [endDrawerExtra].
  final List<Widget> inlineFilters;

  /// Optional app-bar bottom (e.g. a TabBar for the expiry report).
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final hasPeriod = period != null && onPeriodChanged != null;
    final inline = !context.isCompact && hasPeriod;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: bottom,
        actions: [
          ...actions,
          // Compact: period chip opens the end-drawer (the mobile pattern).
          if (hasPeriod && !inline)
            Builder(
              builder: (ctx) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: ActionChip(
                  avatar: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: Text(period!.label),
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                ),
              ),
            ),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
            ),
        ],
      ),
      endDrawer: hasPeriod
          ? PeriodSideSheet(
              period: period!,
              onChanged: onPeriodChanged!,
              extra: endDrawerExtra,
            )
          : null,
      body: !inline
          ? body
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                  child: FilterBar(
                    children: [
                      PeriodMenuChip(
                          period: period!, onChanged: onPeriodChanged!),
                      ...inlineFilters,
                      // Drawer-only extras stay reachable on wide widths too.
                      if (endDrawerExtra.isNotEmpty && inlineFilters.isEmpty)
                        Builder(
                          builder: (ctx) => IconButton(
                            icon: const Icon(Icons.tune, size: 20),
                            tooltip: 'خيارات إضافية',
                            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
    );
  }
}
