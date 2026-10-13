// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unitRemoteDataSource)
final unitRemoteDataSourceProvider = UnitRemoteDataSourceProvider._();

final class UnitRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          UnitRemoteDataSource,
          UnitRemoteDataSource,
          UnitRemoteDataSource
        >
    with $Provider<UnitRemoteDataSource> {
  UnitRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<UnitRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UnitRemoteDataSource create(Ref ref) {
    return unitRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitRemoteDataSource>(value),
    );
  }
}

String _$unitRemoteDataSourceHash() =>
    r'd92ff6a6c7968f465f486f19f1152a1c11c776b9';

@ProviderFor(unitLocalDataSource)
final unitLocalDataSourceProvider = UnitLocalDataSourceProvider._();

final class UnitLocalDataSourceProvider
    extends
        $FunctionalProvider<
          UnitLocalDataSource,
          UnitLocalDataSource,
          UnitLocalDataSource
        >
    with $Provider<UnitLocalDataSource> {
  UnitLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<UnitLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UnitLocalDataSource create(Ref ref) {
    return unitLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitLocalDataSource>(value),
    );
  }
}

String _$unitLocalDataSourceHash() =>
    r'bc66cd0b28159e24dfededdbfc129c7dd252c805';

@ProviderFor(unitRepository)
final unitRepositoryProvider = UnitRepositoryProvider._();

final class UnitRepositoryProvider
    extends $FunctionalProvider<UnitRepository, UnitRepository, UnitRepository>
    with $Provider<UnitRepository> {
  UnitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitRepositoryHash();

  @$internal
  @override
  $ProviderElement<UnitRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnitRepository create(Ref ref) {
    return unitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitRepository>(value),
    );
  }
}

String _$unitRepositoryHash() => r'df0f27457ca95c74fcfee727d95ffbd9958b721f';

@ProviderFor(units)
final unitsProvider = UnitsProvider._();

final class UnitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Unit>>,
          List<Unit>,
          FutureOr<List<Unit>>
        >
    with $FutureModifier<List<Unit>>, $FutureProvider<List<Unit>> {
  UnitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitsHash();

  @$internal
  @override
  $FutureProviderElement<List<Unit>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Unit>> create(Ref ref) {
    return units(ref);
  }
}

String _$unitsHash() => r'16842ea7497d38ef81c8ef64602d99a5857725f3';
