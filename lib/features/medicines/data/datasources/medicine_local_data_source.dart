import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/cache/json_entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// On-device cache of the medicine catalog (raw wire maps), indexed by brand
/// name and barcode so the POS can search/scan offline.
class MedicineLocalDataSource {
  MedicineLocalDataSource({required AppDatabase db, required String tenantId})
      : _cache = jsonEntityCache(
          db: db,
          tenantId: tenantId,
          entityType: 'medicines',
          nameOf: (m) => m['brandName'] as String?,
          codeOf: (m) => m['barcode'] as String?,
        );

  final EntityCache<Map<String, dynamic>> _cache;

  Future<List<Map<String, dynamic>>> getAll() => _cache.getAll();

  Future<void> replaceAll(List<Map<String, dynamic>> items) =>
      _cache.replaceAll(items);

  /// Write-through a single medicine (after a create/update) so the offline
  /// cache — and its indexed name/barcode columns — stay correct without a full
  /// re-pull.
  Future<void> upsertRaw(Map<String, dynamic> json) => _cache.upsert(json);

  /// Remove one medicine from the cache (after a delete) so it stops showing offline.
  Future<void> removeById(String id) => _cache.removeById(id);

  /// Mirror a barcode assignment into the cache. Only fills an empty barcode
  /// (matches the backend, which never overwrites a non-empty one on purchase).
  Future<void> fillBarcode(String id, String barcode) async {
    final current = await _cache.getById(id);
    if (current == null) return;
    final existing = ((current['barcode'] as String?) ?? '').trim();
    if (existing.isNotEmpty) return;
    final updated = Map<String, dynamic>.from(current)..['barcode'] = barcode;
    await _cache.upsert(updated);
  }
}
