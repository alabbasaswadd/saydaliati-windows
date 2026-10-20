// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the roles/permissions feature — online-only, بلا
/// تخزين محلي (شاشة إدارة، لا بيانات تشغيلية يومية تحتاج عمل بلا اتصال).

@ProviderFor(roleRemoteDataSource)
final roleRemoteDataSourceProvider = RoleRemoteDataSourceProvider._();

/// Composition root for the roles/permissions feature — online-only, بلا
/// تخزين محلي (شاشة إدارة، لا بيانات تشغيلية يومية تحتاج عمل بلا اتصال).

final class RoleRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          RoleRemoteDataSource,
          RoleRemoteDataSource,
          RoleRemoteDataSource
        >
    with $Provider<RoleRemoteDataSource> {
  /// Composition root for the roles/permissions feature — online-only, بلا
  /// تخزين محلي (شاشة إدارة، لا بيانات تشغيلية يومية تحتاج عمل بلا اتصال).
  RoleRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<RoleRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoleRemoteDataSource create(Ref ref) {
    return roleRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRemoteDataSource>(value),
    );
  }
}

String _$roleRemoteDataSourceHash() =>
    r'08edc07cb69810be8736a0ea965de9c92714d694';

@ProviderFor(roleRepository)
final roleRepositoryProvider = RoleRepositoryProvider._();

final class RoleRepositoryProvider
    extends $FunctionalProvider<RoleRepository, RoleRepository, RoleRepository>
    with $Provider<RoleRepository> {
  RoleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoleRepository create(Ref ref) {
    return roleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRepository>(value),
    );
  }
}

String _$roleRepositoryHash() => r'60736f0e67069d6e02c096c07bcc750f75f3c70a';

@ProviderFor(rolesList)
final rolesListProvider = RolesListProvider._();

final class RolesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppRole>>,
          List<AppRole>,
          FutureOr<List<AppRole>>
        >
    with $FutureModifier<List<AppRole>>, $FutureProvider<List<AppRole>> {
  RolesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rolesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rolesListHash();

  @$internal
  @override
  $FutureProviderElement<List<AppRole>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppRole>> create(Ref ref) {
    return rolesList(ref);
  }
}

String _$rolesListHash() => r'96033a9915361e54b19b7179644d112664f13e03';

@ProviderFor(permissionRemoteDataSource)
final permissionRemoteDataSourceProvider =
    PermissionRemoteDataSourceProvider._();

final class PermissionRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PermissionRemoteDataSource,
          PermissionRemoteDataSource,
          PermissionRemoteDataSource
        >
    with $Provider<PermissionRemoteDataSource> {
  PermissionRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PermissionRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionRemoteDataSource create(Ref ref) {
    return permissionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionRemoteDataSource>(value),
    );
  }
}

String _$permissionRemoteDataSourceHash() =>
    r'1e60a00285a90730befeb2caed554f4f11aa98c9';

@ProviderFor(permissionRepository)
final permissionRepositoryProvider = PermissionRepositoryProvider._();

final class PermissionRepositoryProvider
    extends
        $FunctionalProvider<
          PermissionRepository,
          PermissionRepository,
          PermissionRepository
        >
    with $Provider<PermissionRepository> {
  PermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<PermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionRepository create(Ref ref) {
    return permissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionRepository>(value),
    );
  }
}

String _$permissionRepositoryHash() =>
    r'2bafd5c49cabd6cc2d11e21a8ab65532687579e7';

@ProviderFor(permissionsCatalog)
final permissionsCatalogProvider = PermissionsCatalogProvider._();

final class PermissionsCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PermissionItem>>,
          List<PermissionItem>,
          FutureOr<List<PermissionItem>>
        >
    with
        $FutureModifier<List<PermissionItem>>,
        $FutureProvider<List<PermissionItem>> {
  PermissionsCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionsCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionsCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<PermissionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PermissionItem>> create(Ref ref) {
    return permissionsCatalog(ref);
  }
}

String _$permissionsCatalogHash() =>
    r'615c9bb096b2899d3b0f0dc2ed356659529b6194';
