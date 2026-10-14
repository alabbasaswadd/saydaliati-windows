/// One line of a sale invoice eligible for return (`GET SaleReturn/returnable-lines/{saleId}`).
/// `remainingQuantity` is computed on the server — never recompute it client-side.
class SaleReturnableLine {
  const SaleReturnableLine({
    required this.saleItemId,
    required this.medicineId,
    required this.medicineName,
    required this.unitId,
    required this.unitName,
    required this.unitPrice,
    required this.originalQuantity,
    required this.returnedQuantity,
    required this.remainingQuantity,
  });

  final String saleItemId;
  final String medicineId;
  final String medicineName;
  final String unitId;
  final String unitName;
  final double unitPrice;
  final double originalQuantity;
  final double returnedQuantity;
  final double remainingQuantity;
}

/// The request payload for `POST pharmacy-api/SaleReturn` — a partial, documented
/// return that reverses stock + the customer's debt without touching the
/// original invoice (accounting principle: reverse, never edit history).
class CreateSaleReturnInput {
  const CreateSaleReturnInput({
    required this.saleId,
    required this.lines,
    this.reason,
  });

  final String saleId;
  final String? reason;
  final List<SaleReturnLineInput> lines;

  Map<String, dynamic> toJson() => {
        'saleId': saleId,
        'reason': reason,
        'items': lines.map((l) => l.toJson()).toList(),
      };
}

class SaleReturnLineInput {
  const SaleReturnLineInput({required this.saleItemId, required this.quantity});

  final String saleItemId;
  final double quantity;

  Map<String, dynamic> toJson() => {
        'saleItemId': saleItemId,
        'quantity': quantity,
      };
}

/// A saved return document (list/history row) — `GET SaleReturn` /
/// `GET SaleReturn/by-sale/{saleId}`.
class SaleReturnSummary {
  const SaleReturnSummary({
    required this.id,
    required this.saleId,
    required this.saleInvoiceNumber,
    required this.returnDate,
    required this.totalAmount,
    required this.itemsCount,
    this.reason,
  });

  final String id;
  final String saleId;
  final int saleInvoiceNumber;
  final DateTime returnDate;
  final double totalAmount;
  final int itemsCount;
  final String? reason;
}
