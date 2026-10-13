import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/utils/app_date.dart';

/// A date shown as `YYYY-MM-DD` with its Arabic weekday name (اليوم) in a smaller
/// muted line directly underneath. One consistent presentation for every date
/// the user reads.
class DateWithDay extends StatelessWidget {
  const DateWithDay({
    required this.date,
    this.align = CrossAxisAlignment.start,
    super.key,
  });

  final DateTime date;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        Text(AppDate.ymd(date), style: theme.textTheme.bodyMedium),
        Text(
          AppDate.weekdayAr(date),
          style: theme.textTheme.bodySmall
              ?.copyWith(color: context.semantic.textSecondary),
        ),
      ],
    );
  }
}
