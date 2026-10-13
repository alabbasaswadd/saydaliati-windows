// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the sales feature. The repository is wired with the
/// outbox + connectivity so `createSale` is offline-capable (queues + decrements
/// the local stock cache offline).

@ProviderFor(saleRemoteDataSource)
final saleRemoteDataSourceProvider = SaleRemoteDataSourceProvider._();

/// Composition root for the sales feature. The repository is wired with the
/// outbox + connectivity so `createSale` is offline-capable (queues + decrements
/// the local stock cache offline).

final class SaleRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SaleRemoteDataSource,
          SaleRemoteDataSource,
          SaleRemoteDataSource
        >
    with $Provider<SaleRemoteDataSource> {
  /// Composition root for the sales feature. The repository is wired with the
  /// outbox + connectivity so `createSale` is offline-capable (queues + decrements
  /// the local stock cache offline).
  SaleRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SaleRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaleRemoteDataSource create(Ref ref) {
    return saleRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleRemoteDataSource>(value),
    );
  }
}

String _$saleRemoteDataSourceHash() =>
    r'460d1e4432aba6aef9fe2f2940ba8702163b6d6e';

@ProviderFor(batchRemoteDataSource)
final batchRemoteDataSourceProvider = BatchRemoteDataSourceProvider._();

final class BatchRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BatchRemoteDataSource,
          BatchRemoteDataSource,
          BatchRemoteDataSource
        >
    with $Provider<BatchRemoteDataSource> {
  BatchRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batchRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BatchRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BatchRemoteDataSource create(Ref ref) {
    return batchRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatchRemoteDataSource>(value),
    );
  }
}

String _$batchRemoteDataSourceHash() =>
    r'c0ff2f7e992a45eaf370e7baf28196ca2834965c';

/// Offline-aware batch loader for the POS: online fetch + write-through to the
/// stock cache; offline reads the cached batches.

@ProviderFor(batchRepository)
final batchRepositoryProvider = BatchRepositoryProvider._();

/// Offline-aware batch loader for the POS: online fetch + write-through to the
/// stock cache; offline reads the cached batches.

final class BatchRepositoryProvider
    extends
        $FunctionalProvider<BatchRepository, BatchRepository, BatchRepository>
    with $Provider<BatchRepository> {
  /// Offline-aware batch loader for the POS: online fetch + write-through to the
  /// stock cache; offline reads the cached batches.
  BatchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batchRepositoryHash();

  @$internal
  @override
  $ProviderElement<BatchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BatchRepository create(Ref ref) {
    return batchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatchRepository>(value),
    );
  }
}

String _$batchRepositoryHash() => r'25011c4094e5ecb88a2e52c3cb064ba2e3c7dc6d';

@ProviderFor(saleRepository)
final saleRepositoryProvider = SaleRepositoryProvider._();

final class SaleRepositoryProvider
    extends $FunctionalProvider<SaleRepository, SaleRepository, SaleRepository>
    with $Provider<SaleRepository> {
  SaleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleRepositoryHash();

  @$internal
  @override
  $ProviderElement<SaleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaleRepository create(Ref ref) {
    return saleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleRepository>(value),
    );
  }
}

String _$saleRepositoryHash() => r'bbfd2206bccd33dbd88bd24f3f6453232c3f2e23';

/// The still-queued (un-synced) sales for the current tenant — reactive, oldest
/// first — driving the POS "unsynced invoices" (cloud) screen.

@ProviderFor(pendingSales)
final pendingSalesProvider = PendingSalesProvider._();

/// The still-queued (un-synced) sales for the current tenant — reactive, oldest
/// first — driving the POS "unsynced invoices" (cloud) screen.

final class PendingSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PendingSale>>,
          List<PendingSale>,
          Stream<List<PendingSale>>
        >
    with
        $FutureModifier<List<PendingSale>>,
        $StreamProvider<List<PendingSale>> {
  /// The still-queued (un-synced) sales for the current tenant — reactive, oldest
  /// first — driving the POS "unsynced invoices" (cloud) screen.
  PendingSalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSalesHash();

  @$internal
  @override
  $StreamProviderElement<List<PendingSale>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PendingSale>> create(Ref ref) {
    return pendingSales(ref);
  }
}

String _$pendingSalesHash() => r'072eccb29116976ddd4b0165ee490be8ef0f4fec';
