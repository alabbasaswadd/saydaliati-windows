// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manufacturer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(manufacturerRemoteDataSource)
final manufacturerRemoteDataSourceProvider =
    ManufacturerRemoteDataSourceProvider._();

final class ManufacturerRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ManufacturerRemoteDataSource,
          ManufacturerRemoteDataSource,
          ManufacturerRemoteDataSource
        >
    with $Provider<ManufacturerRemoteDataSource> {
  ManufacturerRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manufacturerRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manufacturerRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ManufacturerRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ManufacturerRemoteDataSource create(Ref ref) {
    return manufacturerRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManufacturerRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManufacturerRemoteDataSource>(value),
    );
  }
}

String _$manufacturerRemoteDataSourceHash() =>
    r'ae9f223788473f115e17cd67b6fdecd19a3bf245';

@ProviderFor(manufacturerLocalDataSource)
final manufacturerLocalDataSourceProvider =
    ManufacturerLocalDataSourceProvider._();

final class ManufacturerLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ManufacturerLocalDataSource,
          ManufacturerLocalDataSource,
          ManufacturerLocalDataSource
        >
    with $Provider<ManufacturerLocalDataSource> {
  ManufacturerLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manufacturerLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manufacturerLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ManufacturerLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ManufacturerLocalDataSource create(Ref ref) {
    return manufacturerLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManufacturerLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManufacturerLocalDataSource>(value),
    );
  }
}

String _$manufacturerLocalDataSourceHash() =>
    r'eec4f6c625a9d940cf8fe159748db36bb5fab12b';

@ProviderFor(manufacturerRepository)
final manufacturerRepositoryProvider = ManufacturerRepositoryProvider._();

final class ManufacturerRepositoryProvider
    extends
        $FunctionalProvider<
          ManufacturerRepository,
          ManufacturerRepository,
          ManufacturerRepository
        >
    with $Provider<ManufacturerRepository> {
  ManufacturerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manufacturerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manufacturerRepositoryHash();

  @$internal
  @override
  $ProviderElement<ManufacturerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ManufacturerRepository create(Ref ref) {
    return manufacturerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManufacturerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManufacturerRepository>(value),
    );
  }
}

String _$manufacturerRepositoryHash() =>
    r'ed0aee33fc06a007b60264e66bc665c897b67fab';

@ProviderFor(manufacturers)
final manufacturersProvider = ManufacturersProvider._();

final class ManufacturersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manufacturer>>,
          List<Manufacturer>,
          FutureOr<List<Manufacturer>>
        >
    with
        $FutureModifier<List<Manufacturer>>,
        $FutureProvider<List<Manufacturer>> {
  ManufacturersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manufacturersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manufacturersHash();

  @$internal
  @override
  $FutureProviderElement<List<Manufacturer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Manufacturer>> create(Ref ref) {
    return manufacturers(ref);
  }
}

String _$manufacturersHash() => r'add88899e5b3b164385de564a7349fac423c94db';
