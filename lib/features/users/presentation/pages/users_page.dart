import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/permissions/permission_codes.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/roles_providers.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';
import 'package:saydaliati/features/users/presentation/pages/staff_user_form_dialog.dart';
import 'package:saydaliati/features/users/user_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/permission_gate.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// إدارة مستخدمي الصيدلية — إضافة مستخدم (مساعد صيدلي أو أي دور آخر)، تغيير
/// دوره، وتفعيله/تعطيله. لا حذف فعلي للمستخدمين (الخادم لا يدعمه عمداً) —
/// زرّ الحذف في الغريد هنا اختصار **تعطيل سريع**، والتفعيل يعود من زرّ التعديل.
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
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

  Future<void> _edit(
      BuildContext context, WidgetRef ref, StaffUser user) async {
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

  Future<void> _quickDeactivate(
      BuildContext context, WidgetRef ref, StaffUser user) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // يُحمَّل مسبقاً حتى تكون قائمة الأدوار جاهزة في نموذج الإضافة/التعديل.
    ref.watch(rolesListProvider);
    final async = ref.watch(staffUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمون'),
        actions: [
          PermissionGate(
            permission: PermissionCodes.usersCreate,
            child: AddEntityButton(
              label: 'إضافة مستخدم',
              onPressed: () => _create(context, ref),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(staffUsersProvider)),
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
                  SimpleEntityColumn(
                      'الدور', (u) => u.roleName ?? '—',
                      width: 160),
                  SimpleEntityColumn(
                      'الحالة', (u) => u.isActive ? 'نشط' : 'معطّل',
                      width: 90),
                ],
                onEdit: (u) => _edit(context, ref, u),
                onDelete: (u) => _quickDeactivate(context, ref, u),
              ),
      ),
    );
  }
}
