import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/cache/json_entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// On-device cache of customers (raw wire maps), so the POS can pick a customer
/// and the customers list works offline.
class CustomerLocalDataSource {
  CustomerLocalDataSource({required AppDatabase db, required String tenantId})
      : _cache = jsonEntityCache(
          db: db,
          tenantId: tenantId,
          entityType: 'customers',
          nameOf: (m) =>
              '${m['firstName'] ?? ''} ${m['lastName'] ?? ''}'.trim(),
          codeOf: (m) => m['phone'] as String?,
        );

  final EntityCache<Map<String, dynamic>> _cache;

  Future<List<Map<String, dynamic>>> getAll() => _cache.getAll();

  Future<void> replaceAll(List<Map<String, dynamic>> items) =>
      _cache.replaceAll(items);

  Future<void> upsert(Map<String, dynamic> item) => _cache.upsert(item);
}
