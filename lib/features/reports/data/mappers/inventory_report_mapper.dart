import 'package:saydaliati/features/reports/data/dtos/inventory_report_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/inventory_report.dart';

extension InventoryReportDtoMapper on InventoryReportDto {
  InventoryReport toEntity() => InventoryReport(
        totalStockValue: (totalStockValue ?? 0).toDouble(),
        medicinesInStock: medicinesInStock ?? 0,
        batchesCount: batchesCount ?? 0,
        lowStockCount: lowStockCount ?? 0,
        items: (items ?? const [])
            .map((i) => InventoryItem(
                  medicineId: i.medicineId ?? '',
                  brandName: i.brandName ?? '',
                  quantity: (i.quantity ?? 0).toDouble(),
                  stockValue: (i.stockValue ?? 0).toDouble(),
                  isLowStock: i.isLowStock ?? false,
                  baseUnitSalePrice: (i.baseUnitSalePrice ?? 0).toDouble(),
                  baseUnitCost: (i.baseUnitCost ?? 0).toDouble(),
                  units: [
                    for (final u in i.units ?? const <InventoryUnitDto>[])
                      InventoryUnit(
                        unitName: u.unitName ?? '',
                        conversionFactor: (u.conversionFactor ?? 1).toDouble(),
                        isBaseUnit: u.isBaseUnit ?? false,
                        salePrice: (u.salePrice ?? 0).toDouble(),
                        purchaseCost: (u.purchaseCost ?? 0).toDouble(),
                      ),
                  ],
                  batches: [
                    for (final b in i.batches ?? const <InventoryBatchDto>[])
                      InventoryBatch(
                        expiryDate: b.expiryDate,
                        warehouseId: b.warehouseId ?? '',
                        warehouseName: b.warehouseName ?? '',
                        quantity: (b.quantity ?? 0).toDouble(),
                        purchasePrice: (b.purchasePrice ?? 0).toDouble(),
                        batchValue: (b.batchValue ?? 0).toDouble(),
                        daysLeft: b.daysLeft,
                      ),
                  ],
                ))
            .toList(),
      );
}
