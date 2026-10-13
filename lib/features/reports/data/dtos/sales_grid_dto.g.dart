// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_grid_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesGridInvoiceDto _$SalesGridInvoiceDtoFromJson(Map<String, dynamic> json) =>
    SalesGridInvoiceDto(
      saleId: json['saleId'] as String?,
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
      warehouseId: json['warehouseId'] as String?,
      warehouseName: json['warehouseName'] as String?,
      currencyId: json['currencyId'] as String?,
      currencyCode: json['currencyCode'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      originalCurrencyCode: json['originalCurrencyCode'] as String?,
      originalExchangeRate: json['originalExchangeRate'] as num?,
      discountAmount: json['discountAmount'] as num?,
      totalAmount: json['totalAmount'] as num?,
      cost: json['cost'] as num?,
      profit: json['profit'] as num?,
      profitMargin: json['profitMargin'] as num?,
      costMissing: json['costMissing'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SalesGridItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

SalesGridItemDto _$SalesGridItemDtoFromJson(Map<String, dynamic> json) =>
    SalesGridItemDto(
      medicineId: json['medicineId'] as String?,
      brandName: json['brandName'] as String?,
      unitId: json['unitId'] as String?,
      unitName: json['unitName'] as String?,
      quantity: json['quantity'] as num?,
      unitPrice: json['unitPrice'] as num?,
      discount: json['discount'] as num?,
      subTotal: json['subTotal'] as num?,
      unitCost: json['unitCost'] as num?,
      lineCost: json['lineCost'] as num?,
      lineProfit: json['lineProfit'] as num?,
      costMissing: json['costMissing'] as bool?,
    );
