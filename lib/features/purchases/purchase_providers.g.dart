// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(purchaseRemoteDataSource)
final purchaseRemoteDataSourceProvider = PurchaseRemoteDataSourceProvider._();

final class PurchaseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PurchaseRemoteDataSource,
          PurchaseRemoteDataSource,
          PurchaseRemoteDataSource
        >
    with $Provider<PurchaseRemoteDataSource> {
  PurchaseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PurchaseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseRemoteDataSource create(Ref ref) {
    return purchaseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseRemoteDataSource>(value),
    );
  }
}

String _$purchaseRemoteDataSourceHash() =>
    r'68f31441042ca599a03858cd4a854f10858ae6df';

@ProviderFor(purchaseRepository)
final purchaseRepositoryProvider = PurchaseRepositoryProvider._();

final class PurchaseRepositoryProvider
    extends
        $FunctionalProvider<
          PurchaseRepository,
          PurchaseRepository,
          PurchaseRepository
        >
    with $Provider<PurchaseRepository> {
  PurchaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseRepositoryHash();

  @$internal
  @override
  $ProviderElement<PurchaseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PurchaseRepository create(Ref ref) {
    return purchaseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseRepository>(value),
    );
  }
}

String _$purchaseRepositoryHash() =>
    r'b5c8c7e1b348ca96ab141da1eac9fcc1ff9e7dae';

@ProviderFor(purchasesList)
final purchasesListProvider = PurchasesListProvider._();

final class PurchasesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Purchase>>,
          List<Purchase>,
          FutureOr<List<Purchase>>
        >
    with $FutureModifier<List<Purchase>>, $FutureProvider<List<Purchase>> {
  PurchasesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchasesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchasesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Purchase>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Purchase>> create(Ref ref) {
    return purchasesList(ref);
  }
}

String _$purchasesListHash() => r'9eeeef18da03180a6936bb2b416260dee86e7096';
