import 'package:json_annotation/json_annotation.dart';

part 'medicine_report_dto.g.dart';

@JsonSerializable(createToJson: false)
class MedicineReportDto {
  const MedicineReportDto({
    this.medicineId,
    this.name,
    this.code,
    this.category,
    this.manufacturer,
    this.unitPrice,
    this.purchaseCost,
    this.stockQuantity,
    this.soldQuantity,
    this.totalSalesAmount,
    this.totalTransactions,
    this.isNearExpiry,
    this.isLowStock,
    this.notes,
    this.expiryDate,
    this.batches,
  });

  final String? medicineId;
  final String? name;
  final String? code;
  final String? category;
  final ReportManufacturerDto? manufacturer;
  final num? unitPrice;
  final num? purchaseCost;
  final num? stockQuantity;
  final num? soldQuantity;
  final num? totalSalesAmount;
  final int? totalTransactions;
  final bool? isNearExpiry;
  final bool? isLowStock;
  final String? notes;
  final DateTime? expiryDate;
  final List<MedicineBatchDto>? batches;

  factory MedicineReportDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineReportDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MedicineBatchDto {
  const MedicineBatchDto({
    this.stockId,
    this.warehouseName,
    this.quantityAvailable,
    this.expiryDate,
    this.daysLeft,
  });

  final String? stockId;
  final String? warehouseName;
  final num? quantityAvailable;
  final DateTime? expiryDate;
  final int? daysLeft;

  factory MedicineBatchDto.fromJson(Map<String, dynamic> json) =>
      _$MedicineBatchDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReportManufacturerDto {
  const ReportManufacturerDto({this.name});

  final String? name;

  factory ReportManufacturerDto.fromJson(Map<String, dynamic> json) =>
      _$ReportManufacturerDtoFromJson(json);
}
