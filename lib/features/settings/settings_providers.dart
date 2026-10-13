import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/constants/app_constants.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:saydaliati/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:saydaliati/features/settings/domain/repositories/settings_repository.dart';
import 'package:saydaliati/features/warehouses/data/datasources/warehouse_remote_data_source.dart';
import 'package:saydaliati/features/warehouses/domain/entities/warehouse.dart';

part 'settings_providers.g.dart';

/// Composition root for settings.

@riverpod
SettingsRemoteDataSource settingsRemoteDataSource(Ref ref) =>
    SettingsRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));

@riverpod
WarehouseRemoteDataSource warehouseRemoteDataSource(Ref ref) =>
    WarehouseRemoteDataSource(ref.watch(apiClientProvider));

/// The single (main) warehouse — id and name — resolved automatically from the
/// backend (`GET Warehouse/main`).
///
/// The pharmacy operates one warehouse, so there is no manual configuration.
/// The resolved id and name are cached locally so offline sales/stock keep
/// working; if the server is unreachable we fall back to the last-known values.
@riverpod
Future<Warehouse?> defaultWarehouse(Ref ref) async {
  final store = ref.watch(keyValueStoreProvider);
  try {
    final warehouse = await ref.watch(warehouseRemoteDataSourceProvider).main();
    if (warehouse != null && warehouse.id.isNotEmpty) {
      await store.write(AppConstants.defaultWarehouseKey, warehouse.id);
      await store.write(AppConstants.defaultWarehouseNameKey, warehouse.name);
      return warehouse;
    }
  } catch (_) {
    // Offline or server error — fall back to the last resolved values below.
  }
  final id = await store.read(AppConstants.defaultWarehouseKey);
  if (id == null || id.isEmpty) return null;
  final name = await store.read(AppConstants.defaultWarehouseNameKey) ?? '';
  return Warehouse(id: id, name: name);
}

/// The id of the single (main) warehouse — used when creating sales/purchases.
@riverpod
Future<String?> defaultWarehouseId(Ref ref) async =>
    (await ref.watch(defaultWarehouseProvider.future))?.id;

/// The pharmacy display name — a general setting stored server-side under
/// [AppConstants.pharmacyNameKey]. Null when it has not been set yet.
@riverpod
Future<String?> pharmacyName(Ref ref) async {
  final result = await ref
      .watch(settingsRepositoryProvider)
      .getValue(AppConstants.pharmacyNameKey);
  return result.fold((value) => value, (_) => null);
}

/// Whether selling into negative stock is allowed — a server-side setting under
/// [AppConstants.allowNegativeSaleKey]. Defaults to false when unset/unreachable.
@riverpod
Future<bool> allowNegativeSale(Ref ref) async {
  final result = await ref
      .watch(settingsRepositoryProvider)
      .getValue(AppConstants.allowNegativeSaleKey);
  return result.fold(
    (value) => value?.trim().toLowerCase() == 'true',
    (_) => false,
  );
}
