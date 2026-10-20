import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/roles/data/datasources/permission_remote_data_source.dart';
import 'package:saydaliati/features/roles/domain/entities/permission_item.dart';
import 'package:saydaliati/features/roles/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  const PermissionRepositoryImpl(this.remote);

  final PermissionRemoteDataSource remote;

  @override
  Future<Result<List<PermissionItem>>> getAll() async {
    try {
      final raw = await remote.list();
      return Result.success(raw
          .map((j) => PermissionItem(
                id: (j['id'] ?? '').toString(),
                code: (j['code'] ?? '').toString(),
                module: (j['module'] ?? '').toString(),
                descriptionAr: (j['descriptionAr'] ?? '').toString(),
              ))
          .toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
