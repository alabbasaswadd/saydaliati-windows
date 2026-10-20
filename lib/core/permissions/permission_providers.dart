import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/permissions/current_user_permissions.dart';
import 'package:saydaliati/features/auth/auth_providers.dart';

part 'permission_providers.g.dart';

/// صلاحيات المستخدم الحالي — مُشتقّة من [currentUserProvider] (`/auth/me`)،
/// لا مصدرها الخاص. تتبع دورة حياة [currentUserProvider] تماماً: تُعاد
/// حسابها كل مرة يُعاد جلب أو إبطال ذلك المزوّد (تسجيل دخول جديد، تسجيل
/// خروج، أو استجابة 403 تستدعي تحديثاً — راجع [AuthInterceptor]).
@riverpod
CurrentUserPermissions currentUserPermissions(Ref ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return CurrentUserPermissions.empty;
  return CurrentUserPermissions.fromMe(me);
}

/// قراءة مباشرة من واجهات `Widget`: `ref.hasPermission('roles.manage')`.
extension CurrentUserPermissionsX on WidgetRef {
  bool hasPermission(String code) =>
      watch(currentUserPermissionsProvider).has(code);
}
