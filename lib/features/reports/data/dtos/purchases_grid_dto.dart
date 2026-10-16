import 'package:json_annotation/json_annotation.dart';

part 'purchases_grid_dto.g.dart';

/// One purchase invoice (parent row) from `GET pharmacy-api/Report/purchases-grid`.
@JsonSerializable(createToJson: false)
class PurchasesGridInvoiceDto {
  const PurchasesGridInvoiceDto({
    this.purchaseId,
    this.invoiceNumber,
    this.purchaseDate,
    this.supplierId,
    this.supplierName,
    this.paymentMethod,
    this.warehouseId,
    this.warehouseName,
    this.currencyId,
    this.currencyCode,
    this.currencySymbol,
    this.discountAmount,
    this.totalAmount,
    this.itemsCount,
    this.bonusQuantity,
    this.items,
  });

  final String? purchaseId;
  final int? invoiceNumber;
  final DateTime? purchaseDate;
  final String? supplierId;
  final String? supplierName;
  final int? paymentMethod;
  final String? warehouseId;
  final String? warehouseName;
  final String? currencyId;
  final String? currencyCode;
  final String? currencySymbol;
  final num? discountAmount;
  final num? totalAmount;
  final int? itemsCount;
  final num? bonusQuantity;
  final List<PurchasesGridItemDto>? items;

  factory PurchasesGridInvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$PurchasesGridInvoiceDtoFromJson(json);
}

/// One line within a purchase invoice (child row).
@JsonSerializable(createToJson: false)
class PurchasesGridItemDto {
  const PurchasesGridItemDto({
    this.medicineId,
    this.brandName,
    this.unitId,
    this.unitName,
    this.quantity,
    this.bonusQuantity,
    this.unitPrice,
    this.discount,
    this.subTotal,
    this.batchNumber,
    this.expiryDate,
  });

  final String? medicineId;
  final String? brandName;
  final String? unitId;
  final String? unitName;
  final num? quantity;
  final num? bonusQuantity;
  final num? unitPrice;
  final num? discount;
  final num? subTotal;
  final String? batchNumber;
  final DateTime? expiryDate;

  factory PurchasesGridItemDto.fromJson(Map<String, dynamic> json) =>
      _$PurchasesGridItemDtoFromJson(json);
}
