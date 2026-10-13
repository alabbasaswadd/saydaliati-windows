import 'package:json_annotation/json_annotation.dart';

part 'medicine_dto.g.dart';

/// Wire model for `pharmacy-api/Medicine`. All fields nullable so partial rows
/// never throw; the mapper coalesces.
@JsonSerializable(createToJson: false)
class MedicineDto {
  const MedicineDto({
    this.id,
    this.brandName,
    this.brandNameArabic,
    this.genericName,
    this.foreignName,
    this.barcode,
    this.dosageForm,
    this.categoryId,
    this.category,
    this.manufacturer,
    this.unitPrices,
    this.purchaseCost,
    this.autoPriceSync,
    this.currency,
  });

  final String? id;
  final String? brandName;
  final String? brandNameArabic;
  final String? genericName;
  final String? foreignName;
  final String? barcode;
  final int? dosageForm;
  final String? categoryId;
  final MedicineCategoryDto? category;
  final MedicineManufacturerDto? manufacturer;
  final List<MedicineUnitPriceDto>? unitPrices;

  /// تكلفة الشراء لكل وحدة أساسية (محسوبة من فواتير المشتريات).
  final num? purchaseCost;

  /// تحديث السعر تلقائياً من الكاتلوغ عند المزامنة.
  final bool? autoPriceSync;

  /// عملة أسعار الدواء (SYP/USD…)؛ افتراضياً العملة الأساسية.
  final String? currency;

  factory MedicineDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MedicineCategoryDto {
  const MedicineCategoryDto({this.id, this.categoryName, this.description});

  final String? id;
  final String? categoryName;
  final String? description;

  factory MedicineCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineCategoryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MedicineManufacturerDto {
  const MedicineManufacturerDto({this.id, this.name, this.location});

  final String? id;
  final String? name;
  final String? location;

  factory MedicineManufacturerDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineManufacturerDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MedicineUnitPriceDto {
  const MedicineUnitPriceDto({
    this.unitId,
    this.unit,
    this.salePrice,
    this.conversionFactor,
    this.isBaseUnit,
    this.isDefault,
  });

  final String? unitId;
  final MedicineUnitDto? unit;
  final num? salePrice;
  final num? conversionFactor;
  final bool? isBaseUnit;
  final bool? isDefault;

  factory MedicineUnitPriceDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineUnitPriceDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MedicineUnitDto {
  const MedicineUnitDto({this.id, this.name, this.description});

  final String? id;
  final String? name;
  final String? description;

  factory MedicineUnitDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineUnitDtoFromJson(json);
}
