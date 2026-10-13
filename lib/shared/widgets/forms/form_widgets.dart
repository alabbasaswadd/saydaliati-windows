import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// A titled group of form fields inside a card — the standard way to structure
/// any form so all forms look the same.
class AppFormSection extends StatelessWidget {
  const AppFormSection({
    required this.children,
    this.title,
    this.spacing = AppSpacing.md,
    super.key,
  });

  final String? title;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final withGaps = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      withGaps.add(children[i]);
      if (i != children.length - 1) withGaps.add(SizedBox(height: spacing));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: withGaps,
            ),
          ),
        ),
      ],
    );
  }
}

/// A standalone field label with an optional required marker — for custom fields
/// that don't use [AppTextField]'s built-in label.
class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel(this.text, {this.isRequired = false, super.key});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: RichText(
        text: TextSpan(
          text: text,
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
    );
  }
}

/// A small inline validation/error message with an icon.
class ValidationMessage extends StatelessWidget {
  const ValidationMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
