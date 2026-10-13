import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// One option in an [AppDropdown].
class AppDropdownItem<T> {
  const AppDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// A themed dropdown with an external label + required marker, matching
/// [AppTextField]. Generic over the value type.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    super.key,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          hint: hint == null ? null : Text(hint!),
          decoration: const InputDecoration(),
          items: [
            for (final item in items)
              DropdownMenuItem<T>(value: item.value, child: Text(item.label)),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
