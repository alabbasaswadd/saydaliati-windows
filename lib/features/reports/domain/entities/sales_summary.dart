import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_summary.freezed.dart';

/// Sales summary for a period from `GET pharmacy-api/Report/sales-summary`.
@freezed
abstract class SalesSummary with _$SalesSummary {
  const factory SalesSummary({
    required double totalRevenue,
    required int invoicesCount,
    @Default(0) double costOfGoods,
    @Default(0) double grossProfit,
    @Default(<PaymentMethodBucket>[]) List<PaymentMethodBucket> byPaymentMethod,
    @Default(<TopMedicineSales>[]) List<TopMedicineSales> topMedicines,
  }) = _SalesSummary;
}

@freezed
abstract class PaymentMethodBucket with _$PaymentMethodBucket {
  const factory PaymentMethodBucket({
    required int paymentMethod,
    required int count,
    required double total,
  }) = _PaymentMethodBucket;
}

@freezed
abstract class TopMedicineSales with _$TopMedicineSales {
  const factory TopMedicineSales({
    required String medicineId,
    required String brandName,
    required double quantitySold,
    required double revenue,
  }) = _TopMedicineSales;
}
