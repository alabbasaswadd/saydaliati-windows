// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineDto _$MedicineDtoFromJson(Map<String, dynamic> json) => MedicineDto(
  id: json['id'] as String?,
  brandName: json['brandName'] as String?,
  brandNameArabic: json['brandNameArabic'] as String?,
  genericName: json['genericName'] as String?,
  foreignName: json['foreignName'] as String?,
  barcode: json['barcode'] as String?,
  dosageForm: (json['dosageForm'] as num?)?.toInt(),
  categoryId: json['categoryId'] as String?,
  category: json['category'] == null
      ? null
      : MedicineCategoryDto.fromJson(json['category'] as Map<String, dynamic>),
  manufacturer: json['manufacturer'] == null
      ? null
      : MedicineManufacturerDto.fromJson(
          json['manufacturer'] as Map<String, dynamic>,
        ),
  unitPrices: (json['unitPrices'] as List<dynamic>?)
      ?.map((e) => MedicineUnitPriceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  purchaseCost: json['purchaseCost'] as num?,
  autoPriceSync: json['autoPriceSync'] as bool?,
  currency: json['currency'] as String?,
);

MedicineCategoryDto _$MedicineCategoryDtoFromJson(Map<String, dynamic> json) =>
    MedicineCategoryDto(
      id: json['id'] as String?,
      categoryName: json['categoryName'] as String?,
      description: json['description'] as String?,
    );

MedicineManufacturerDto _$MedicineManufacturerDtoFromJson(
  Map<String, dynamic> json,
) => MedicineManufacturerDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  location: json['location'] as String?,
);

MedicineUnitPriceDto _$MedicineUnitPriceDtoFromJson(
  Map<String, dynamic> json,
) => MedicineUnitPriceDto(
  unitId: json['unitId'] as String?,
  unit: json['unit'] == null
      ? null
      : MedicineUnitDto.fromJson(json['unit'] as Map<String, dynamic>),
  salePrice: json['salePrice'] as num?,
  conversionFactor: json['conversionFactor'] as num?,
  isBaseUnit: json['isBaseUnit'] as bool?,
  isDefault: json['isDefault'] as bool?,
);

MedicineUnitDto _$MedicineUnitDtoFromJson(Map<String, dynamic> json) =>
    MedicineUnitDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
