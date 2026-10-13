import 'package:saydaliati/core/enums/dosage_form.dart';

/// A priced unit row of a medicine: sale price + conversion factor to the base
/// unit. Exactly one row per medicine is the base unit (factor 1).
class MedicineUnitPriceInput {
  const MedicineUnitPriceInput({
    required this.unitId,
    required this.salePrice,
    this.conversionFactor = 1,
    this.isBaseUnit = false,
    this.isDefault = false,
  });

  final String unitId;
  final double salePrice;
  final double conversionFactor;
  final bool isBaseUnit;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'salePrice': salePrice,
        'conversionFactor': conversionFactor,
        'isBaseUnit': isBaseUnit,
        'isDefault': isDefault,
      };
}

/// Payload for `POST pharmacy-api/Medicine` (create). Includes the priced units.
class CreateMedicineInput {
  const CreateMedicineInput({
    required this.categoryId,
    required this.brandName,
    required this.dosageForm,
    this.genericName = '',
    this.foreignName = '',
    this.barcode = '',
    this.manufacturerId,
    this.strength = 0,
    this.description = '',
    this.note = '',
    this.sideEffects = '',
    this.yearsOfValidity = 0,
    this.manufacturingDate,
    this.expirationDate,
    this.unitPrices = const [],
  });

  final String categoryId;
  final String brandName;
  final DosageForm dosageForm;
  final String genericName;
  final String foreignName;
  final String barcode;
  final String? manufacturerId;
  final double strength;
  final String description;
  final String note;
  final String sideEffects;
  final int yearsOfValidity;
  final DateTime? manufacturingDate;
  final DateTime? expirationDate;
  final List<MedicineUnitPriceInput> unitPrices;

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    return {
      'categoryId': categoryId,
      'genericName': genericName,
      'brandName': brandName,
      'foreignName': foreignName,
      'strength': strength,
      'barcode': barcode,
      'manufacturerId': manufacturerId,
      'sideEffects': sideEffects,
      'dosageForm': dosageForm.wire,
      'description': description,
      'note': note,
      'yearsOfValidity': yearsOfValidity,
      'manufacturingDate': (manufacturingDate ?? now).toIso8601String(),
      'expirationDate':
          (expirationDate ?? DateTime(now.year + 2, now.month, now.day))
              .toIso8601String(),
      'unitPrices': unitPrices.map((u) => u.toJson()).toList(),
    };
  }

  /// The update payload. The backend's update command now manages the medicine's
  /// units (full replacement), so unit prices are included here too.
  Map<String, dynamic> toUpdateJson(String id) => {'id': id, ...toJson()};
}
