import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saydaliati/core/enums/stock_movement_type.dart';

part 'stock_movement.freezed.dart';

/// An audit record of a stock change. Pure domain model (read-only).
@freezed
abstract class StockMovement with _$StockMovement {
  const factory StockMovement({
    required String id,
    required String medicineId,
    required double quantityDelta,
    required StockMovementType type,
    required DateTime occurredOn,
    required String note,
    @Default('') String medicineName,
    @Default('') String referenceType,
    DateTime? expiryDate,
  }) = _StockMovement;
}
