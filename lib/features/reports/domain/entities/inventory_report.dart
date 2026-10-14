import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_report.freezed.dart';

/// Inventory report from `GET pharmacy-api/Report/inventory`.
@freezed
abstract class InventoryReport with _$InventoryReport {
  const factory InventoryReport({
    required double totalStockValue,
    required int medicinesInStock,
    required int batchesCount,
    required int lowStockCount,
    @Default(<InventoryItem>[]) List<InventoryItem> items,
  }) = _InventoryReport;
}

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String medicineId,
    required String brandName,
    required double quantity,
    required double stockValue,
    required bool isLowStock,
    @Default(0) double baseUnitSalePrice,
    @Default(0) double baseUnitCost,
    @Default(<InventoryUnit>[]) List<InventoryUnit> units,
    @Default(<InventoryBatch>[]) List<InventoryBatch> batches,
  }) = _InventoryItem;
}

@freezed
abstract class InventoryUnit with _$InventoryUnit {
  const factory InventoryUnit({
    required String unitName,
    required double conversionFactor,
    required bool isBaseUnit,
    required double salePrice,
    required double purchaseCost,
  }) = _InventoryUnit;
}

/// One expiry batch of a medicine — the inventory tree's second level
/// (`GET pharmacy-api/Report/inventory`). `daysLeft` is negative once expired,
/// null when the batch has no expiry date at all.
@freezed
abstract class InventoryBatch with _$InventoryBatch {
  const factory InventoryBatch({
    DateTime? expiryDate,
    @Default('') String warehouseId,
    @Default('') String warehouseName,
    @Default(0) double quantity,
    @Default(0) double purchasePrice,
    @Default(0) double batchValue,
    int? daysLeft,
  }) = _InventoryBatch;
}
