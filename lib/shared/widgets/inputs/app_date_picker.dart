import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A date field that opens the Material date picker (localized Arabic via the
/// app locale). Read-only text showing the selected date; tapping picks a new one.
class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    super.key,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? label;
  final String? hint;
  final bool isRequired;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = value == null
        ? (hint ?? '')
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: theme.textTheme.labelLarge,
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        InkWell(
          onTap: enabled ? () => _pick(context) : null,
          borderRadius: AppRadius.brMd,
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            child: Text(
              text,
              style: value == null
                  ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
                  : theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
