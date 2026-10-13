import 'package:json_annotation/json_annotation.dart';

part 'stocktake_dto.g.dart';

@JsonSerializable(createToJson: false)
class StocktakeDto {
  const StocktakeDto({this.totalCostValue, this.medicinesCount, this.items});

  final num? totalCostValue;
  final int? medicinesCount;
  final List<StocktakeItemDto>? items;

  factory StocktakeDto.fromJson(Map<String, dynamic> json) =>
      _$StocktakeDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class StocktakeItemDto {
  const StocktakeItemDto({
    this.medicineId,
    this.brandName,
    this.onHandQuantity,
    this.purchaseCost,
    this.costValue,
    this.units,
  });

  final String? medicineId;
  final String? brandName;
  final num? onHandQuantity;
  final num? purchaseCost;
  final num? costValue;
  final List<StocktakeUnitDto>? units;

  factory StocktakeItemDto.fromJson(Map<String, dynamic> json) =>
      _$StocktakeItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class StocktakeUnitDto {
  const StocktakeUnitDto({
    this.unitName,
    this.conversionFactor,
    this.isBaseUnit,
    this.costPrice,
    this.salePrice,
  });

  final String? unitName;
  final num? conversionFactor;
  final bool? isBaseUnit;
  final num? costPrice;
  final num? salePrice;

  factory StocktakeUnitDto.fromJson(Map<String, dynamic> json) =>
      _$StocktakeUnitDtoFromJson(json);
}
