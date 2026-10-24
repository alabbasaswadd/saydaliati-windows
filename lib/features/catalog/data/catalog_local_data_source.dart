import 'package:saydaliati/core/offline/cache/entity_cache.dart';
import 'package:saydaliati/core/offline/cache/json_entity_cache.dart';
import 'package:saydaliati/core/offline/db/app_database.dart';
import 'package:saydaliati/features/catalog/data/catalog_item_dto.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';

/// On-device mirror of the GLOBAL catalog (raw wire maps). It is tenant-independent
/// (the catalog is the same for everyone), so it is cached under a fixed 'global'
/// key — synced once per device, not per account. The indexed `name` column packs
/// all searchable names (arabic/latin/generic) so offline substring search covers
/// them; `code` is the barcode for offline scan lookup.
class CatalogLocalDataSource {
  CatalogLocalDataSource({required AppDatabase db})
      : _cache = jsonEntityCache(
          db: db,
          tenantId: 'global',
          entityType: 'catalog',
          nameOf: (m) => [
            m['brandName'],
            m['brandNameArabic'],
            m['foreignName'],
            m['genericName'],
          ].where((e) => e != null).join(' '),
          codeOf: (m) => m['barcode'] as String?,
          // Index the manufacturer so companies (الشركات) can be grouped and
          // filtered offline without decoding every payload.
          parentOf: (m) => (m['manufacturerName'] ?? '').toString(),
        );

  final EntityCache<Map<String, dynamic>> _cache;

  Future<int> count() => _cache.count();

  /// كامل الكتالوغ المحلي مفكوكاً — لمطابقة «المضاف إلى أدويتي» بالاسم
  /// والشركة حين لا باركود (العمود المفهرَس للاسم مُدمَجٌ للبحث النصّي فقط،
  /// لا يصلح لمطابقة حقلٍ بعينه). نفس ما تحمّله شاشة «تصفّح الكل» أصلاً.
  Future<List<CatalogItem>> allItems() async {
    final rows = await _cache.getAll();
    return rows.map(CatalogItemDto.fromJson).toList();
  }

  Future<DateTime?> lastPulledAt() => _cache.lastPulledAt();
  Future<void> markPulled() => _cache.markPulled();
  Future<void> upsertAll(List<Map<String, dynamic>> items) => _cache.upsertAll(items);
  Future<void> clear() => _cache.replaceAll(const []);

  /// Offline search by name/barcode (capped). Empty term → a browsable first
  /// page (so the catalog tab shows drugs immediately, like the online path),
  /// never all ~22.5k decoded rows at once.
  Future<List<CatalogItem>> search(String term, {int limit = 100}) async {
    final t = term.trim();
    final rows = t.isEmpty
        ? await _cache.page(limit: limit)
        : await _cache.search(t, limit: limit);
    return rows.map(CatalogItemDto.fromJson).toList();
  }

  /// A page of the whole mirror (for lazy "browse all" scrolling) so the user
  /// can reach every one of the ~22.5k drugs without decoding them all at once.
  Future<List<CatalogItem>> page({required int limit, required int offset}) async {
    final rows = await _cache.page(limit: limit, offset: offset);
    return rows.map(CatalogItemDto.fromJson).toList();
  }

  /// Exact offline barcode lookup (for scanning without network).
  Future<CatalogItem?> byBarcode(String barcode) async {
    final rows = await _cache.search(barcode);
    for (final m in rows) {
      if ((m['barcode'] ?? '').toString() == barcode) {
        return CatalogItemDto.fromJson(m);
      }
    }
    return null;
  }

  /// Offline manufacturers (الشركات) with their drug counts, from the indexed
  /// `parentId` column — no payloads decoded.
  Future<List<CatalogManufacturer>> manufacturers() async {
    final groups = await _cache.groupByParent();
    return groups
        .map((g) => CatalogManufacturer(name: g.name, count: g.count))
        .toList();
  }

  /// Offline: all catalog items of one manufacturer.
  Future<List<CatalogItem>> byManufacturer(String manufacturer,
      {int limit = 1000}) async {
    final rows = await _cache.byParent(manufacturer, limit: limit);
    return rows.map(CatalogItemDto.fromJson).toList();
  }
}
