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
    @Default(<InventoryUnit>[]) List<InventoryUnit> units,
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
