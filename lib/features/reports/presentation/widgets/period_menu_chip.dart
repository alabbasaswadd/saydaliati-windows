import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/shared/widgets/filters/filter_bar.dart';

/// Inline period selector for report filter bars: a compact menu chip showing
/// the current period; "custom" opens the date-range picker. The desktop
/// replacement for the period end-drawer (which stays for compact widths).
class PeriodMenuChip extends StatelessWidget {
  const PeriodMenuChip({
    required this.period,
    required this.onChanged,
    super.key,
  });

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;

  Future<void> _pickCustom(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: DateTimeRange(
        start: period.start,
        end: period.end.subtract(const Duration(days: 1)),
      ),
    );
    if (result != null) onChanged(ReportPeriod.custom(result.start, result.end));
  }

  @override
  Widget build(BuildContext context) {
    return AppMenuChip<ReportPeriodKind>(
      icon: Icons.calendar_today_outlined,
      tooltip: AppStrings.period,
      label: period.label,
      items: const [
        PopupMenuItem(
            value: ReportPeriodKind.today,
            child: Text(AppStrings.periodToday)),
        PopupMenuItem(
            value: ReportPeriodKind.week, child: Text(AppStrings.periodWeek)),
        PopupMenuItem(
            value: ReportPeriodKind.month, child: Text(AppStrings.periodMonth)),
        PopupMenuItem(
            value: ReportPeriodKind.year, child: Text(AppStrings.periodYear)),
        PopupMenuItem(
            value: ReportPeriodKind.custom,
            child: Text(AppStrings.periodCustom)),
      ],
      onSelected: (kind) {
        switch (kind) {
          case ReportPeriodKind.today:
            onChanged(ReportPeriod.today());
          case ReportPeriodKind.week:
            onChanged(ReportPeriod.week());
          case ReportPeriodKind.month:
            onChanged(ReportPeriod.month());
          case ReportPeriodKind.year:
            onChanged(ReportPeriod.year());
          case ReportPeriodKind.custom:
            _pickCustom(context);
        }
      },
    );
  }
}
