import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// On-device cache of stock batches (raw wire maps keyed by stock id, indexed by
/// medicine id), so the POS can show available quantities and pick a batch
/// offline — and so an offline sale can decrement the on-hand quantity locally.
///
/// Rows come from two sources, both normalized to the same shape
/// (`{id, medicineId, warehouseId, quantityAvailable, expiryDate}`):
/// * the full `/Stock` list during a data sync ([replaceAll]), and
/// * the per-medicine batches fetched when adding a line to the POS
///   ([replaceForMedicine]).
class StockLocalDataSource {
  StockLocalDataSource({required AppDatabase db, required String tenantId})
      : _cache = EntityCache<Map<String, dynamic>>(
          db: db,
          tenantId: tenantId,
          entityType: 'stocks',
          fromJson: (j) => j,
          toJson: (j) => j,
          idOf: (j) => (j['id'] ?? j['stockId'] ?? '').toString(),
          parentOf: (j) => (j['medicineId'] ?? '').toString(),
        );

  final EntityCache<Map<String, dynamic>> _cache;

  double _qty(Map<String, dynamic> m) =>
      ((m['quantityAvailable'] ?? 0) as num).toDouble();

  /// All cached stock rows (for the stock list's offline fallback).
  Future<List<Map<String, dynamic>>> getAll() => _cache.getAll();

  /// Full refresh of the whole stock cache (from the `/Stock` list).
  Future<void> replaceAll(List<Map<String, dynamic>> items) =>
      _cache.replaceAll(items);

  /// Replaces just one medicine's cached batches (write-through after fetching
  /// its batches online), so depleted batches disappear and others are untouched.
  Future<void> replaceForMedicine(
      String medicineId, List<Map<String, dynamic>> batches) async {
    final existing = await _cache.getAll();
    for (final row in existing) {
      if ((row['medicineId'] ?? '').toString() == medicineId) {
        await _cache.removeById((row['id'] ?? row['stockId'] ?? '').toString());
      }
    }
    if (batches.isNotEmpty) await _cache.upsertAll(batches);
  }

  /// Cached, in-stock batches for a medicine (optionally scoped to a warehouse),
  /// nearest expiry first — raw maps; the caller maps them to its own type.
  Future<List<Map<String, dynamic>>> cachedBatchesForMedicine(
    String medicineId, {
    String? warehouseId,
  }) async {
    final rows = await _cache.getAll();
    final matched = rows.where((m) {
      if ((m['medicineId'] ?? '').toString() != medicineId) return false;
      if (_qty(m) <= 0) return false;
      if (warehouseId != null &&
          warehouseId.isNotEmpty &&
          m['warehouseId'] != null &&
          m['warehouseId'].toString() != warehouseId) {
        return false;
      }
      return true;
    }).toList();
    matched.sort((a, b) {
      final ea = DateTime.tryParse('${a['expiryDate'] ?? ''}');
      final eb = DateTime.tryParse('${b['expiryDate'] ?? ''}');
      if (ea == null && eb == null) return 0;
      if (ea == null) return 1;
      if (eb == null) return -1;
      return ea.compareTo(eb);
    });
    return matched;
  }

  /// Optimistically reduces a single batch's on-hand quantity (offline sale).
  /// Returns false if the batch isn't cached (so the caller can fall back).
  Future<bool> decrement(String stockId, double qty) async {
    final row = await _cache.getById(stockId);
    if (row == null) return false;
    row['quantityAvailable'] = _qty(row) - qty;
    await _cache.upsert(row);
    return true;
  }

  /// Adds a quantity back to a single batch (reverses an offline sale when the
  /// queued invoice is edited/deleted). Returns false if the batch isn't cached.
  Future<bool> increment(String stockId, double qty) async {
    final row = await _cache.getById(stockId);
    if (row == null) return false;
    row['quantityAvailable'] = _qty(row) + qty;
    await _cache.upsert(row);
    return true;
  }

  /// Adds a quantity back to a medicine's first cached batch (fallback when the
  /// original batch wasn't pinned). No-op if the medicine has no cached batch.
  Future<void> incrementForMedicine(String medicineId, double qty) async {
    final rows = await _cache.getAll();
    for (final row in rows) {
      if ((row['medicineId'] ?? '').toString() == medicineId) {
        row['quantityAvailable'] = _qty(row) + qty;
        await _cache.upsert(row);
        return;
      }
    }
  }

  /// Optimistically reduces a medicine's quantity across its batches, nearest
  /// expiry first (FEFO) — used when the sale line didn't pin a specific batch.
  Future<void> decrementFefo(String medicineId, double qty) async {
    var remaining = qty;
    final rows = await cachedBatchesForMedicine(medicineId);
    for (final row in rows) {
      if (remaining <= 0) break;
      final avail = _qty(row);
      final take = avail < remaining ? avail : remaining;
      row['quantityAvailable'] = avail - take;
      await _cache.upsert(row);
      remaining -= take;
    }
  }
}
