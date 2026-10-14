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
      baseUnitSalePrice: json['baseUnitSalePrice'] as num?,
      baseUnitCost: json['baseUnitCost'] as num?,
      units: (json['units'] as List<dynamic>?)
          ?.map((e) => InventoryUnitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      batches: (json['batches'] as List<dynamic>?)
          ?.map((e) => InventoryBatchDto.fromJson(e as Map<String, dynamic>))
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

InventoryBatchDto _$InventoryBatchDtoFromJson(Map<String, dynamic> json) =>
    InventoryBatchDto(
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      quantity: json['quantity'] as num?,
      purchasePrice: json['purchasePrice'] as num?,
      batchValue: json['batchValue'] as num?,
      daysLeft: (json['daysLeft'] as num?)?.toInt(),
    );
