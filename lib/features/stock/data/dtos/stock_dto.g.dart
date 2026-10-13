// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockDto _$StockDtoFromJson(Map<String, dynamic> json) => StockDto(
  id: json['id'] as String?,
  medicineId: json['medicineId'] as String?,
  quantityAvailable: json['quantityAvailable'] as num?,
  purchasePrice: json['purchasePrice'] as num?,
  sellingPrice: json['sellingPrice'] as num?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  dateReceived: json['dateReceived'] == null
      ? null
      : DateTime.parse(json['dateReceived'] as String),
  medicine: json['medicine'] == null
      ? null
      : StockMedicineDto.fromJson(json['medicine'] as Map<String, dynamic>),
);

StockMedicineDto _$StockMedicineDtoFromJson(Map<String, dynamic> json) =>
    StockMedicineDto(
      brandName: json['brandName'] as String?,
      genericName: json['genericName'] as String?,
    );
