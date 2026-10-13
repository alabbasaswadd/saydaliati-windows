import 'package:saydaliati/core/enums/payment_method.dart';

/// Payload for `POST pharmacy-api/Purchase`. Built in-memory by the purchase
/// screen and serialized straight to the API.
class CreatePurchaseInput {
  const CreatePurchaseInput({
    required this.currencyId,
    required this.warehouseId,
    required this.purchaseDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.lines,
    this.supplierId,
    this.note,
  });

  final String currencyId;
  final String warehouseId;
  final DateTime purchaseDate;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final List<CreatePurchaseLineInput> lines;
  final String? supplierId;
  final String? note;

  Map<String, dynamic> toJson() => {
        'supplierId': supplierId,
        'userId': null,
        'currencyId': currencyId,
        'warehouseId': warehouseId,
        'paymentMethod': paymentMethod.wire,
        'note': note,
        'purchaseDate': purchaseDate.toIso8601String(),
        'totalAmount': totalAmount,
        'items': lines.map((l) => l.toJson(warehouseId)).toList(),
      };

  /// Body for `PUT pharmacy-api/Purchase/{id}` (UpdatePurchaseRequest). The
  /// backend keeps the original currency/payment; amounts are already in base.
  Map<String, dynamic> toUpdateJson(String id) => {
        'supplierId': supplierId,
        'userId': null,
        'purchaseDate': purchaseDate.toIso8601String(),
        'totalAmount': totalAmount,
        'items': [
          for (final l in lines)
            {
              'id': '00000000-0000-0000-0000-000000000000',
              'purchaseId': id,
              'warehouseId': warehouseId,
              'medicineId': l.medicineId,
              'unitId': l.unitId,
              'unitPrice': l.unitPrice,
              'quantity': l.quantity,
              'note': l.note ?? '',
              'expiryDate': l.expiryDate?.toIso8601String(),
            },
        ],
      };
}

class CreatePurchaseLineInput {
  const CreatePurchaseLineInput({
    required this.medicineId,
    required this.unitId,
    required this.unitPrice,
    required this.quantity,
    this.expiryDate,
    this.note,
    this.scannedBarcode,
  });

  final String medicineId;
  final String unitId;
  final double unitPrice;
  final double quantity;
  final DateTime? expiryDate;
  final String? note;

  /// A barcode scanned on this line for a medicine that had none — the backend
  /// fills the medicine's barcode (only if currently empty) when saving.
  final String? scannedBarcode;

  Map<String, dynamic> toJson(String warehouseId) => {
        'warehouseId': warehouseId,
        'medicineId': medicineId,
        'unitId': unitId,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'note': note ?? '',
        'expiryDate': expiryDate?.toIso8601String(),
        'scannedBarcode': scannedBarcode,
      };
}
