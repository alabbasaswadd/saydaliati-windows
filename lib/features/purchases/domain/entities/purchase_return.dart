/// One line of a purchase invoice eligible for return to the supplier
/// (`GET PurchaseReturn/returnable-lines/{purchaseId}`). `remainingQuantity`
/// and `availableInStock` are computed on the server — never recomputed
/// client-side. The actually returnable amount is the smaller of the two
/// (part of the batch may already have been sold/consumed).
class PurchaseReturnableLine {
  const PurchaseReturnableLine({
    required this.purchaseItemId,
    required this.medicineId,
    required this.medicineName,
    required this.unitId,
    required this.unitName,
    required this.unitPrice,
    required this.originalQuantity,
    required this.returnedQuantity,
    required this.remainingQuantity,
    required this.availableInStock,
  });

  final String purchaseItemId;
  final String medicineId;
  final String medicineName;
  final String unitId;
  final String unitName;
  final double unitPrice;
  final double originalQuantity;
  final double returnedQuantity;
  final double remainingQuantity;
  final double availableInStock;

  double get maxReturnable =>
      remainingQuantity < availableInStock ? remainingQuantity : availableInStock;
}

/// The request payload for `POST pharmacy-api/PurchaseReturn` — a partial,
/// documented return to the supplier that reverses stock + our debt to them
/// without touching the original invoice.
class CreatePurchaseReturnInput {
  const CreatePurchaseReturnInput({
    required this.purchaseId,
    required this.lines,
    required this.returnDate,
    this.reason,
  });

  final String purchaseId;
  final String? reason;
  final List<PurchaseReturnLineInput> lines;

  /// تاريخ المرتجع — مستقلّ عن تاريخ فاتورة الشراء الأصلية، افتراضياً اليوم.
  final DateTime returnDate;

  Map<String, dynamic> toJson() => {
        'purchaseId': purchaseId,
        'reason': reason,
        'items': lines.map((l) => l.toJson()).toList(),
        'returnDate': returnDate.toUtc().toIso8601String(),
      };
}

class PurchaseReturnLineInput {
  const PurchaseReturnLineInput({required this.purchaseItemId, required this.quantity});

  final String purchaseItemId;
  final double quantity;

  Map<String, dynamic> toJson() => {
        'purchaseItemId': purchaseItemId,
        'quantity': quantity,
      };
}

/// A saved return document (list/history row) — `GET PurchaseReturn` /
/// `GET PurchaseReturn/by-purchase/{purchaseId}`.
class PurchaseReturnSummary {
  const PurchaseReturnSummary({
    required this.id,
    required this.purchaseId,
    required this.purchaseInvoiceNumber,
    required this.returnDate,
    required this.totalAmount,
    required this.itemsCount,
    this.reason,
  });

  final String id;
  final String purchaseId;
  final int purchaseInvoiceNumber;
  final DateTime returnDate;
  final double totalAmount;
  final int itemsCount;
  final String? reason;
}
