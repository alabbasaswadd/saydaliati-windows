// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryReportDto _$InventoryReportDtoFromJson(Map<String, dynamic> json) =>
    InventoryReportDto(
      totalStockValue: json['totalStockValue'] as num?,
      medicinesInStock: (json['medicinesInStock'] as num?)?.toInt(),
      batchesCount: (json['batchesCount'] as num?)?.toInt(),
      lowStockCount: (json['lowStockCount'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InventoryItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

InventoryItemDto _$InventoryItemDtoFromJson(Map<String, dynamic> json) =>
    InventoryItemDto(
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      quantity: json['quantity'] as num?,
      stockValue: json['stockValue'] as num?,
      isLowStock: json['isLowStock'] as bool?,
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => InventoryUnitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

InventoryUnitDto _$InventoryUnitDtoFromJson(Map<String, dynamic> json) =>
    InventoryUnitDto(
      unitName: json['unitName'] as String?,
      conversionFactor: json['conversionFactor'] as num?,
      isBaseUnit: json['isBaseUnit'] as bool?,
      salePrice: json['salePrice'] as num?,
      purchaseCost: json['purchaseCost'] as num?,
    );
