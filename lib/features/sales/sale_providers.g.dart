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

@ProviderFor(saleReturnRemoteDataSource)
final saleReturnRemoteDataSourceProvider =
    SaleReturnRemoteDataSourceProvider._();

final class SaleReturnRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SaleReturnRemoteDataSource,
          SaleReturnRemoteDataSource,
          SaleReturnRemoteDataSource
        >
    with $Provider<SaleReturnRemoteDataSource> {
  SaleReturnRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleReturnRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleReturnRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SaleReturnRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaleReturnRemoteDataSource create(Ref ref) {
    return saleReturnRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleReturnRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleReturnRemoteDataSource>(value),
    );
  }
}

String _$saleReturnRemoteDataSourceHash() =>
    r'367c597041f7d93117654a920ab41b51c6150431';

/// Sale returns — online-only (see SaleReturnRepository doc).

@ProviderFor(saleReturnRepository)
final saleReturnRepositoryProvider = SaleReturnRepositoryProvider._();

/// Sale returns — online-only (see SaleReturnRepository doc).

final class SaleReturnRepositoryProvider
    extends
        $FunctionalProvider<
          SaleReturnRepository,
          SaleReturnRepository,
          SaleReturnRepository
        >
    with $Provider<SaleReturnRepository> {
  /// Sale returns — online-only (see SaleReturnRepository doc).
  SaleReturnRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleReturnRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleReturnRepositoryHash();

  @$internal
  @override
  $ProviderElement<SaleReturnRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaleReturnRepository create(Ref ref) {
    return saleReturnRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleReturnRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleReturnRepository>(value),
    );
  }
}

String _$saleReturnRepositoryHash() =>
    r'91b2ac0eec5315f7eebe7d7205ba365a5ec3c43b';

@ProviderFor(saleReturnableLines)
final saleReturnableLinesProvider = SaleReturnableLinesFamily._();

final class SaleReturnableLinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SaleReturnableLine>>,
          List<SaleReturnableLine>,
          FutureOr<List<SaleReturnableLine>>
        >
    with
        $FutureModifier<List<SaleReturnableLine>>,
        $FutureProvider<List<SaleReturnableLine>> {
  SaleReturnableLinesProvider._({
    required SaleReturnableLinesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'saleReturnableLinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saleReturnableLinesHash();

  @override
  String toString() {
    return r'saleReturnableLinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SaleReturnableLine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SaleReturnableLine>> create(Ref ref) {
    final argument = this.argument as String;
    return saleReturnableLines(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleReturnableLinesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saleReturnableLinesHash() =>
    r'498804b363b9ba3a5fe01ca85a7e21d7aeaa972b';

final class SaleReturnableLinesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SaleReturnableLine>>, String> {
  SaleReturnableLinesFamily._()
    : super(
        retry: null,
        name: r'saleReturnableLinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SaleReturnableLinesProvider call(String saleId) =>
      SaleReturnableLinesProvider._(argument: saleId, from: this);

  @override
  String toString() => r'saleReturnableLinesProvider';
}

/// Saved sale return documents — drives the «مرتجع مبيعات» sidebar section.

@ProviderFor(saleReturnsList)
final saleReturnsListProvider = SaleReturnsListProvider._();

/// Saved sale return documents — drives the «مرتجع مبيعات» sidebar section.

final class SaleReturnsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SaleReturnSummary>>,
          List<SaleReturnSummary>,
          FutureOr<List<SaleReturnSummary>>
        >
    with
        $FutureModifier<List<SaleReturnSummary>>,
        $FutureProvider<List<SaleReturnSummary>> {
  /// Saved sale return documents — drives the «مرتجع مبيعات» sidebar section.
  SaleReturnsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleReturnsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleReturnsListHash();

  @$internal
  @override
  $FutureProviderElement<List<SaleReturnSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SaleReturnSummary>> create(Ref ref) {
    return saleReturnsList(ref);
  }
}

String _$saleReturnsListHash() => r'bdbd4b8fa469a32e7b7a7a83b96519ce433479d2';

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
