import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';

/// A side panel (end drawer) for choosing the report period, keeping the report
/// body clean of top chips. Selecting an option applies it and closes the panel.
class PeriodSideSheet extends StatelessWidget {
  const PeriodSideSheet({
    required this.period,
    required this.onChanged,
    this.extra = const [],
    super.key,
  });

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;

  /// Extra controls rendered below the period options (e.g. a display-currency
  /// selector), separated by a divider.
  final List<Widget> extra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(AppStrings.period, style: theme.textTheme.titleLarge),
            ),
            const Divider(),
            _option(context, AppStrings.periodToday, ReportPeriodKind.today,
                () => ReportPeriod.today()),
            _option(context, AppStrings.periodWeek, ReportPeriodKind.week,
                () => ReportPeriod.week()),
            _option(context, AppStrings.periodMonth, ReportPeriodKind.month,
                () => ReportPeriod.month()),
            _custom(context),
            if (extra.isNotEmpty) ...[
              const Divider(),
              ...extra,
            ],
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, String label, ReportPeriodKind kind,
      ReportPeriod Function() build) {
    final selected = period.kind == kind;
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? Theme.of(context).colorScheme.primary : null),
      title: Text(label),
      onTap: () {
        onChanged(build());
        Navigator.of(context).pop();
      },
    );
  }

  Widget _custom(BuildContext context) {
    final selected = period.kind == ReportPeriodKind.custom;
    return ListTile(
      leading: Icon(selected ? Icons.radio_button_checked : Icons.date_range,
          color: selected ? Theme.of(context).colorScheme.primary : null),
      title: const Text(AppStrings.periodCustom),
      subtitle: selected ? Text(period.label) : null,
      onTap: () async {
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
        if (result != null) {
          onChanged(ReportPeriod.custom(result.start, result.end));
          if (context.mounted) Navigator.of(context).pop();
        }
      },
    );
  }
}
