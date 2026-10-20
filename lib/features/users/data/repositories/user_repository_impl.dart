import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/users/data/datasources/user_remote_data_source.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';
import 'package:saydaliati/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this.remote);

  final UserRemoteDataSource remote;

  @override
  Future<Result<List<StaffUser>>> getAll() async {
    try {
      final raw = await remote.list();
      return Result.success(raw.map(_fromJson).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<StaffUser>> createStaffUser({
    required String userName,
    String? email,
    required String phone,
    required String password,
    required String roleId,
  }) async {
    try {
      final raw = await remote.create({
        'userName': userName,
        'email': email,
        'phone': phone,
        'password': password,
        'roleId': roleId,
      });
      return Result.success(_fromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<StaffUser>> assignRole({
    required String userId,
    required String roleId,
  }) async {
    try {
      final raw = await remote.assignRole(userId, roleId);
      return Result.success(_fromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<StaffUser>> setActive({
    required String userId,
    required bool isActive,
  }) async {
    try {
      final raw = await remote.setActive(userId, isActive);
      return Result.success(_fromJson(raw));
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  StaffUser _fromJson(Map<String, dynamic> j) => StaffUser(
        id: (j['id'] ?? '').toString(),
        userName: (j['userName'] ?? '').toString(),
        email: (j['email'] ?? '').toString(),
        phone: (j['phone'] ?? '').toString(),
        isActive: j['isActive'] == true,
        roleId: j['roleId']?.toString(),
        roleName: j['roleName']?.toString(),
      );
}
