// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockMovementRemoteDataSource)
final stockMovementRemoteDataSourceProvider =
    StockMovementRemoteDataSourceProvider._();

final class StockMovementRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StockMovementRemoteDataSource,
          StockMovementRemoteDataSource,
          StockMovementRemoteDataSource
        >
    with $Provider<StockMovementRemoteDataSource> {
  StockMovementRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockMovementRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockMovementRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StockMovementRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StockMovementRemoteDataSource create(Ref ref) {
    return stockMovementRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockMovementRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockMovementRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$stockMovementRemoteDataSourceHash() =>
    r'995dfd4dfda14928c3b83596a4468900fd0dc074';

@ProviderFor(stockMovementRepository)
final stockMovementRepositoryProvider = StockMovementRepositoryProvider._();

final class StockMovementRepositoryProvider
    extends
        $FunctionalProvider<
          StockMovementRepository,
          StockMovementRepository,
          StockMovementRepository
        >
    with $Provider<StockMovementRepository> {
  StockMovementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockMovementRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockMovementRepositoryHash();

  @$internal
  @override
  $ProviderElement<StockMovementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StockMovementRepository create(Ref ref) {
    return stockMovementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockMovementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockMovementRepository>(value),
    );
  }
}

String _$stockMovementRepositoryHash() =>
    r'69db2adefdad026dc3bb10a6e3093966ef7fd130';

@ProviderFor(stockMovements)
final stockMovementsProvider = StockMovementsFamily._();

final class StockMovementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StockMovement>>,
          List<StockMovement>,
          FutureOr<List<StockMovement>>
        >
    with
        $FutureModifier<List<StockMovement>>,
        $FutureProvider<List<StockMovement>> {
  StockMovementsProvider._({
    required StockMovementsFamily super.from,
    required (String?, String?, String?, String?) super.argument,
  }) : super(
         retry: null,
         name: r'stockMovementsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockMovementsHash();

  @override
  String toString() {
    return r'stockMovementsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<StockMovement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StockMovement>> create(Ref ref) {
    final argument = this.argument as (String?, String?, String?, String?);
    return stockMovements(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StockMovementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockMovementsHash() => r'f3c6252b280f8e47f9751381485f5278198c3f32';

final class StockMovementsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<StockMovement>>,
          (String?, String?, String?, String?)
        > {
  StockMovementsFamily._()
    : super(
        retry: null,
        name: r'stockMovementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StockMovementsProvider call(
    String? medicineId,
    String? categoryId, [
    String? fromIso,
    String? toIso,
  ]) => StockMovementsProvider._(
    argument: (medicineId, categoryId, fromIso, toIso),
    from: this,
  );

  @override
  String toString() => r'stockMovementsProvider';
}
