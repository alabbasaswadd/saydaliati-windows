/// The kind of stock movement. Mirrors the backend `StockMovementTypeEnum` —
/// serialized as an **integer** (0..5) on the wire.
enum StockMovementType {
  purchaseReceipt,
  purchaseReturn,
  saleIssue,
  saleReturn,
  stockAdjustmentPlus,
  stockAdjustmentMinus;

  int get wire => index; // PurchaseReceipt=0 … StockAdjustmentMinus=5.

  String get label => switch (this) {
        StockMovementType.purchaseReceipt => 'استلام شراء',
        StockMovementType.purchaseReturn => 'مرتجع شراء',
        StockMovementType.saleIssue => 'صرف بيع',
        StockMovementType.saleReturn => 'مرتجع بيع',
        StockMovementType.stockAdjustmentPlus => 'تسوية (زيادة)',
        StockMovementType.stockAdjustmentMinus => 'تسوية (نقص)',
      };

  /// True when the movement increases available stock.
  bool get isIncrease => switch (this) {
        StockMovementType.purchaseReceipt ||
        StockMovementType.saleReturn ||
        StockMovementType.stockAdjustmentPlus =>
          true,
        _ => false,
      };

  static StockMovementType fromWire(int? value) {
    if (value == null || value < 0 || value >= StockMovementType.values.length) {
      return StockMovementType.purchaseReceipt;
    }
    return StockMovementType.values[value];
  }
}
