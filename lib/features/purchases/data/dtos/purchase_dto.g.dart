// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseDto _$PurchaseDtoFromJson(Map<String, dynamic> json) => PurchaseDto(
  id: json['id'] as String?,
  invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
  purchaseDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  totalAmount: json['totalAmount'] as num?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => PurchaseItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

PurchaseItemDto _$PurchaseItemDtoFromJson(Map<String, dynamic> json) =>
    PurchaseItemDto(
      medicineId: json['medicineId'] as String?,
      unitId: json['unitId'] as String?,
      unitPrice: json['unitPrice'] as num?,
      quantity: json['quantity'] as num?,
      subTotal: json['subTotal'] as num?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      medicine: json['medicine'] == null
          ? null
          : PurchaseMedicineDto.fromJson(
              json['medicine'] as Map<String, dynamic>,
            ),
      unit: json['unit'] == null
          ? null
          : PurchaseUnitDto.fromJson(json['unit'] as Map<String, dynamic>),
    );

PurchaseMedicineDto _$PurchaseMedicineDtoFromJson(Map<String, dynamic> json) =>
    PurchaseMedicineDto(
      brandName: json['brandName'] as String?,
      genericName: json['genericName'] as String?,
    );

PurchaseUnitDto _$PurchaseUnitDtoFromJson(Map<String, dynamic> json) =>
    PurchaseUnitDto(name: json['name'] as String?);
