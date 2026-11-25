import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/permissions/permission_codes.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';
import 'package:saydaliati/features/roles/presentation/pages/role_form_dialog.dart';
import 'package:saydaliati/features/roles/presentation/pages/role_permissions_dialog.dart';
import 'package:saydaliati/features/roles/roles_providers.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';
import 'package:saydaliati/features/users/presentation/pages/staff_user_form_dialog.dart';
import 'package:saydaliati/features/users/user_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/permission_gate.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// صفحة موحَّدة — تبويبان: المستخدمون | الأدوار والصلاحيات.
class UsersAndPermissionsPage extends ConsumerStatefulWidget {
  const UsersAndPermissionsPage({super.key});

  @override
  ConsumerState<UsersAndPermissionsPage> createState() =>
      _UsersAndPermissionsPageState();
}

class _UsersAndPermissionsPageState
    extends ConsumerState<UsersAndPermissionsPage>
    with SingleTickerProviderStateMixin {
  late final _tab = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمون والصلاحيات'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(icon: Icon(Icons.manage_accounts_outlined), text: 'المستخدمون'),
            Tab(
                icon: Icon(Icons.admin_panel_settings_outlined),
                text: 'الأدوار والصلاحيات'),
          ],
        ),
        actions: [
          // زر التحديث يعمل على التبويب الحالي
          ListenableBuilder(
            listenable: _tab,
            builder: (_, _) => _tab.index == 0
                ? AppRefreshButton(
                    onRefresh: () => ref.refresh(staffUsersProvider.future),
                  )
                : AppRefreshButton(
                    onRefresh: () => ref.refresh(rolesListProvider.future),
                  ),
          ),
          // زر الإضافة يتبدّل بحسب التبويب
          ListenableBuilder(
            listenable: _tab,
            builder: (_, _) => _tab.index == 0
                ? PermissionGate(
                    permission: PermissionCodes.usersCreate,
                    child: AddEntityButton(
                      label: 'إضافة مستخدم',
                      onPressed: () => _createUser(context),
                    ),
                  )
                : PermissionGate(
                    permission: PermissionCodes.rolesManage,
                    child: AddEntityButton(
                      label: 'إضافة دور',
                      onPressed: () => _createRole(context),
                    ),
                  ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _UsersBody(
            onEdit: _editUser,
            onDeactivate: _quickDeactivate,
          ),
          _RolesBody(
            onEditPermissions: _editPermissions,
            onDelete: _deleteRole,
          ),
        ],
      ),
    );
  }

  // ── Users ──────────────────────────────────────────────────────────────────

  Future<void> _createUser(BuildContext context) async {
    final values = await showStaffUserFormDialog(context);
    if (values == null || !context.mounted) return;
    final result = await ref.read(userRepositoryProvider).createStaffUser(
          userName: values.userName!,
          email: values.email,
          phone: values.phone!,
          password: values.password!,
          roleId: values.roleId,
        );
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(staffUsersProvider);
        AppSnackbar.success(context, AppStrings.createdSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _editUser(BuildContext context, StaffUser user) async {
    final values = await showStaffUserFormDialog(context, existing: user);
    if (values == null || !context.mounted) return;
    final repo = ref.read(userRepositoryProvider);
    var result = values.roleId == user.roleId
        ? Result<StaffUser>.success(user)
        : await repo.assignRole(userId: user.id, roleId: values.roleId);
    if (result.isSuccess &&
        values.isActive != null &&
        values.isActive != user.isActive) {
      result =
          await repo.setActive(userId: user.id, isActive: values.isActive!);
    }
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(staffUsersProvider);
        AppSnackbar.success(context, AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _quickDeactivate(BuildContext context, StaffUser user) async {
    final ok = await showConfirmationDialog(
      context,
      title: 'تعطيل المستخدم',
      message: 'هل أنت متأكد من تعطيل "${user.userName}"؟ '
          'يمكنك إعادة تفعيله لاحقاً من زر التعديل.',
      confirmLabel: 'تعطيل',
      destructive: true,
      icon: Icons.block,
    );
    if (!ok || !context.mounted) return;
    final result = await ref
        .read(userRepositoryProvider)
        .setActive(userId: user.id, isActive: false);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(staffUsersProvider);
        AppSnackbar.success(context, 'تم تعطيل المستخدم');
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  // ── Roles ──────────────────────────────────────────────────────────────────

  Future<void> _createRole(BuildContext context) async {
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

  Future<void> _editPermissions(BuildContext context, AppRole role) async {
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

  Future<void> _deleteRole(BuildContext context, AppRole role) async {
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
}

// ── Users body ─────────────────────────────────────────────────────────────

class _UsersBody extends ConsumerWidget {
  const _UsersBody({required this.onEdit, required this.onDeactivate});

  final Future<void> Function(BuildContext, StaffUser) onEdit;
  final Future<void> Function(BuildContext, StaffUser) onDeactivate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rolesListProvider);
    final async = ref.watch(staffUsersProvider);
    return async.when(
      loading: () => const LoadingState(),
      error: (e, _) =>
          ErrorState.fromError(e, onRetry: () => ref.invalidate(staffUsersProvider)),
      data: (items) => items.isEmpty
          ? const EmptyState(message: 'لا يوجد مستخدمون بعد')
          : SimpleEntityGrid<StaffUser>(
              items: items,
              idOf: (u) => u.id,
              columns: [
                SimpleEntityColumn('اسم المستخدم', (u) => u.userName,
                    width: 180),
                SimpleEntityColumn(
                    'البريد/الهاتف',
                    (u) => u.email.isNotEmpty ? u.email : u.phone,
                    width: 200),
                SimpleEntityColumn('الدور', (u) => u.roleName ?? '—',
                    width: 160),
                SimpleEntityColumn('الحالة', (u) => u.isActive ? 'نشط' : 'معطّل',
                    width: 90),
              ],
              onEdit: (u) => onEdit(context, u),
              onDelete: (u) => onDeactivate(context, u),
            ),
    );
  }
}

// ── Roles body ─────────────────────────────────────────────────────────────

class _RolesBody extends ConsumerWidget {
  const _RolesBody(
      {required this.onEditPermissions, required this.onDelete});

  final Future<void> Function(BuildContext, AppRole) onEditPermissions;
  final Future<void> Function(BuildContext, AppRole) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(permissionsCatalogProvider);
    final async = ref.watch(rolesListProvider);
    return async.when(
      loading: () => const LoadingState(),
      error: (e, _) => ErrorState.fromError(
          e, onRetry: () => ref.invalidate(rolesListProvider)),
      data: (items) => items.isEmpty
          ? const EmptyState(message: 'لا توجد أدوار بعد')
          : SimpleEntityGrid<AppRole>(
              items: items,
              idOf: (r) => r.id,
              columns: [
                SimpleEntityColumn('اسم الدور', (r) => r.roleName, width: 200),
                SimpleEntityColumn('الوصف', (r) => r.description, width: 220),
                SimpleEntityColumn(
                    'رئيسي', (r) => r.isSystem ? 'نعم' : 'لا',
                    width: 80),
                SimpleEntityColumn('عدد الصلاحيات',
                    (r) => '${r.permissionCodes.length}',
                    width: 110),
              ],
              onEdit: (r) => onEditPermissions(context, r),
              onDelete: (r) => onDelete(context, r),
            ),
    );
  }
}
