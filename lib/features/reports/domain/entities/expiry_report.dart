import 'package:freezed_annotation/freezed_annotation.dart';

part 'expiry_report.freezed.dart';

/// Batch-level expiry report from `GET pharmacy-api/Report/expiry`.
@freezed
abstract class ExpiryReport with _$ExpiryReport {
  const factory ExpiryReport({
    @Default(<ExpiryBatch>[]) List<ExpiryBatch> expiringSoon,
    @Default(<ExpiryBatch>[]) List<ExpiryBatch> expired,
  }) = _ExpiryReport;
}

@freezed
abstract class ExpiryBatch with _$ExpiryBatch {
  const factory ExpiryBatch({
    required String stockId,
    required String medicineId,
    required String brandName,
    required String warehouseName,
    required DateTime expiryDate,
    required double quantityAvailable,
    required int daysLeft,
  }) = _ExpiryBatch;
}
