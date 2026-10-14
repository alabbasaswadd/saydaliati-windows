import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase.freezed.dart';

/// A purchase invoice (read side).
@freezed
abstract class Purchase with _$Purchase {
  const factory Purchase({
    required String id,
    required DateTime purchaseDate,
    required double totalAmount,
    @Default(0) int invoiceNumber,
    @Default(<PurchaseLine>[]) List<PurchaseLine> items,
  }) = _Purchase;
}

@freezed
abstract class PurchaseLine with _$PurchaseLine {
  const factory PurchaseLine({
    required String medicineName,
    required String unitName,
    required double unitPrice,
    required double quantity,
    required double subTotal,
    @Default('') String medicineId,
    @Default('') String unitId,
    DateTime? expiryDate,
  }) = _PurchaseLine;
}
