import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/roles/data/datasources/permission_remote_data_source.dart';
import 'package:saydaliati/features/roles/data/datasources/role_remote_data_source.dart';
import 'package:saydaliati/features/roles/data/repositories/permission_repository_impl.dart';
import 'package:saydaliati/features/roles/data/repositories/role_repository_impl.dart';
import 'package:saydaliati/features/roles/domain/entities/app_role.dart';
import 'package:saydaliati/features/roles/domain/entities/permission_item.dart';
import 'package:saydaliati/features/roles/domain/repositories/permission_repository.dart';
import 'package:saydaliati/features/roles/domain/repositories/role_repository.dart';

part 'roles_providers.g.dart';

/// Composition root for the roles/permissions feature — online-only, بلا
/// تخزين محلي (شاشة إدارة، لا بيانات تشغيلية يومية تحتاج عمل بلا اتصال).

@riverpod
RoleRemoteDataSource roleRemoteDataSource(Ref ref) =>
    RoleRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
RoleRepository roleRepository(Ref ref) =>
    RoleRepositoryImpl(ref.watch(roleRemoteDataSourceProvider));

@riverpod
Future<List<AppRole>> rolesList(Ref ref) async {
  final result = await ref.watch(roleRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}

@riverpod
PermissionRemoteDataSource permissionRemoteDataSource(Ref ref) =>
    PermissionRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
PermissionRepository permissionRepository(Ref ref) =>
    PermissionRepositoryImpl(ref.watch(permissionRemoteDataSourceProvider));

@riverpod
Future<List<PermissionItem>> permissionsCatalog(Ref ref) async {
  final result = await ref.watch(permissionRepositoryProvider).getAll();
  return result.fold((list) => list, (failure) => throw failure);
}
