import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchases_summary.freezed.dart';

/// Purchases summary for a period from `GET pharmacy-api/Report/purchases-summary`.
@freezed
abstract class PurchasesSummary with _$PurchasesSummary {
  const factory PurchasesSummary({
    required double totalCost,
    required int invoicesCount,
    @Default(<PurchaseMedicineBucket>[])
    List<PurchaseMedicineBucket> topMedicines,
    @Default(<PurchaseInvoice>[]) List<PurchaseInvoice> invoices,
  }) = _PurchasesSummary;
}

@freezed
abstract class PurchaseInvoice with _$PurchaseInvoice {
  const factory PurchaseInvoice({
    required int invoiceNumber,
    required DateTime purchaseDate,
    required double totalAmount,
    @Default(<PurchaseInvoiceLine>[]) List<PurchaseInvoiceLine> items,
  }) = _PurchaseInvoice;
}

@freezed
abstract class PurchaseInvoiceLine with _$PurchaseInvoiceLine {
  const factory PurchaseInvoiceLine({
    required String brandName,
    required double quantity,
    required double unitPrice,
    required double subTotal,
  }) = _PurchaseInvoiceLine;
}

@freezed
abstract class PurchaseMedicineBucket with _$PurchaseMedicineBucket {
  const factory PurchaseMedicineBucket({
    required String medicineId,
    required String brandName,
    required double quantity,
    required double cost,
  }) = _PurchaseMedicineBucket;
}
