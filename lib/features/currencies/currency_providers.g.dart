// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for the currencies feature.

@ProviderFor(currencyRemoteDataSource)
final currencyRemoteDataSourceProvider = CurrencyRemoteDataSourceProvider._();

/// Composition root for the currencies feature.

final class CurrencyRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CurrencyRemoteDataSource,
          CurrencyRemoteDataSource,
          CurrencyRemoteDataSource
        >
    with $Provider<CurrencyRemoteDataSource> {
  /// Composition root for the currencies feature.
  CurrencyRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CurrencyRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CurrencyRemoteDataSource create(Ref ref) {
    return currencyRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyRemoteDataSource>(value),
    );
  }
}

String _$currencyRemoteDataSourceHash() =>
    r'26831ccd8fd960380ef6682ed16a26752bc4321c';

@ProviderFor(currencyLocalDataSource)
final currencyLocalDataSourceProvider = CurrencyLocalDataSourceProvider._();

final class CurrencyLocalDataSourceProvider
    extends
        $FunctionalProvider<
          CurrencyLocalDataSource,
          CurrencyLocalDataSource,
          CurrencyLocalDataSource
        >
    with $Provider<CurrencyLocalDataSource> {
  CurrencyLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CurrencyLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CurrencyLocalDataSource create(Ref ref) {
    return currencyLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyLocalDataSource>(value),
    );
  }
}

String _$currencyLocalDataSourceHash() =>
    r'c5fb80bbdd0c9a94161fd35d62e38dfc6ea7fe0b';

@ProviderFor(currencyRepository)
final currencyRepositoryProvider = CurrencyRepositoryProvider._();

final class CurrencyRepositoryProvider
    extends
        $FunctionalProvider<
          CurrencyRepository,
          CurrencyRepository,
          CurrencyRepository
        >
    with $Provider<CurrencyRepository> {
  CurrencyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyRepositoryHash();

  @$internal
  @override
  $ProviderElement<CurrencyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CurrencyRepository create(Ref ref) {
    return currencyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyRepository>(value),
    );
  }
}

String _$currencyRepositoryHash() =>
    r'48607930132171924e54ed5011d9c40e6b8fd9cf';
