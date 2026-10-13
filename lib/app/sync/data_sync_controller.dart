import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/categories/category_providers.dart';
import 'package:saydaliati/features/currencies/currency_providers.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/medicine_units/unit_providers.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/stock/stock_providers.dart';

part 'data_sync_controller.g.dart';

/// Progress of a full data sync (push queued writes, then pull catalogs).
class SyncProgress {
  const SyncProgress({
    this.running = false,
    this.step,
    this.lastSyncedAt,
    this.offline = false,
  });

  /// A sync is in progress.
  final bool running;

  /// Human label of the current step (e.g. "الأدوية"), for the UI.
  final String? step;

  /// When the last successful sync finished.
  final DateTime? lastSyncedAt;

  /// The last attempt was skipped because the app is offline.
  final bool offline;

  SyncProgress copyWith({
    bool? running,
    String? step,
    DateTime? lastSyncedAt,
    bool? offline,
  }) =>
      SyncProgress(
        running: running ?? this.running,
        step: step ?? this.step,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        offline: offline ?? this.offline,
      );
}

/// The single orchestrator for keeping the local cache in sync with the server.
///
/// [syncAll] FIRST pushes queued writes (e.g. offline sales) so the server
/// applies them, THEN re-pulls the catalogs (currencies, medicines + prices,
/// customers, stock quantities, categories, units) into the local cache — so the
/// cache is corrected from the server right after invoices are posted.
///
/// Runs automatically at startup and whenever connectivity (or the manual work
/// mode) returns to online, and can be triggered manually from Settings.
@Riverpod(keepAlive: true)
class DataSyncController extends _$DataSyncController {
  @override
  SyncProgress build() {
    // A full data pull is EXPENSIVE (medicines + stock + the whole catalog), so
    // it must NOT run on every app open or on every reconnect. It runs ONLY:
    //   1) right after an actual login — the auth flow calls syncAll() after
    //      establish() succeeds (NOT on session-restore at cold start), and
    //   2) on manual refresh from Settings.
    // On a normal launch the app reads instantly from the warm local cache.
    return const SyncProgress();
  }

  Future<void> syncAll() async {
    if (state.running) return;
    // Only sync when signed in — the catalogs are authed endpoints, and running
    // them anonymously (before login) just produces 401s.
    if (ref.read(currentTenantKeyProvider) == 'default') return;
    if (!ref.read(effectiveOnlineProvider)) {
      state = state.copyWith(running: false, offline: true);
      return;
    }
    state = const SyncProgress(running: true);

    // 1) Push queued writes first (offline sales) so the server applies them
    //    before we re-pull authoritative data over the local cache.
    await ref.read(syncControllerProvider.notifier).pushNow();

    // 2) Pull each catalog into its local cache. Individual failures don't abort
    //    the whole sync — the others still refresh.
    final tasks = <MapEntry<String, Future<void> Function()>>[
      // Warm the main warehouse into local storage FIRST, so offline opens
      // right after login never falsely show "set the warehouse" (it's always
      // set server-side; it just wasn't cached until the first fetch).
      MapEntry('المستودع', () async {
        ref.invalidate(defaultWarehouseProvider);
        await ref.read(defaultWarehouseProvider.future);
      }),
      MapEntry(AppStrings.syncCurrencies, () async {
        final raw = await ref.read(currencyRemoteDataSourceProvider).list();
        await ref.read(currencyLocalDataSourceProvider).replaceAll(raw);
      }),
      MapEntry(AppStrings.syncMedicines, () async {
        final raw = await ref.read(medicineRemoteDataSourceProvider).list();
        await ref.read(medicineLocalDataSourceProvider).replaceAll(raw);
      }),
      MapEntry(AppStrings.syncCustomers, () async {
        final raw = await ref.read(customerRemoteDataSourceProvider).list();
        await ref.read(customerLocalDataSourceProvider).replaceAll(raw);
      }),
      MapEntry(AppStrings.syncStock, () async {
        final raw =
            await ref.read(stockRemoteDataSourceProvider).list(limit: 5000);
        await ref.read(stockLocalDataSourceProvider).replaceAll(raw);
      }),
      MapEntry(AppStrings.syncCategories, () async {
        final raw = await ref.read(categoryRemoteDataSourceProvider).list();
        await ref.read(categoryLocalDataSourceProvider).replaceAll(raw);
      }),
      MapEntry(AppStrings.syncUnits, () async {
        final raw = await ref.read(unitRemoteDataSourceProvider).list();
        await ref.read(unitLocalDataSourceProvider).replaceAll(raw);
      }),
      // Global drug catalog → quiet local mirror (throttled to once / 6h, so it
      // only does real work occasionally; otherwise it returns immediately).
      MapEntry('الكاتلوغ العام', () async {
        await ref.read(catalogSyncServiceProvider).sync();
      }),
    ];

    for (final task in tasks) {
      state = state.copyWith(step: task.key);
      try {
        await task.value();
      } catch (_) {
        // keep going; a single catalog failing shouldn't block the rest
      }
    }

    state = SyncProgress(running: false, lastSyncedAt: DateTime.now());
    _invalidateVisibleLists();
  }

  /// Re-reads any on-screen lists from the freshly updated cache.
  void _invalidateVisibleLists() {
    ref.invalidate(medicineCatalogProvider);
    ref.invalidate(currenciesProvider);
    ref.invalidate(customersProvider);
    ref.invalidate(stockListProvider);
    // Re-evaluate the first-load gate: once the global catalog mirror is filled,
    // it is no longer empty, so the one-time overlay never shows again.
    ref.invalidate(catalogMirrorEmptyProvider);
  }
}
