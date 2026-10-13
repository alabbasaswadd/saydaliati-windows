// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Composition root for settings.

@ProviderFor(settingsRemoteDataSource)
final settingsRemoteDataSourceProvider = SettingsRemoteDataSourceProvider._();

/// Composition root for settings.

final class SettingsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SettingsRemoteDataSource,
          SettingsRemoteDataSource,
          SettingsRemoteDataSource
        >
    with $Provider<SettingsRemoteDataSource> {
  /// Composition root for settings.
  SettingsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SettingsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRemoteDataSource create(Ref ref) {
    return settingsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRemoteDataSource>(value),
    );
  }
}

String _$settingsRemoteDataSourceHash() =>
    r'5bf95868f1d9efe2a571971e4b0f8b4f086f93d5';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'e0b93fbd2cc78250a2bc59e4480af3a0128c0b97';

@ProviderFor(warehouseRemoteDataSource)
final warehouseRemoteDataSourceProvider = WarehouseRemoteDataSourceProvider._();

final class WarehouseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          WarehouseRemoteDataSource,
          WarehouseRemoteDataSource,
          WarehouseRemoteDataSource
        >
    with $Provider<WarehouseRemoteDataSource> {
  WarehouseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warehouseRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warehouseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<WarehouseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WarehouseRemoteDataSource create(Ref ref) {
    return warehouseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WarehouseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WarehouseRemoteDataSource>(value),
    );
  }
}

String _$warehouseRemoteDataSourceHash() =>
    r'4e5eaecc4be72af74a1cf9e81cb397c939d7bb69';

/// The single (main) warehouse — id and name — resolved automatically from the
/// backend (`GET Warehouse/main`).
///
/// The pharmacy operates one warehouse, so there is no manual configuration.
/// The resolved id and name are cached locally so offline sales/stock keep
/// working; if the server is unreachable we fall back to the last-known values.

@ProviderFor(defaultWarehouse)
final defaultWarehouseProvider = DefaultWarehouseProvider._();

/// The single (main) warehouse — id and name — resolved automatically from the
/// backend (`GET Warehouse/main`).
///
/// The pharmacy operates one warehouse, so there is no manual configuration.
/// The resolved id and name are cached locally so offline sales/stock keep
/// working; if the server is unreachable we fall back to the last-known values.

final class DefaultWarehouseProvider
    extends
        $FunctionalProvider<
          AsyncValue<Warehouse?>,
          Warehouse?,
          FutureOr<Warehouse?>
        >
    with $FutureModifier<Warehouse?>, $FutureProvider<Warehouse?> {
  /// The single (main) warehouse — id and name — resolved automatically from the
  /// backend (`GET Warehouse/main`).
  ///
  /// The pharmacy operates one warehouse, so there is no manual configuration.
  /// The resolved id and name are cached locally so offline sales/stock keep
  /// working; if the server is unreachable we fall back to the last-known values.
  DefaultWarehouseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultWarehouseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultWarehouseHash();

  @$internal
  @override
  $FutureProviderElement<Warehouse?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Warehouse?> create(Ref ref) {
    return defaultWarehouse(ref);
  }
}

String _$defaultWarehouseHash() => r'103a2c91a841b0defa8b19e259e666e54c3dc97d';

/// The id of the single (main) warehouse — used when creating sales/purchases.

@ProviderFor(defaultWarehouseId)
final defaultWarehouseIdProvider = DefaultWarehouseIdProvider._();

/// The id of the single (main) warehouse — used when creating sales/purchases.

final class DefaultWarehouseIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The id of the single (main) warehouse — used when creating sales/purchases.
  DefaultWarehouseIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultWarehouseIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultWarehouseIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return defaultWarehouseId(ref);
  }
}

String _$defaultWarehouseIdHash() =>
    r'0c75016dd76fed788d2ebdf9ce1df355dff3566f';

/// The pharmacy display name — a general setting stored server-side under
/// [AppConstants.pharmacyNameKey]. Null when it has not been set yet.

@ProviderFor(pharmacyName)
final pharmacyNameProvider = PharmacyNameProvider._();

/// The pharmacy display name — a general setting stored server-side under
/// [AppConstants.pharmacyNameKey]. Null when it has not been set yet.

final class PharmacyNameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The pharmacy display name — a general setting stored server-side under
  /// [AppConstants.pharmacyNameKey]. Null when it has not been set yet.
  PharmacyNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pharmacyNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pharmacyNameHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return pharmacyName(ref);
  }
}

String _$pharmacyNameHash() => r'b369561835db37dca6fad57dc0f7e8ac6be18d7d';

/// Whether selling into negative stock is allowed — a server-side setting under
/// [AppConstants.allowNegativeSaleKey]. Defaults to false when unset/unreachable.

@ProviderFor(allowNegativeSale)
final allowNegativeSaleProvider = AllowNegativeSaleProvider._();

/// Whether selling into negative stock is allowed — a server-side setting under
/// [AppConstants.allowNegativeSaleKey]. Defaults to false when unset/unreachable.

final class AllowNegativeSaleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether selling into negative stock is allowed — a server-side setting under
  /// [AppConstants.allowNegativeSaleKey]. Defaults to false when unset/unreachable.
  AllowNegativeSaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allowNegativeSaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allowNegativeSaleHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return allowNegativeSale(ref);
  }
}

String _$allowNegativeSaleHash() => r'03e35467e69e0b9eff67b16a057e0ab751c322ad';
