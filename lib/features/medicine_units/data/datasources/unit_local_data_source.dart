import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/cache/json_entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

class UnitLocalDataSource {
  UnitLocalDataSource({required AppDatabase db, required String tenantId})
      : _cache = jsonEntityCache(
          db: db,
          tenantId: tenantId,
          entityType: 'units',
          nameOf: (m) => m['name'] as String?,
        );

  final EntityCache<Map<String, dynamic>> _cache;

  Future<List<Map<String, dynamic>>> getAll() => _cache.getAll();
  Future<void> replaceAll(List<Map<String, dynamic>> items) =>
      _cache.replaceAll(items);
}
