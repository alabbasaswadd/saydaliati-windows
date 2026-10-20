import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/data/datasources/role_remote_data_source.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';
import 'package:saydaliati/features/roles/domain/repositories/role_repository.dart';

class RoleRepositoryImpl implements RoleRepository {
  const RoleRepositoryImpl(this.remote);

  final RoleRemoteDataSource remote;

  @override
  Future<Result<List<AppRole>>> getAll() async {
    try {
      final raw = await remote.list();
      return Result.success(raw.map(_fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<AppRole>> create({
    required String roleName,
    String? description,
  }) async {
    try {
      final raw = await remote.create({
        'roleName': roleName,
        'description': description,
      });
      return Result.success(_fromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<AppRole>> updatePermissions({
    required String roleId,
    required List<String> permissionIds,
  }) async {
    try {
      final raw = await remote.updatePermissions(roleId, permissionIds);
      return Result.success(_fromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<bool>> delete(String roleId) async {
    try {
      await remote.delete(roleId);
      return const Result.success(true);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  AppRole _fromJson(Map<String, dynamic> j) => AppRole(
        id: (j['id'] ?? '').toString(),
        roleName: (j['roleName'] ?? '').toString(),
        description: (j['description'] ?? '').toString(),
        isSystem: j['isSystem'] == true,
        permissionCodes: ((j['permissionCodes'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(),
      );
}
