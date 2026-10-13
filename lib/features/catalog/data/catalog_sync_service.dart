import 'package:saydaliati/features/catalog/data/catalog_local_data_source.dart';
import 'package:saydaliati/features/catalog/data/catalog_remote_data_source.dart';

/// Keeps the on-device mirror of the global catalog fresh. The local update is
/// **throttled to once every 6 hours** (computed precisely from the last pull
/// time); a full pull pages by offset so it can't stall on equal timestamps.
class CatalogSyncService {
  CatalogSyncService(this._remote, this._local);

  final CatalogRemoteDataSource _remote;
  final CatalogLocalDataSource _local;

  static const Duration throttle = Duration(hours: 6);
  // Insert the mirror in modest chunks so each write batch stays small (the
  // actual SQLite writes already run on drift's background isolate).
  static const int _chunkSize = 2000;

  /// True if the mirror is empty, never pulled, or older than [throttle].
  Future<bool> needsUpdate() async {
    if ((await _local.count()) == 0) return true;
    final last = await _local.lastPulledAt();
    if (last == null) return true;
    return DateTime.now().difference(last) >= throttle;
  }

  /// How long until a local update is allowed again (zero = allowed now).
  Future<Duration> remainingThrottle() async {
    final last = await _local.lastPulledAt();
    if (last == null) return Duration.zero;
    final rem = throttle - DateTime.now().difference(last);
    return rem.isNegative ? Duration.zero : rem;
  }

  /// Quietly mirror the whole catalog into the local DB. Skips when the mirror
  /// is still fresh unless [force] (the manual button passes force=true, but only
  /// after checking [needsUpdate] so the 6h rule still holds).
  Future<void> sync({bool force = false}) async {
    if (!force && !(await needsUpdate())) return;
    // One bulk request, decoded off the UI isolate.
    final all = await _remote.fetchAllRaw();
    // Empty result (e.g. a transient server/network hiccup) → keep the existing
    // mirror and don't stamp the pull time, so we retry next time.
    if (all.isEmpty) return;
    for (var i = 0; i < all.length; i += _chunkSize) {
      final end = (i + _chunkSize < all.length) ? i + _chunkSize : all.length;
      await _local.upsertAll(all.sublist(i, end));
    }
    await _local.markPulled();
  }
}
