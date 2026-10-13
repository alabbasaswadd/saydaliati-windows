// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expiry_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpiryReportDto _$ExpiryReportDtoFromJson(Map<String, dynamic> json) =>
    ExpiryReportDto(
      expiringSoon: (json['expiringSoon'] as List<dynamic>?)
          ?.map((e) => ExpiryBatchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      expired: (json['expired'] as List<dynamic>?)
          ?.map((e) => ExpiryBatchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ExpiryBatchDto _$ExpiryBatchDtoFromJson(Map<String, dynamic> json) =>
    ExpiryBatchDto(
      stockId: json['stockId'] as String?,
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      quantityAvailable: json['quantityAvailable'] as num?,
      daysLeft: (json['daysLeft'] as num?)?.toInt(),
    );
