// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfitReportDto _$ProfitReportDtoFromJson(Map<String, dynamic> json) =>
    ProfitReportDto(
      totalRevenue: json['totalRevenue'] as num?,
      totalCost: json['totalCost'] as num?,
      totalProfit: json['totalProfit'] as num?,
      invoicesCount: (json['invoicesCount'] as num?)?.toInt(),
      byCurrency: (json['byCurrency'] as List<dynamic>?)
          ?.map((e) => ProfitByCurrencyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoices: (json['invoices'] as List<dynamic>?)
          ?.map((e) => ProfitInvoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ProfitByCurrencyDto _$ProfitByCurrencyDtoFromJson(Map<String, dynamic> json) =>
    ProfitByCurrencyDto(
      currencyId: json['currencyId'] as String?,
      currencyCode: json['currencyCode'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      invoicesCount: (json['invoicesCount'] as num?)?.toInt(),
      revenue: json['revenue'] as num?,
      cost: json['cost'] as num?,
      profit: json['profit'] as num?,
    );

ProfitInvoiceDto _$ProfitInvoiceDtoFromJson(Map<String, dynamic> json) =>
    ProfitInvoiceDto(
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
      currencyCode: json['currencyCode'] as String?,
      paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
      revenue: json['revenue'] as num?,
      cost: json['cost'] as num?,
      profit: json['profit'] as num?,
      originalCurrencyCode: json['originalCurrencyCode'] as String?,
      originalExchangeRate: json['originalExchangeRate'] as num?,
    );
