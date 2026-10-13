// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stocktake_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StocktakeDto _$StocktakeDtoFromJson(Map<String, dynamic> json) => StocktakeDto(
  totalCostValue: json['totalCostValue'] as num?,
  medicinesCount: (json['medicinesCount'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => StocktakeItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

StocktakeItemDto _$StocktakeItemDtoFromJson(Map<String, dynamic> json) =>
    StocktakeItemDto(
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      onHandQuantity: json['onHandQuantity'] as num?,
      purchaseCost: json['purchaseCost'] as num?,
      costValue: json['costValue'] as num?,
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => StocktakeUnitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

StocktakeUnitDto _$StocktakeUnitDtoFromJson(Map<String, dynamic> json) =>
    StocktakeUnitDto(
      unitName: json['unitName'] as String?,
      conversionFactor: json['conversionFactor'] as num?,
      isBaseUnit: json['isBaseUnit'] as bool?,
      costPrice: json['costPrice'] as num?,
      salePrice: json['salePrice'] as num?,
    );
