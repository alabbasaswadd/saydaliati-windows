import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchases_grid.freezed.dart';

/// A purchase invoice with its line items, for the tree-grid purchases report
/// (`GET pharmacy-api/Report/purchases-grid`). Amounts are in the base
/// currency. Purchases carry no profit (a purchase is cost).
@freezed
abstract class PurchasesGridInvoice with _$PurchasesGridInvoice {
  const factory PurchasesGridInvoice({
    @Default('') String purchaseId,
    required int invoiceNumber,
    required DateTime purchaseDate,
    @Default('') String supplierName,
    @Default(0) int paymentMethod,
    @Default('') String warehouseName,
    @Default('') String currencyCode,
    @Default('') String currencySymbol,
    @Default(0) double discountAmount,
    @Default(0) double totalAmount,
    @Default(0) int itemsCount,
    @Default(<PurchasesGridItem>[]) List<PurchasesGridItem> items,
  }) = _PurchasesGridInvoice;
}

@freezed
abstract class PurchasesGridItem with _$PurchasesGridItem {
  const factory PurchasesGridItem({
    @Default('') String brandName,
    @Default('') String unitName,
    @Default(0) double quantity,
    @Default(0) double unitPrice,
    @Default(0) double discount,
    @Default(0) double subTotal,
    @Default('') String batchNumber,
    DateTime? expiryDate,
  }) = _PurchasesGridItem;
}
