// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineReportDto _$MedicineReportDtoFromJson(Map<String, dynamic> json) =>
    MedicineReportDto(
      medicineId: json['medicineId'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      category: json['category'] as String?,
      manufacturer: json['manufacturer'] == null
          ? null
          : ReportManufacturerDto.fromJson(
              json['manufacturer'] as Map<String, dynamic>,
            ),
      unitPrice: json['unitPrice'] as num?,
      purchaseCost: json['purchaseCost'] as num?,
      stockQuantity: json['stockQuantity'] as num?,
      soldQuantity: json['soldQuantity'] as num?,
      totalSalesAmount: json['totalSalesAmount'] as num?,
      totalTransactions: (json['totalTransactions'] as num?)?.toInt(),
      isNearExpiry: json['isNearExpiry'] as bool?,
      isLowStock: json['isLowStock'] as bool?,
      notes: json['notes'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      batches: (json['batches'] as List<dynamic>?)
          ?.map((e) => MedicineBatchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

MedicineBatchDto _$MedicineBatchDtoFromJson(Map<String, dynamic> json) =>
    MedicineBatchDto(
      stockId: json['stockId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      quantityAvailable: json['quantityAvailable'] as num?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      daysLeft: (json['daysLeft'] as num?)?.toInt(),
    );

ReportManufacturerDto _$ReportManufacturerDtoFromJson(
  Map<String, dynamic> json,
) => ReportManufacturerDto(name: json['name'] as String?);
