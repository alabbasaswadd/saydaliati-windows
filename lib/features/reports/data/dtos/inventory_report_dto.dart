import 'package:json_annotation/json_annotation.dart';

part 'inventory_report_dto.g.dart';

@JsonSerializable(createToJson: false)
class InventoryReportDto {
  const InventoryReportDto({
    this.totalStockValue,
    this.medicinesInStock,
    this.batchesCount,
    this.lowStockCount,
    this.items,
  });

  final num? totalStockValue;
  final int? medicinesInStock;
  final int? batchesCount;
  final int? lowStockCount;
  final List<InventoryItemDto>? items;

  factory InventoryReportDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryReportDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class InventoryItemDto {
  const InventoryItemDto({
    this.medicineId,
    this.brandName,
    this.quantity,
    this.stockValue,
    this.isLowStock,
    this.units,
  });

  final String? medicineId;
  final String? brandName;
  final num? quantity;
  final num? stockValue;
  final bool? isLowStock;
  final List<InventoryUnitDto>? units;

  factory InventoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class InventoryUnitDto {
  const InventoryUnitDto({
    this.unitName,
    this.conversionFactor,
    this.isBaseUnit,
    this.salePrice,
    this.purchaseCost,
  });

  final String? unitName;
  final num? conversionFactor;
  final bool? isBaseUnit;
  final num? salePrice;
  final num? purchaseCost;

  factory InventoryUnitDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryUnitDtoFromJson(json);
}
