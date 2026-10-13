import 'package:json_annotation/json_annotation.dart';

part 'profit_report_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfitReportDto {
  const ProfitReportDto({
    this.totalRevenue,
    this.totalCost,
    this.totalProfit,
    this.invoicesCount,
    this.byCurrency,
    this.invoices,
  });

  final num? totalRevenue;
  final num? totalCost;
  final num? totalProfit;
  final int? invoicesCount;
  final List<ProfitByCurrencyDto>? byCurrency;
  final List<ProfitInvoiceDto>? invoices;

  factory ProfitReportDto.fromJson(Map<String, dynamic> json) =>
      _$ProfitReportDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProfitByCurrencyDto {
  const ProfitByCurrencyDto({
    this.currencyId,
    this.currencyCode,
    this.currencySymbol,
    this.invoicesCount,
    this.revenue,
    this.cost,
    this.profit,
  });

  final String? currencyId;
  final String? currencyCode;
  final String? currencySymbol;
  final int? invoicesCount;
  final num? revenue;
  final num? cost;
  final num? profit;

  factory ProfitByCurrencyDto.fromJson(Map<String, dynamic> json) =>
      _$ProfitByCurrencyDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProfitInvoiceDto {
  const ProfitInvoiceDto({
    this.invoiceNumber,
    this.saleDate,
    this.currencyCode,
    this.paymentMethod,
    this.revenue,
    this.cost,
    this.profit,
    this.originalCurrencyCode,
    this.originalExchangeRate,
  });

  final int? invoiceNumber;
  final DateTime? saleDate;
  final String? currencyCode;
  final int? paymentMethod;
  final num? revenue;
  final num? cost;
  final num? profit;
  final String? originalCurrencyCode;
  final num? originalExchangeRate;

  factory ProfitInvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$ProfitInvoiceDtoFromJson(json);
}
