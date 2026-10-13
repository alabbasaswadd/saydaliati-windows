// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockRemoteDataSource)
final stockRemoteDataSourceProvider = StockRemoteDataSourceProvider._();

final class StockRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StockRemoteDataSource,
          StockRemoteDataSource,
          StockRemoteDataSource
        >
    with $Provider<StockRemoteDataSource> {
  StockRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StockRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StockRemoteDataSource create(Ref ref) {
    return stockRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockRemoteDataSource>(value),
    );
  }
}

String _$stockRemoteDataSourceHash() =>
    r'8977ba410a3d7903d496aee6580122eb07e530ca';

@ProviderFor(stockLocalDataSource)
final stockLocalDataSourceProvider = StockLocalDataSourceProvider._();

final class StockLocalDataSourceProvider
    extends
        $FunctionalProvider<
          StockLocalDataSource,
          StockLocalDataSource,
          StockLocalDataSource
        >
    with $Provider<StockLocalDataSource> {
  StockLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<StockLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StockLocalDataSource create(Ref ref) {
    return stockLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockLocalDataSource>(value),
    );
  }
}

String _$stockLocalDataSourceHash() =>
    r'85fef516d698729bf5811276f126187c75617e7d';

@ProviderFor(stockRepository)
final stockRepositoryProvider = StockRepositoryProvider._();

final class StockRepositoryProvider
    extends
        $FunctionalProvider<StockRepository, StockRepository, StockRepository>
    with $Provider<StockRepository> {
  StockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockRepositoryHash();

  @$internal
  @override
  $ProviderElement<StockRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StockRepository create(Ref ref) {
    return stockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockRepository>(value),
    );
  }
}

String _$stockRepositoryHash() => r'70d07a9569b42be6d7ca82a27e98f866041b4595';

@ProviderFor(stockList)
final stockListProvider = StockListProvider._();

final class StockListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stock>>,
          List<Stock>,
          FutureOr<List<Stock>>
        >
    with $FutureModifier<List<Stock>>, $FutureProvider<List<Stock>> {
  StockListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockListHash();

  @$internal
  @override
  $FutureProviderElement<List<Stock>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Stock>> create(Ref ref) {
    return stockList(ref);
  }
}

String _$stockListHash() => r'fdb48e4c4c89d4577d0cddf022da014704352513';
