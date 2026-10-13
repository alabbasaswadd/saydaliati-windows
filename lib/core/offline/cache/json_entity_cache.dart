import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';

/// Builds an [EntityCache] that stores raw wire maps (the DTO JSON) directly,
/// keyed by `id`. This is the reusable caching pattern for read-only catalog
/// data (medicines, currencies, …): a feature's local data source wraps this and
/// decodes the maps back into DTOs/entities — no `toJson` needed on entities.
///
/// [nameOf]/[codeOf] pull the indexed columns from the map for offline search
/// (e.g. medicine brand name and barcode).
EntityCache<Map<String, dynamic>> jsonEntityCache({
  required AppDatabase db,
  required String tenantId,
  required String entityType,
  String? Function(Map<String, dynamic> json)? nameOf,
  String? Function(Map<String, dynamic> json)? codeOf,
  String? Function(Map<String, dynamic> json)? parentOf,
}) {
  return EntityCache<Map<String, dynamic>>(
    db: db,
    tenantId: tenantId,
    entityType: entityType,
    fromJson: (json) => json,
    toJson: (json) => json,
    idOf: (json) => (json['id'] ?? '').toString(),
    nameOf: nameOf,
    codeOf: codeOf,
    parentOf: parentOf,
  );
}
