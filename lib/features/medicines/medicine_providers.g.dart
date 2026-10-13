// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the medicines feature.

@ProviderFor(medicineRemoteDataSource)
final medicineRemoteDataSourceProvider = MedicineRemoteDataSourceProvider._();

/// Composition root for the medicines feature.

final class MedicineRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          MedicineRemoteDataSource,
          MedicineRemoteDataSource,
          MedicineRemoteDataSource
        >
    with $Provider<MedicineRemoteDataSource> {
  /// Composition root for the medicines feature.
  MedicineRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<MedicineRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MedicineRemoteDataSource create(Ref ref) {
    return medicineRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicineRemoteDataSource>(value),
    );
  }
}

String _$medicineRemoteDataSourceHash() =>
    r'e1e34a507408bc84e0e771c9e2301a93bf1d0506';

@ProviderFor(medicineLocalDataSource)
final medicineLocalDataSourceProvider = MedicineLocalDataSourceProvider._();

final class MedicineLocalDataSourceProvider
    extends
        $FunctionalProvider<
          MedicineLocalDataSource,
          MedicineLocalDataSource,
          MedicineLocalDataSource
        >
    with $Provider<MedicineLocalDataSource> {
  MedicineLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<MedicineLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MedicineLocalDataSource create(Ref ref) {
    return medicineLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicineLocalDataSource>(value),
    );
  }
}

String _$medicineLocalDataSourceHash() =>
    r'a292571355aea54db28a015bbb13f6a4f51808f1';

@ProviderFor(medicineRepository)
final medicineRepositoryProvider = MedicineRepositoryProvider._();

final class MedicineRepositoryProvider
    extends
        $FunctionalProvider<
          MedicineRepository,
          MedicineRepository,
          MedicineRepository
        >
    with $Provider<MedicineRepository> {
  MedicineRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineRepositoryHash();

  @$internal
  @override
  $ProviderElement<MedicineRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MedicineRepository create(Ref ref) {
    return medicineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicineRepository>(value),
    );
  }
}

String _$medicineRepositoryHash() =>
    r'34f9a94e035495d64364486faa00f38dcef6edef';
