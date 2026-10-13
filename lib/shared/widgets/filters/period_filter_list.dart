import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';

/// Period choices for a [FilterSideSheet]: كل الفترات / اليوم / الأسبوع / الشهر /
/// السنة / مخصّص. A null [period] means "all periods" (no date filter). Selecting
/// an option only updates state (the panel stays open so other filters can be
/// set too).
class PeriodFilterList extends StatelessWidget {
  const PeriodFilterList({
    required this.period,
    required this.onChanged,
    super.key,
  });

  final ReportPeriod? period;
  final ValueChanged<ReportPeriod?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _opt(context, AppStrings.periodAll, period == null, () => onChanged(null)),
        _opt(context, AppStrings.periodToday,
            period?.kind == ReportPeriodKind.today, () => onChanged(ReportPeriod.today())),
        _opt(context, AppStrings.periodWeek,
            period?.kind == ReportPeriodKind.week, () => onChanged(ReportPeriod.week())),
        _opt(context, AppStrings.periodMonth,
            period?.kind == ReportPeriodKind.month, () => onChanged(ReportPeriod.month())),
        _opt(context, AppStrings.periodYear,
            period?.kind == ReportPeriodKind.year, () => onChanged(ReportPeriod.year())),
        _custom(context),
      ],
    );
  }

  Widget _opt(BuildContext context, String label, bool selected, VoidCallback onTap) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }

  Widget _custom(BuildContext context) {
    final selected = period?.kind == ReportPeriodKind.custom;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.date_range,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: const Text(AppStrings.periodCustom),
      subtitle: selected ? Text(period!.label) : null,
      onTap: () async {
        final now = DateTime.now();
        final result = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 3),
          lastDate: DateTime(now.year + 1, 12, 31),
          initialDateRange: period != null
              ? DateTimeRange(
                  start: period!.start,
                  end: period!.end.subtract(const Duration(days: 1)),
                )
              : null,
        );
        if (result != null) {
          onChanged(ReportPeriod.custom(result.start, result.end));
        }
      },
    );
  }
}
