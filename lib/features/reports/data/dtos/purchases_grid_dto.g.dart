// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_grid_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasesGridInvoiceDto _$PurchasesGridInvoiceDtoFromJson(
  Map<String, dynamic> json,
) => PurchasesGridInvoiceDto(
  purchaseId: json['purchaseId'] as String?,
  invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
  purchaseDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  supplierId: json['supplierId'] as String?,
  supplierName: json['supplierName'] as String?,
  paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
  warehouseId: json['warehouseId'] as String?,
  warehouseName: json['warehouseName'] as String?,
  currencyId: json['currencyId'] as String?,
  currencyCode: json['currencyCode'] as String?,
  currencySymbol: json['currencySymbol'] as String?,
  discountAmount: json['discountAmount'] as num?,
  totalAmount: json['totalAmount'] as num?,
  itemsCount: (json['itemsCount'] as num?)?.toInt(),
  bonusQuantity: json['bonusQuantity'] as num?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => PurchasesGridItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

PurchasesGridItemDto _$PurchasesGridItemDtoFromJson(
  Map<String, dynamic> json,
) => PurchasesGridItemDto(
  medicineId: json['medicineId'] as String?,
  brandName: json['brandName'] as String?,
  unitId: json['unitId'] as String?,
  unitName: json['unitName'] as String?,
  quantity: json['quantity'] as num?,
  bonusQuantity: json['bonusQuantity'] as num?,
  unitPrice: json['unitPrice'] as num?,
  discount: json['discount'] as num?,
  subTotal: json['subTotal'] as num?,
  batchNumber: json['batchNumber'] as String?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
);
