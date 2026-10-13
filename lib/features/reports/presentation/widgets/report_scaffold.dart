import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/period_side_sheet.dart';

/// Shared chrome for report screens: a title, an optional period button in the
/// app bar (opening a side sheet) that shows the current period, an optional
/// refresh action, and a scrollable body. Keeps every report consistent and the
/// body free of top chips.
class ReportScaffold extends StatelessWidget {
  const ReportScaffold({
    required this.title,
    required this.body,
    this.period,
    this.onPeriodChanged,
    this.onRefresh,
    this.bottom,
    this.endDrawerExtra = const [],
    this.actions = const [],
    super.key,
  });

  /// Extra leading app-bar actions (e.g. a tutorial help button).
  final List<Widget> actions;

  final String title;
  final Widget body;

  /// When provided, a period button + side sheet are shown.
  final ReportPeriod? period;
  final ValueChanged<ReportPeriod>? onPeriodChanged;
  final VoidCallback? onRefresh;

  /// Extra controls appended inside the period side sheet (e.g. a display
  /// currency selector). Only shown when the period side sheet is shown.
  final List<Widget> endDrawerExtra;

  /// Optional app-bar bottom (e.g. a TabBar for the expiry report).
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final hasPeriod = period != null && onPeriodChanged != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: bottom,
        actions: [
          ...actions,
          if (hasPeriod)
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
      body: body,
    );
  }
}
