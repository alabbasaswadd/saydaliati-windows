// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damaged_goods_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(damagedGoodsRemoteDataSource)
final damagedGoodsRemoteDataSourceProvider =
    DamagedGoodsRemoteDataSourceProvider._();

final class DamagedGoodsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          DamagedGoodsRemoteDataSource,
          DamagedGoodsRemoteDataSource,
          DamagedGoodsRemoteDataSource
        >
    with $Provider<DamagedGoodsRemoteDataSource> {
  DamagedGoodsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'damagedGoodsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$damagedGoodsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DamagedGoodsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DamagedGoodsRemoteDataSource create(Ref ref) {
    return damagedGoodsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DamagedGoodsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DamagedGoodsRemoteDataSource>(value),
    );
  }
}

String _$damagedGoodsRemoteDataSourceHash() =>
    r'16b920fbf33625e9d8963bc46271b63c490c7aac';

@ProviderFor(damagedGoodsRepository)
final damagedGoodsRepositoryProvider = DamagedGoodsRepositoryProvider._();

final class DamagedGoodsRepositoryProvider
    extends
        $FunctionalProvider<
          DamagedGoodsRepository,
          DamagedGoodsRepository,
          DamagedGoodsRepository
        >
    with $Provider<DamagedGoodsRepository> {
  DamagedGoodsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'damagedGoodsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$damagedGoodsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DamagedGoodsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DamagedGoodsRepository create(Ref ref) {
    return damagedGoodsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DamagedGoodsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DamagedGoodsRepository>(value),
    );
  }
}

String _$damagedGoodsRepositoryHash() =>
    r'50e48f527d44d00dfac0919f5f0ec8769116db89';
