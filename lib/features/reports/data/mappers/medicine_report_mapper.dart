import 'package:saydaliati/features/reports/data/dtos/medicine_report_dto.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';

extension MedicineReportDtoMapper on MedicineReportDto {
  MedicineReport toEntity() => MedicineReport(
        medicineId: medicineId ?? '',
        name: name ?? '',
        code: code ?? '',
        category: category ?? '',
        manufacturerName: manufacturer?.name ?? '',
        unitPrice: (unitPrice ?? 0).toDouble(),
        purchaseCost: (purchaseCost ?? 0).toDouble(),
        stockQuantity: (stockQuantity ?? 0).toDouble(),
        soldQuantity: (soldQuantity ?? 0).toDouble(),
        reservedQuantity: (reservedQuantity ?? 0).toDouble(),
        totalSalesAmount: (totalSalesAmount ?? 0).toDouble(),
        totalTransactions: totalTransactions ?? 0,
        isNearExpiry: isNearExpiry ?? false,
        isLowStock: isLowStock ?? false,
        notes: notes ?? '',
        expiryDate: expiryDate,
        batches: [
          for (final b in batches ?? const <MedicineBatchDto>[]) b.toEntity()
        ],
      );
}

extension MedicineBatchDtoMapper on MedicineBatchDto {
  MedicineBatch toEntity() => MedicineBatch(
        stockId: stockId ?? '',
        warehouseName: warehouseName ?? '',
        quantityAvailable: (quantityAvailable ?? 0).toDouble(),
        expiryDate: expiryDate,
        daysLeft: daysLeft,
      );
}
