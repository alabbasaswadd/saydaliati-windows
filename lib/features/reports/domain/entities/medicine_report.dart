import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_report.freezed.dart';

/// A per-medicine report from `GET pharmacy-api/Report/medicine-report/{id}`.
@freezed
abstract class MedicineReport with _$MedicineReport {
  const factory MedicineReport({
    required String medicineId,
    required String name,
    required String code,
    required String category,
    required String manufacturerName,
    required double unitPrice,
    required double purchaseCost,
    required double stockQuantity,
    required double soldQuantity,
    required double reservedQuantity,
    required double totalSalesAmount,
    required int totalTransactions,
    required bool isNearExpiry,
    required bool isLowStock,
    required String notes,
    DateTime? expiryDate,
    @Default(<MedicineBatch>[]) List<MedicineBatch> batches,
  }) = _MedicineReport;
}

/// A stock batch of a medicine: expiry date and available quantity in a
/// warehouse, shown in the medicine report.
@freezed
abstract class MedicineBatch with _$MedicineBatch {
  const factory MedicineBatch({
    required String stockId,
    required String warehouseName,
    required double quantityAvailable,
    DateTime? expiryDate,
    int? daysLeft,
  }) = _MedicineBatch;
}
