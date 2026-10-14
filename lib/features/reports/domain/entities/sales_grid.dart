import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_grid.freezed.dart';

/// A sales invoice with its line items and profit, for the tree-grid sales
/// report (`GET pharmacy-api/Report/sales-grid`). Amounts are in the base
/// currency. Profit = net total − cost of goods sold (COGS); may be negative.
@freezed
abstract class SalesGridInvoice with _$SalesGridInvoice {
  const factory SalesGridInvoice({
    @Default('') String saleId,
    required int invoiceNumber,
    required DateTime saleDate,
    @Default('') String customerName,
    @Default(0) int paymentMethod,
    @Default('') String warehouseName,
    @Default('') String currencyCode,
    @Default('') String currencySymbol,
    @Default('') String originalCurrencyCode,
    @Default(1) double originalExchangeRate,
    @Default(0) double discountAmount,
    @Default(0) double totalAmount,
    @Default(0) double cost,
    @Default(0) double profit,
    @Default(0) double profitMargin,
    @Default(false) bool costMissing,
    @Default(<SalesGridItem>[]) List<SalesGridItem> items,
  }) = _SalesGridInvoice;
}

@freezed
abstract class SalesGridItem with _$SalesGridItem {
  const factory SalesGridItem({
    @Default('') String brandName,
    @Default('') String unitName,
    @Default(0) double quantity,
    @Default(0) double unitPrice,
    @Default(0) double discount,
    @Default(0) double subTotal,
    @Default(0) double unitCost,
    @Default(0) double lineCost,
    @Default(0) double lineProfit,
    @Default(false) bool costMissing,
  }) = _SalesGridItem;
}
