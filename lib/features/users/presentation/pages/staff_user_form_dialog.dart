import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/roles/roles_providers.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// نتيجة النموذج. في الإنشاء تُملأ كل الحقول؛ في التعديل فقط [roleId] (وربما
/// [isActive]) — لا يوجد مسار خادم لتعديل اسم المستخدم/البريد/الهاتف/كلمة
/// المرور لمستخدم موجود، فالتعديل يقتصر على الدور والحالة.
class StaffUserFormResult {
  const StaffUserFormResult({
    required this.roleId,
    this.userName,
    this.email,
    this.phone,
    this.password,
    this.isActive,
  });

  final String roleId;
  final String? userName;
  final String? email;
  final String? phone;
  final String? password;
  final bool? isActive;
}

Future<StaffUserFormResult?> showStaffUserFormDialog(
  BuildContext context, {
  StaffUser? existing,
}) {
  return showDialog<StaffUserFormResult>(
    context: context,
    builder: (_) => _StaffUserFormDialog(existing: existing),
  );
}

class _StaffUserFormDialog extends ConsumerStatefulWidget {
  const _StaffUserFormDialog({this.existing});

  final StaffUser? existing;

  @override
  ConsumerState<_StaffUserFormDialog> createState() =>
      _StaffUserFormDialogState();
}

class _StaffUserFormDialogState extends ConsumerState<_StaffUserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late String? _roleId = widget.existing?.roleId;
  late bool _isActive = widget.existing?.isActive ?? true;

  bool get _isEdit => widget.existing != null;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final roleId = _roleId;
    if (roleId == null) return;
    Navigator.of(context).pop(StaffUserFormResult(
      roleId: roleId,
      userName: _isEdit ? null : _userNameController.text.trim(),
      email: _isEdit
          ? null
          : (_emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim()),
      phone: _isEdit ? null : _phoneController.text.trim(),
      password: _isEdit ? null : _passwordController.text,
      isActive: _isEdit ? _isActive : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roles = ref.watch(rolesListProvider).value ?? const [];

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
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
                    Icon(Icons.person_add_alt_outlined,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _isEdit ? 'تعديل دور المستخدم' : 'إضافة مستخدم',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (!_isEdit) ...[
                  AppTextField(
                    controller: _userNameController,
                    label: 'اسم المستخدم',
                    isRequired: true,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني (اختياري)',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _phoneController,
                    label: 'الهاتف',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    isRequired: true,
                    obscureText: true,
                    validator: (v) => (v == null || v.trim().length < 6)
                        ? 'كلمة المرور يجب ألا تقل عن ٦ أحرف'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text('الدور', style: theme.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<String>(
                  initialValue: _roleId,
                  items: [
                    for (final r in roles)
                      DropdownMenuItem(value: r.id, child: Text(r.roleName)),
                  ],
                  onChanged: (v) => setState(() => _roleId = v),
                  validator: (v) =>
                      v == null ? AppStrings.requiredField : null,
                  decoration: const InputDecoration(
                    hintText: 'اختر دوراً',
                  ),
                ),
                if (_isEdit) ...[
                  const SizedBox(height: AppSpacing.md),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('نشط'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                ],
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
