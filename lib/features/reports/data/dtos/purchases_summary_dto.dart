import 'package:json_annotation/json_annotation.dart';

part 'purchases_summary_dto.g.dart';

@JsonSerializable(createToJson: false)
class PurchasesSummaryDto {
  const PurchasesSummaryDto({
    this.totalCost,
    this.invoicesCount,
    this.topMedicines,
    this.invoices,
  });

  final num? totalCost;
  final int? invoicesCount;
  final List<PurchaseMedicineBucketDto>? topMedicines;
  final List<PurchaseInvoiceDto>? invoices;

  factory PurchasesSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PurchasesSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseInvoiceDto {
  const PurchaseInvoiceDto({
    this.invoiceNumber,
    this.purchaseDate,
    this.totalAmount,
    this.items,
  });

  final int? invoiceNumber;
  final DateTime? purchaseDate;
  final num? totalAmount;
  final List<PurchaseInvoiceItemDto>? items;

  factory PurchaseInvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseInvoiceDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseInvoiceItemDto {
  const PurchaseInvoiceItemDto({
    this.brandName,
    this.quantity,
    this.unitPrice,
    this.subTotal,
  });

  final String? brandName;
  final num? quantity;
  final num? unitPrice;
  final num? subTotal;

  factory PurchaseInvoiceItemDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseInvoiceItemDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PurchaseMedicineBucketDto {
  const PurchaseMedicineBucketDto({
    this.medicineId,
    this.brandName,
    this.quantity,
    this.cost,
  });

  final String? medicineId;
  final String? brandName;
  final num? quantity;
  final num? cost;

  factory PurchaseMedicineBucketDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseMedicineBucketDtoFromJson(json);
}
