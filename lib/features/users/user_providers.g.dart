// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the staff-users feature — online-only (إدارة، لا
/// بيانات تشغيلية يومية).

@ProviderFor(userRemoteDataSource)
final userRemoteDataSourceProvider = UserRemoteDataSourceProvider._();

/// Composition root for the staff-users feature — online-only (إدارة، لا
/// بيانات تشغيلية يومية).

final class UserRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          UserRemoteDataSource,
          UserRemoteDataSource,
          UserRemoteDataSource
        >
    with $Provider<UserRemoteDataSource> {
  /// Composition root for the staff-users feature — online-only (إدارة، لا
  /// بيانات تشغيلية يومية).
  UserRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<UserRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserRemoteDataSource create(Ref ref) {
    return userRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRemoteDataSource>(value),
    );
  }
}

String _$userRemoteDataSourceHash() =>
    r'04e04710d6994848f9f41813a02b5c398b33cd26';

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'04b9e98de116edd11ab69f8ef5bc4b9ea44911d7';

@ProviderFor(staffUsers)
final staffUsersProvider = StaffUsersProvider._();

final class StaffUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StaffUser>>,
          List<StaffUser>,
          FutureOr<List<StaffUser>>
        >
    with $FutureModifier<List<StaffUser>>, $FutureProvider<List<StaffUser>> {
  StaffUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<StaffUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StaffUser>> create(Ref ref) {
    return staffUsers(ref);
  }
}

String _$staffUsersHash() => r'8d52899b6bed607d197b80a6822abf0f9266382b';
