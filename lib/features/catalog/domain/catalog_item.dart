/// A single entry in the **global medicine catalog** (الكاتلوغ العام) — the
/// nationwide, read-only drug reference (~22.5k items). It is NOT the pharmacy's
/// own medicine; the pharmacist can only read it (and copy an item into their
/// own stock). Keyed by the stable source code [sakoCode].
class CatalogItem {
  const CatalogItem({
    required this.id,
    required this.sakoCode,
    required this.genericName,
    required this.brandName,
    required this.brandNameArabic,
    required this.foreignName,
    required this.strength,
    required this.barcode,
    required this.dosageForm,
    required this.manufacturerName,
    required this.description,
    required this.note,
    required this.usage,
    required this.dosage,
    required this.pricePharmacist,
    required this.pricePublic,
    required this.currency,
  });

  final String id;
  final String sakoCode;
  final String genericName; // التركيب / الاسم العلمي
  final String brandName; // الاسم (عربي)
  final String brandNameArabic;
  final String foreignName; // الاسم الإنجليزي
  final double strength;
  final String barcode;
  final int dosageForm;
  final String manufacturerName; // الشركة
  final String description;
  final String note; // العبوة
  final String usage; // الاستخدام
  final String dosage; // الجرعة
  final double pricePharmacist;
  final double pricePublic;
  final String currency; // عملة السعر: SYP (ل.س) أو USD ($)

  /// رمز عملة السعر للعرض.
  String get currencySymbol => currency.toUpperCase() == 'USD' ? '\$' : 'ل.س';

  /// Preferred display name: Arabic brand, else Latin/English, else generic.
  String get displayName {
    if (brandName.trim().isNotEmpty) return brandName.trim();
    if (brandNameArabic.trim().isNotEmpty) return brandNameArabic.trim();
    if (foreignName.trim().isNotEmpty) return foreignName.trim();
    return genericName.trim();
  }
}

/// A manufacturer (الشركة) with its catalog item count — for grouping.
class CatalogManufacturer {
  const CatalogManufacturer({required this.name, required this.count});
  final String name;
  final int count;
}
