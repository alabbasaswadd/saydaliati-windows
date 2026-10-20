import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/users/data/datasources/user_remote_data_source.dart';
import 'package:saydaliati/features/users/data/repositories/user_repository_impl.dart';
import 'package:saydaliati/features/users/domain/entities/staff_user.dart';
import 'package:saydaliati/features/users/domain/repositories/user_repository.dart';

part 'user_providers.g.dart';

/// Composition root for the staff-users feature — online-only (إدارة، لا
/// بيانات تشغيلية يومية).

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) =>
    UserRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
UserRepository userRepository(Ref ref) =>
    UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));

@riverpod
Future<List<StaffUser>> staffUsers(Ref ref) async {
  final result = await ref.watch(userRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}
