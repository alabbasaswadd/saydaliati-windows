import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// نتيجة نموذج إنشاء دور جديد — الاسم والوصف فقط؛ صلاحياته تُضبط بعد
/// الإنشاء من مصفوفة الصلاحيات ([showRolePermissionsDialog]) لأنه يبدأ بلا
/// أي صلاحية.
class RoleFormResult {
  const RoleFormResult({required this.roleName, this.description});

  final String roleName;
  final String? description;
}

Future<RoleFormResult?> showRoleFormDialog(BuildContext context) {
  return showDialog<RoleFormResult>(
    context: context,
    builder: (_) => const _RoleFormDialog(),
  );
}

class _RoleFormDialog extends StatefulWidget {
  const _RoleFormDialog();

  @override
  State<_RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<_RoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(RoleFormResult(
      roleName: _nameController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_moderator_outlined,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: Text('إضافة دور',
                            style: theme.textTheme.titleMedium)),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _nameController,
                  label: 'اسم الدور',
                  isRequired: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppStrings.requiredField
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _descController,
                  label: 'الوصف (اختياري)',
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.cancel),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: _submit,
                      child: const Text(AppStrings.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
