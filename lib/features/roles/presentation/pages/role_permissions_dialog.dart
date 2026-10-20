import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';
import 'package:saydaliati/features/roles/domain/entities/permission_item.dart';

/// مصفوفة الصلاحيات (خانات اختيار مجمَّعة حسب الوحدة) لدور غير رئيسي —
/// يُستدعى فقط بعد أن يتحقّق المستدعي من `!role.isSystem`. يُرجع قائمة
/// رموز (ids) الصلاحيات المختارة، أو `null` إن أُلغي.
Future<List<String>?> showRolePermissionsDialog(
  BuildContext context, {
  required AppRole role,
  required List<PermissionItem> catalog,
}) {
  return showDialog<List<String>?>(
    context: context,
    builder: (_) => _RolePermissionsDialog(role: role, catalog: catalog),
  );
}

class _RolePermissionsDialog extends StatefulWidget {
  const _RolePermissionsDialog({required this.role, required this.catalog});

  final AppRole role;
  final List<PermissionItem> catalog;

  @override
  State<_RolePermissionsDialog> createState() =>
      _RolePermissionsDialogState();
}

class _RolePermissionsDialogState extends State<_RolePermissionsDialog> {
  late final Set<String> _selectedIds = widget.catalog
      .where((p) => widget.role.permissionCodes.contains(p.code))
      .map((p) => p.id)
      .toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byModule = <String, List<PermissionItem>>{};
    for (final p in widget.catalog) {
      byModule.putIfAbsent(p.module, () => []).add(p);
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.admin_panel_settings_outlined,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('صلاحيات دور "${widget.role.roleName}"',
                        style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView(
                  children: [
                    for (final module in byModule.keys) ...[
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: Text(
                          module,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      for (final p in byModule[module]!)
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                              p.descriptionAr.isNotEmpty
                                  ? p.descriptionAr
                                  : p.code),
                          subtitle: Text(p.code,
                              style: theme.textTheme.bodySmall,
                              textDirection: TextDirection.ltr),
                          value: _selectedIds.contains(p.id),
                          onChanged: (checked) => setState(() {
                            if (checked == true) {
                              _selectedIds.add(p.id);
                            } else {
                              _selectedIds.remove(p.id);
                            }
                          }),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(AppStrings.cancel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_selectedIds.toList()),
                    child: const Text(AppStrings.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
