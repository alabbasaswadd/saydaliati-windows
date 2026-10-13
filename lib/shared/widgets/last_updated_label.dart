import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';

/// A subtle "آخر تحديث: …" line for local-first lists. Renders nothing until a
/// first sync has happened ([at] is null before then).
class LastUpdatedLabel extends StatelessWidget {
  const LastUpdatedLabel({required this.at, super.key});

  final DateTime? at;

  @override
  Widget build(BuildContext context) {
    if (at == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final time = '${at!.hour.toString().padLeft(2, '0')}:'
        '${at!.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
      child: Row(
        children: [
          Icon(Icons.cloud_done_outlined,
              size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${AppStrings.lastUpdated}: ${AppDate.ymd(at!)} $time',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
