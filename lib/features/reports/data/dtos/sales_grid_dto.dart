import 'package:json_annotation/json_annotation.dart';

part 'sales_grid_dto.g.dart';

/// One sales invoice (parent row) from `GET pharmacy-api/Report/sales-grid`.
@JsonSerializable(createToJson: false)
class SalesGridInvoiceDto {
  const SalesGridInvoiceDto({
    this.saleId,
    this.invoiceNumber,
    this.saleDate,
    this.customerId,
    this.customerName,
    this.paymentMethod,
    this.warehouseId,
    this.warehouseName,
    this.currencyId,
    this.currencyCode,
    this.currencySymbol,
    this.originalCurrencyCode,
    this.originalExchangeRate,
    this.discountAmount,
    this.totalAmount,
    this.cost,
    this.profit,
    this.profitMargin,
    this.costMissing,
    this.items,
  });

  final String? saleId;
  final int? invoiceNumber;
  final DateTime? saleDate;
  final String? customerId;
  final String? customerName;
  final int? paymentMethod;
  final String? warehouseId;
  final String? warehouseName;
  final String? currencyId;
  final String? currencyCode;
  final String? currencySymbol;
  final String? originalCurrencyCode;
  final num? originalExchangeRate;
  final num? discountAmount;
  final num? totalAmount;
  final num? cost;
  final num? profit;
  final num? profitMargin;
  final bool? costMissing;
  final List<SalesGridItemDto>? items;

  factory SalesGridInvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$SalesGridInvoiceDtoFromJson(json);
}

/// One line within a sales invoice (child row).
@JsonSerializable(createToJson: false)
class SalesGridItemDto {
  const SalesGridItemDto({
    this.medicineId,
    this.brandName,
    this.unitId,
    this.unitName,
    this.quantity,
    this.unitPrice,
    this.discount,
    this.subTotal,
    this.unitCost,
    this.lineCost,
    this.lineProfit,
    this.costMissing,
  });

  final String? medicineId;
  final String? brandName;
  final String? unitId;
  final String? unitName;
  final num? quantity;
  final num? unitPrice;
  final num? discount;
  final num? subTotal;
  final num? unitCost;
  final num? lineCost;
  final num? lineProfit;
  final bool? costMissing;

  factory SalesGridItemDto.fromJson(Map<String, dynamic> json) =>
      _$SalesGridItemDtoFromJson(json);
}
