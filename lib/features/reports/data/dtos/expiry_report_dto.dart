import 'package:json_annotation/json_annotation.dart';

part 'expiry_report_dto.g.dart';

@JsonSerializable(createToJson: false)
class ExpiryReportDto {
  const ExpiryReportDto({this.expiringSoon, this.expired});

  final List<ExpiryBatchDto>? expiringSoon;
  final List<ExpiryBatchDto>? expired;

  factory ExpiryReportDto.fromJson(Map<String, dynamic> json) =>
      _$ExpiryReportDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ExpiryBatchDto {
  const ExpiryBatchDto({
    this.stockId,
    this.medicineId,
    this.brandName,
    this.warehouseId,
    this.warehouseName,
    this.expiryDate,
    this.quantityAvailable,
    this.daysLeft,
  });

  final String? stockId;
  final String? medicineId;
  final String? brandName;
  final String? warehouseId;
  final String? warehouseName;
  final DateTime? expiryDate;
  final num? quantityAvailable;
  final int? daysLeft;

  factory ExpiryBatchDto.fromJson(Map<String, dynamic> json) =>
      _$ExpiryBatchDtoFromJson(json);
}
