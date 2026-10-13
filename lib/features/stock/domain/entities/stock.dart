import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';

/// A stock batch of a medicine in a warehouse. Pure domain model (read side).
@freezed
abstract class Stock with _$Stock {
  const factory Stock({
    required String id,
    required String medicineId,
    required String medicineName,
    required double quantityAvailable,
    required double purchasePrice,
    required double sellingPrice,
    DateTime? expiryDate,
    DateTime? dateReceived,
  }) = _Stock;
}

/// Payload for `POST pharmacy-api/Stock` (receiving stock).
class CreateStockInput {
  const CreateStockInput({
    required this.medicineId,
    required this.warehouseId,
    required this.quantityAvailable,
    required this.purchasePrice,
    this.expiryDate,
    this.dateReceived,
  });

  final String medicineId;
  final String warehouseId;
  final double quantityAvailable;
  final double purchasePrice;
  final DateTime? expiryDate;
  final DateTime? dateReceived;

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    return {
      'medicineId': medicineId,
      'warehouseId': warehouseId,
      'quantityAvailable': quantityAvailable,
      'purchasePrice': purchasePrice,
      'expiryDate':
          (expiryDate ?? DateTime(now.year + 2, now.month, now.day))
              .toIso8601String(),
      'dateReceived': (dateReceived ?? now).toIso8601String(),
    };
  }
}

/// Payload for `PUT pharmacy-api/Stock/{id}` (editing an existing stock batch).
/// [sellingPrice] is preserved from the existing batch; the UI edits quantity,
/// purchase price and expiry.
class UpdateStockInput {
  const UpdateStockInput({
    required this.medicineId,
    required this.quantityAvailable,
    required this.purchasePrice,
    required this.sellingPrice,
    this.expiryDate,
  });

  final String medicineId;
  final double quantityAvailable;
  final double purchasePrice;
  final double sellingPrice;
  final DateTime? expiryDate;

  Map<String, dynamic> toJson() {
    final now = DateTime.now();
    return {
      'medicineId': medicineId,
      'quantityAvailable': quantityAvailable,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'expiryDate': (expiryDate ?? DateTime(now.year + 2, now.month, now.day))
          .toIso8601String(),
      'supplierId': null,
    };
  }
}
