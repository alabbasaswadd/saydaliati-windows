// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasesSummaryDto _$PurchasesSummaryDtoFromJson(Map<String, dynamic> json) =>
    PurchasesSummaryDto(
      totalCost: json['totalCost'] as num?,
      invoicesCount: (json['invoicesCount'] as num?)?.toInt(),
      topMedicines: (json['topMedicines'] as List<dynamic>?)
          ?.map(
            (e) =>
                PurchaseMedicineBucketDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((e) => PurchaseInvoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

PurchaseInvoiceDto _$PurchaseInvoiceDtoFromJson(Map<String, dynamic> json) =>
    PurchaseInvoiceDto(
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      totalAmount: json['totalAmount'] as num?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => PurchaseInvoiceItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

PurchaseInvoiceItemDto _$PurchaseInvoiceItemDtoFromJson(
  Map<String, dynamic> json,
) => PurchaseInvoiceItemDto(
  brandName: json['brandName'] as String?,
  quantity: json['quantity'] as num?,
  unitPrice: json['unitPrice'] as num?,
  subTotal: json['subTotal'] as num?,
);

PurchaseMedicineBucketDto _$PurchaseMedicineBucketDtoFromJson(
  Map<String, dynamic> json,
) => PurchaseMedicineBucketDto(
  medicineId: json['medicineId'] as String?,
  brandName: json['brandName'] as String?,
  quantity: json['quantity'] as num?,
  cost: json['cost'] as num?,
);
