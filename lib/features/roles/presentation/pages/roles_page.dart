import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/permissions/permission_codes.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';
import 'package:saydaliati/features/roles/presentation/pages/role_form_dialog.dart';
import 'package:saydaliati/features/roles/presentation/pages/role_permissions_dialog.dart';
import 'package:saydaliati/features/roles/roles_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/permission_gate.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// إدارة الأدوار وصلاحياتها. دور Admin (`isSystem`) محمي — صلاحياته ثابتة
/// دائماً ولا يُحذف؛ أي دور آخر (بما فيه "مساعد صيدلي" الافتراضي) قابل
/// للتعديل والحذف بالكامل — هذا ما يجعل النظام "ديناميكياً" فعلاً.
class RolesPage extends ConsumerWidget {
  const RolesPage({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final values = await showRoleFormDialog(context);
    if (values == null || !context.mounted) return;
    final result = await ref.read(roleRepositoryProvider).create(
          roleName: values.roleName,
          description: values.description,
        );
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(rolesListProvider);
        AppSnackbar.success(context, AppStrings.createdSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _editPermissions(
      BuildContext context, WidgetRef ref, AppRole role) async {
    if (role.isSystem) {
      await showErrorDialog(context,
          message:
              'لا يمكن تعديل صلاحيات الدور الرئيسي — صلاحياته ثابتة دائماً.');
      return;
    }
    final catalog = ref.read(permissionsCatalogProvider).value ?? const [];
    final selectedIds =
        await showRolePermissionsDialog(context, role: role, catalog: catalog);
    if (selectedIds == null || !context.mounted) return;
    final result = await ref.read(roleRepositoryProvider).updatePermissions(
          roleId: role.id,
          permissionIds: selectedIds,
        );
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(rolesListProvider);
        AppSnackbar.success(context, AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, AppRole role) async {
    if (role.isSystem) {
      await showErrorDialog(context, message: 'لا يمكن حذف الدور الرئيسي');
      return;
    }
    final ok =
        await showDeleteConfirmationDialog(context, itemName: role.roleName);
    if (!ok || !context.mounted) return;
    final result = await ref.read(roleRepositoryProvider).delete(role.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(rolesListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // يُحمَّل مسبقاً حتى يكون جاهزاً عند فتح مصفوفة الصلاحيات لأوّل دور.
    ref.watch(permissionsCatalogProvider);
    final async = ref.watch(rolesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأدوار والصلاحيات'),
        actions: [
          AppRefreshButton(
            onRefresh: () => ref.refresh(rolesListProvider.future),
          ),
          PermissionGate(
            permission: PermissionCodes.rolesManage,
            child: AddEntityButton(
              label: 'إضافة دور',
              onPressed: () => _create(context, ref),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(rolesListProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'لا توجد أدوار بعد')
            : SimpleEntityGrid<AppRole>(
                items: items,
                idOf: (r) => r.id,
                columns: [
                  SimpleEntityColumn('اسم الدور', (r) => r.roleName,
                      width: 200),
                  SimpleEntityColumn('الوصف', (r) => r.description,
                      width: 220),
                  SimpleEntityColumn(
                      'رئيسي', (r) => r.isSystem ? 'نعم' : 'لا',
                      width: 80),
                  SimpleEntityColumn('عدد الصلاحيات',
                      (r) => '${r.permissionCodes.length}',
                      width: 110),
                ],
                onEdit: (r) => _editPermissions(context, ref, r),
                onDelete: (r) => _delete(context, ref, r),
              ),
      ),
    );
  }
}
