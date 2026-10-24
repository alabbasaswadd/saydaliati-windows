import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/catalog/data/catalog_local_data_source.dart';
import 'package:saydaliati/features/catalog/data/catalog_remote_data_source.dart';
import 'package:saydaliati/features/catalog/data/catalog_sync_service.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';

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

/// باركودات أدويتي الخاصة — مفروزة من قيم `Medicine.barcode` (قد يحمل الحقل
/// عدّة رموز مفصولة بفاصلة لدواء واحد، انظر `AddCatalogToStockHandler`
/// بالخادم) — لمطابقة أصناف الكاتلوغ المضافة أصلاً إلى أدويتي.
@riverpod
Set<String> myMedicineBarcodes(Ref ref) {
  final meds = ref.watch(medicineCatalogProvider).value ?? const [];
  final out = <String>{};
  for (final m in meds) {
    for (final token in m.barcode.split(',')) {
      final t = token.trim();
      if (t.isNotEmpty) out.add(t);
    }
  }
  return out;
}

/// مفاتيح «اسم+شركة» مطبَّعة لأدويتي — احتياطيّ المطابقة حين لا باركود (شائع
/// فعلاً بالكاتلوغ). كل اسم غير فارغ لدواءٍ (التجاري، العربي، الأجنبي،
/// العلمي) يُولِّد مفتاحاً مستقلاً مقروناً بالشركة، فتكفي مطابقة أيٍّ منها.
@riverpod
Set<String> myMedicineNameManufacturerKeys(Ref ref) {
  final meds = ref.watch(medicineCatalogProvider).value ?? const [];
  final out = <String>{};
  for (final m in meds) {
    out.addAll(nameManufacturerKeys(
      [m.brandName, m.brandNameArabic, m.foreignName, m.genericName],
      m.manufacturerName ?? '',
    ));
  }
  return out;
}

/// يُطبِّع نصّاً للمطابقة: يُزيل الفراغات الطرفية ويوحِّد حالة الأحرف ويُقلِّص
/// الفراغات الداخلية المتكرّرة — فلا يُفسِد اختلافٌ شكليٌّ بسيط مطابقةً
/// حقيقية.
String _normalizeForMatch(String s) =>
    s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

/// مفاتيح «اسم مطبَّع|شركة مطبَّعة» لكل اسمٍ غير فارغ في [names] — يُستعمَل من
/// جهتَي المطابقة (أدويتي وصنف الكاتلوغ) بنفس الدالة فلا تتعارض القاعدتان.
Set<String> nameManufacturerKeys(Iterable<String> names, String manufacturer) {
  final m = _normalizeForMatch(manufacturer);
  return {
    for (final n in names)
      if (n.trim().isNotEmpty) '${_normalizeForMatch(n)}|$m',
  };
}

/// هل صنف الكاتلوغ [item] مضافٌ أصلاً إلى أدويتي؟ بالباركود أولاً (مفكَّكاً من
/// الطرفين لتعدّد الرموز — شائع: ١٤٪ من الكتالوغ متعدّد الباركود)، وبالاسم
/// والشركة معاً إن تعذّر — كثيرٌ من أصناف الكتالوغ بلا باركود مسجَّل أصلاً.
bool isCatalogItemAdded(
  CatalogItem item,
  Set<String> myBarcodes,
  Set<String> myNameManufacturerKeys,
) {
  for (final token in item.barcode.split(',')) {
    final t = token.trim();
    if (t.isNotEmpty && myBarcodes.contains(t)) return true;
  }
  final itemKeys = nameManufacturerKeys(
    [item.brandName, item.brandNameArabic, item.foreignName, item.genericName],
    item.manufacturerName,
  );
  return itemKeys.any(myNameManufacturerKeys.contains);
}

/// تقدّم «المضاف من الكاتلوغ إلى أدويتي» — عدد أصناف الكتالوغ المحلي
/// المطابقة لأحد أدويتي (بالباركود أو بالاسم والشركة)، من أصل حجم الكتالوغ
/// المحلي الكامل. `null` إن لم تُزامَن النسخة المحلية بعد (لا معنى لنسبة من
/// صفر).
///
/// يفكّ كامل الكتالوغ المحلي (~٢٢ ألف صفّ) — نفس ما تحمّله شاشة «تصفّح
/// الكل» أصلاً بلا شكوى أداء — لأن مطابقة الاسم تحتاج الحقول منفردة (لا
/// العمود المفهرَس المُدمَج للبحث النصّي).
@riverpod
Future<({int added, int total})?> catalogAddedProgress(Ref ref) async {
  final local = ref.watch(catalogLocalDataSourceProvider);
  final total = await local.count();
  if (total == 0) return null;
  final barcodes = ref.watch(myMedicineBarcodesProvider);
  final nameKeys = ref.watch(myMedicineNameManufacturerKeysProvider);
  if (barcodes.isEmpty && nameKeys.isEmpty) return (added: 0, total: total);
  final items = await local.allItems();
  var added = 0;
  for (final it in items) {
    if (isCatalogItemAdded(it, barcodes, nameKeys)) added++;
  }
  return (added: added, total: total);
}
