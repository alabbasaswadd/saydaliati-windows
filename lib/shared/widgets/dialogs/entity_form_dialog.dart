import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// One field in an [showEntityFormDialog].
class EntityField {
  const EntityField({
    required this.key,
    required this.label,
    this.initial,
    this.hint,
    this.isRequired = false,
  });

  final String key;
  final String label;
  final String? initial;
  final String? hint;
  final bool isRequired;
}

/// A reusable add/edit dialog for simple entities: renders one [AppTextField]
/// per [EntityField], validates required fields, and returns a `{key: value}`
/// map (trimmed) on save — or null on cancel. Used by the catalog CRUD screens
/// (categories, manufacturers, units, …).
Future<Map<String, String>?> showEntityFormDialog(
  BuildContext context, {
  required String title,
  required List<EntityField> fields,
}) {
  return showDialog<Map<String, String>>(
    context: context,
    builder: (_) => _EntityFormDialog(title: title, fields: fields),
  );
}

class _EntityFormDialog extends StatefulWidget {
  const _EntityFormDialog({required this.title, required this.fields});

  final String title;
  final List<EntityField> fields;

  @override
  State<_EntityFormDialog> createState() => _EntityFormDialogState();
}

class _EntityFormDialogState extends State<_EntityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      f.key: TextEditingController(text: f.initial ?? ''),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop({
      for (final f in widget.fields) f.key: _controllers[f.key]!.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final f in widget.fields) ...[
              AppTextField(
                controller: _controllers[f.key],
                label: f.label,
                hint: f.hint,
                isRequired: f.isRequired,
                validator: f.isRequired
                    ? (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
      actions: [
        AppButton.text(
          label: AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(
          label: AppStrings.save,
          fullWidth: false,
          onPressed: _submit,
        ),
      ],
    );
  }
}
