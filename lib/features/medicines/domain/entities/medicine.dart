import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saydaliati/core/enums/dosage_form.dart';

part 'medicine.freezed.dart';

/// A medicine in the catalog, flattened for the POS: identity + barcode + its
/// priced units. Pure domain model.
@freezed
abstract class Medicine with _$Medicine {
  const factory Medicine({
    required String id,
    required String brandName,
    @Default('') String brandNameArabic,
    required String genericName,
    @Default('') String foreignName,
    required String barcode,
    required DosageForm dosageForm,
    required String categoryId,
    String? categoryName,
    String? manufacturerId,
    String? manufacturerName,
    @Default(<MedicineUnit>[]) List<MedicineUnit> units,
    @Default(0) double purchaseCost,
    // تحديث السعر تلقائياً من الكاتلوغ عند المزامنة (افتراضي مُفعّل).
    @Default(true) bool autoPriceSync,
    // عملة أسعار هذا الدواء (رمزها)؛ افتراضياً العملة الأساسية SYP.
    @Default('SYP') String currency,
  }) = _Medicine;

  const Medicine._();

  /// A display name — Arabic brand name first (transliterated), then the Latin
  /// brand, falling back to the generic name.
  String get displayName => brandNameArabic.isNotEmpty
      ? brandNameArabic
      : (brandName.isNotEmpty ? brandName : genericName);
}

/// A sellable unit of a medicine with its prices (all in the base currency —
/// the backend prices carry no currency of their own).
@freezed
abstract class MedicineUnit with _$MedicineUnit {
  const factory MedicineUnit({
    required String unitId,
    required String unitName,
    required double salePrice,
    @Default(1) double conversionFactor,
    @Default(false) bool isBaseUnit,
    @Default(false) bool isDefault,
  }) = _MedicineUnit;
}

/// In-memory barcode lookup over a loaded catalog (used by the POS scanner).
extension MedicineCatalogX on List<Medicine> {
  Medicine? findByBarcode(String code) {
    final needle = code.trim();
    if (needle.isEmpty) return null;
    for (final m in this) {
      if (m.barcode.trim() == needle) return m;
    }
    return null;
  }
}
