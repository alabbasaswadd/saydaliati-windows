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

/// تسوية جرد دفعة — مباشر بلا تخزين مؤقّت: رقم الجرد قرارٌ يُسجَّل فوراً لا
/// يُقرأ من كاش (نفس أسلوب `settleDebt`).

@ProviderFor(adjustStock)
final adjustStockProvider = AdjustStockProvider._();

/// تسوية جرد دفعة — مباشر بلا تخزين مؤقّت: رقم الجرد قرارٌ يُسجَّل فوراً لا
/// يُقرأ من كاش (نفس أسلوب `settleDebt`).

final class AdjustStockProvider
    extends
        $FunctionalProvider<
          Future<AdjustStockResult> Function(AdjustStockInput),
          Future<AdjustStockResult> Function(AdjustStockInput),
          Future<AdjustStockResult> Function(AdjustStockInput)
        >
    with $Provider<Future<AdjustStockResult> Function(AdjustStockInput)> {
  /// تسوية جرد دفعة — مباشر بلا تخزين مؤقّت: رقم الجرد قرارٌ يُسجَّل فوراً لا
  /// يُقرأ من كاش (نفس أسلوب `settleDebt`).
  AdjustStockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adjustStockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adjustStockHash();

  @$internal
  @override
  $ProviderElement<Future<AdjustStockResult> Function(AdjustStockInput)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<AdjustStockResult> Function(AdjustStockInput) create(Ref ref) {
    return adjustStock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<AdjustStockResult> Function(AdjustStockInput) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<AdjustStockResult> Function(AdjustStockInput)
          >(value),
    );
  }
}

String _$adjustStockHash() => r'609a059c0d7b2712ada0e0ae869337e19d4bbab5';
