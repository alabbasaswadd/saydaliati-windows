// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(voucherRemoteDataSource)
final voucherRemoteDataSourceProvider = VoucherRemoteDataSourceProvider._();

final class VoucherRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          VoucherRemoteDataSource,
          VoucherRemoteDataSource,
          VoucherRemoteDataSource
        >
    with $Provider<VoucherRemoteDataSource> {
  VoucherRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voucherRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voucherRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<VoucherRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VoucherRemoteDataSource create(Ref ref) {
    return voucherRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoucherRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoucherRemoteDataSource>(value),
    );
  }
}

String _$voucherRemoteDataSourceHash() =>
    r'f228928062568cf13eff6feb5a6f4aabb3d89938';

@ProviderFor(voucherRepository)
final voucherRepositoryProvider = VoucherRepositoryProvider._();

final class VoucherRepositoryProvider
    extends
        $FunctionalProvider<
          VoucherRepository,
          VoucherRepository,
          VoucherRepository
        >
    with $Provider<VoucherRepository> {
  VoucherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voucherRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voucherRepositoryHash();

  @$internal
  @override
  $ProviderElement<VoucherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VoucherRepository create(Ref ref) {
    return voucherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoucherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoucherRepository>(value),
    );
  }
}

String _$voucherRepositoryHash() => r'3bc506b7b48d0d1e6b846ad77364596d13f5711a';

@ProviderFor(vouchersList)
final vouchersListProvider = VouchersListProvider._();

final class VouchersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Voucher>>,
          List<Voucher>,
          FutureOr<List<Voucher>>
        >
    with $FutureModifier<List<Voucher>>, $FutureProvider<List<Voucher>> {
  VouchersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vouchersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vouchersListHash();

  @$internal
  @override
  $FutureProviderElement<List<Voucher>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Voucher>> create(Ref ref) {
    return vouchersList(ref);
  }
}

String _$vouchersListHash() => r'f15c81c3d5ab3643295c7e1509063a28636c2ecb';
