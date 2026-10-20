import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';

abstract interface class RoleRepository {
  Future<Result<List<AppRole>>> getAll();

  Future<Result<AppRole>> create({
    required String roleName,
    String? description,
  });

  /// يستبدل كل صلاحيات الدور بمجموعة [permissionIds] الجديدة دفعة واحدة.
  Future<Result<AppRole>> updatePermissions({
    required String roleId,
    required List<String> permissionIds,
  });

  Future<Result<bool>> delete(String roleId);
}
