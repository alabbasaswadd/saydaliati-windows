import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';

abstract interface class UserRepository {
  Future<Result<List<StaffUser>>> getAll();

  Future<Result<StaffUser>> createStaffUser({
    required String userName,
    String? email,
    required String phone,
    required String password,
    required String roleId,
  });

  Future<Result<StaffUser>> assignRole({
    required String userId,
    required String roleId,
  });

  Future<Result<StaffUser>> setActive({
    required String userId,
    required bool isActive,
  });
}
