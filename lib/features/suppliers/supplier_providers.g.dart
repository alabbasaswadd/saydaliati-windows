// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supplierRemoteDataSource)
final supplierRemoteDataSourceProvider = SupplierRemoteDataSourceProvider._();

final class SupplierRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SupplierRemoteDataSource,
          SupplierRemoteDataSource,
          SupplierRemoteDataSource
        >
    with $Provider<SupplierRemoteDataSource> {
  SupplierRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supplierRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supplierRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SupplierRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupplierRemoteDataSource create(Ref ref) {
    return supplierRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupplierRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupplierRemoteDataSource>(value),
    );
  }
}

String _$supplierRemoteDataSourceHash() =>
    r'21677aadb37f655eece166a46f385b7adeefbcbd';

@ProviderFor(supplierRepository)
final supplierRepositoryProvider = SupplierRepositoryProvider._();

final class SupplierRepositoryProvider
    extends
        $FunctionalProvider<
          SupplierRepository,
          SupplierRepository,
          SupplierRepository
        >
    with $Provider<SupplierRepository> {
  SupplierRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supplierRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supplierRepositoryHash();

  @$internal
  @override
  $ProviderElement<SupplierRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupplierRepository create(Ref ref) {
    return supplierRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupplierRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupplierRepository>(value),
    );
  }
}

String _$supplierRepositoryHash() =>
    r'b5ef23762c1641c07b1395ca84aa85e609c681b3';

@ProviderFor(suppliers)
final suppliersProvider = SuppliersProvider._();

final class SuppliersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Supplier>>,
          List<Supplier>,
          FutureOr<List<Supplier>>
        >
    with $FutureModifier<List<Supplier>>, $FutureProvider<List<Supplier>> {
  SuppliersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suppliersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suppliersHash();

  @$internal
  @override
  $FutureProviderElement<List<Supplier>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Supplier>> create(Ref ref) {
    return suppliers(ref);
  }
}

String _$suppliersHash() => r'adbcc5d8c6dd61f88aac9c2367eda56b3aa6e378';
