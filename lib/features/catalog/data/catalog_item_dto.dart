import 'package:saydaliati/features/catalog/domain/catalog_item.dart';

/// Decodes the backend `MedicineCatalogItemDto` JSON into a [CatalogItem].
/// Manual (no code-gen) — the shape is flat and stable. Enums/numbers arrive as
/// JSON primitives; we coerce defensively so a missing field never crashes.
abstract final class CatalogItemDto {
  const CatalogItemDto._();

  static CatalogItem fromJson(Map<String, dynamic> j) => CatalogItem(
        id: _s(j['id']),
        sakoCode: _s(j['sakoCode']),
        genericName: _s(j['genericName']),
        brandName: _s(j['brandName']),
        brandNameArabic: _s(j['brandNameArabic']),
        foreignName: _s(j['foreignName']),
        strength: _d(j['strength']),
        barcode: _s(j['barcode']),
        dosageForm: _i(j['dosageForm']),
        manufacturerName: _s(j['manufacturerName']),
        description: _s(j['description']),
        note: _s(j['note']),
        usage: _s(j['usage']),
        dosage: _s(j['dosage']),
        pricePharmacist: _d(j['pricePharmacist']),
        pricePublic: _d(j['pricePublic']),
        currency: (() {
          final c = _s(j['currency']).toUpperCase();
          return c.isEmpty ? 'SYP' : c;
        })(),
      );

  static CatalogManufacturer manufacturerFromJson(Map<String, dynamic> j) =>
      CatalogManufacturer(name: _s(j['name']), count: _i(j['count']));

  static String _s(Object? v) => v == null ? '' : v.toString();
  static double _d(Object? v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
  static int _i(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
}
