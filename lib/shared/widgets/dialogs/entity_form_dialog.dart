import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';
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
/// (customers, suppliers, categories, manufacturers, units, …).
///
/// Windows-style popup: narrow fixed width, a close ✕ in the header, and
/// small content-sized buttons aligned to the end.
Future<Map<String, String>?> showEntityFormDialog(
  BuildContext context, {
  required String title,
  required List<EntityField> fields,
  IconData icon = Icons.edit_note_outlined,
}) {
  return showDialog<Map<String, String>>(
    context: context,
    builder: (_) => _EntityFormDialog(title: title, fields: fields, icon: icon),
  );
}

class _EntityFormDialog extends StatefulWidget {
  const _EntityFormDialog({
    required this.title,
    required this.fields,
    required this.icon,
  });

  final String title;
  final List<EntityField> fields;
  final IconData icon;

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
    final theme = Theme.of(context);
    return SaveShortcut(
      onSave: _submit,
      child: Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس بأسلوب نوافذ ويندوز: أيقونة + عنوان + زر إغلاق صغير.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(widget.icon, color: theme.colorScheme.primary, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(widget.title,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        tooltip: AppStrings.close,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                  ),
                  child: SingleChildScrollView(
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
                ),
                const SizedBox(height: AppSpacing.xs),
                // أزرار بحجم محتواها بدل الممتدة — أسلوب نوافذ ويندوز.
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 96,
                      height: 32,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          textStyle: theme.textTheme.bodyMedium,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(AppStrings.cancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 96,
                      height: 32,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          textStyle: theme.textTheme.bodyMedium,
                        ),
                        onPressed: _submit,
                        child: const Text(AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
