import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/catalog/data/catalog_local_data_source.dart';
import 'package:saydaliati/features/catalog/data/catalog_remote_data_source.dart';
import 'package:saydaliati/features/catalog/data/catalog_sync_service.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';

part 'catalog_providers.g.dart';

@riverpod
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) =>
    CatalogRemoteDataSource(ref.watch(apiClientProvider));

/// On-device mirror of the global catalog (shared 'global' key).
@riverpod
CatalogLocalDataSource catalogLocalDataSource(Ref ref) =>
    CatalogLocalDataSource(db: ref.watch(appDatabaseProvider));

/// Throttled (6h) sync service that mirrors the catalog into the local DB.
@riverpod
CatalogSyncService catalogSyncService(Ref ref) => CatalogSyncService(
      ref.watch(catalogRemoteDataSourceProvider),
      ref.watch(catalogLocalDataSourceProvider),
    );

/// Whether the on-device global-catalog mirror is still empty (never downloaded
/// on this device). Drives the **one-time** first-load overlay: it is `true`
/// only before the very first catalog download, and `false` on every later
/// launch (the mirror persists on disk). Invalidated after a sync fills it.
@riverpod
Future<bool> catalogMirrorEmpty(Ref ref) async {
  final local = ref.watch(catalogLocalDataSourceProvider);
  return (await local.count()) == 0;
}

/// Search the catalog. **Offline-first**: if the local mirror is warm it serves
/// from the device (works with no network); otherwise it falls back to the API.
@riverpod
Future<List<CatalogItem>> catalogSearch(Ref ref, String query) async {
  final local = ref.watch(catalogLocalDataSourceProvider);
  if ((await local.count()) > 0) {
    return local.search(query);
  }
  return ref.watch(catalogRemoteDataSourceProvider).search(name: query, limit: 100);
}

/// Manufacturers (الشركات) with counts, for the "group by company" view.
/// **Offline-first**: served from the local mirror when warm, else the API.
@riverpod
Future<List<CatalogManufacturer>> catalogManufacturers(Ref ref) async {
  final local = ref.watch(catalogLocalDataSourceProvider);
  if ((await local.count()) > 0) {
    return local.manufacturers();
  }
  return ref.watch(catalogRemoteDataSourceProvider).manufacturers();
}

/// All catalog items for one manufacturer. **Offline-first**.
@riverpod
Future<List<CatalogItem>> catalogByManufacturer(
    Ref ref, String manufacturer) async {
  final local = ref.watch(catalogLocalDataSourceProvider);
  if ((await local.count()) > 0) {
    return local.byManufacturer(manufacturer);
  }
  return ref
      .watch(catalogRemoteDataSourceProvider)
      .search(manufacturer: manufacturer, limit: 1000);
}

/// Alternatives (same active ingredient) of a catalog item, from the catalog.
@riverpod
Future<List<CatalogItem>> catalogItemAlternatives(Ref ref, String id) =>
    ref.watch(catalogRemoteDataSourceProvider).alternatives(id);
