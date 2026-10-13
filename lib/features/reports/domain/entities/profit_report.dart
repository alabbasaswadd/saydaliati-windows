import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_report.freezed.dart';

/// Profit report for a period from `GET pharmacy-api/Report/profit`.
@freezed
abstract class ProfitReport with _$ProfitReport {
  const factory ProfitReport({
    @Default(0) double totalRevenue,
    @Default(0) double totalCost,
    @Default(0) double totalProfit,
    @Default(0) int invoicesCount,
    @Default(<ProfitByCurrency>[]) List<ProfitByCurrency> byCurrency,
    @Default(<ProfitInvoice>[]) List<ProfitInvoice> invoices,
  }) = _ProfitReport;
}

@freezed
abstract class ProfitByCurrency with _$ProfitByCurrency {
  const factory ProfitByCurrency({
    required String currencyId,
    required String currencyCode,
    required String currencySymbol,
    required int invoicesCount,
    required double revenue,
    required double cost,
    required double profit,
  }) = _ProfitByCurrency;
}

@freezed
abstract class ProfitInvoice with _$ProfitInvoice {
  const factory ProfitInvoice({
    required int invoiceNumber,
    required DateTime saleDate,
    required String currencyCode,
    required int paymentMethod,
    required double revenue,
    required double cost,
    required double profit,
    @Default('') String originalCurrencyCode,
    @Default(1) double originalExchangeRate,
  }) = _ProfitInvoice;
}
