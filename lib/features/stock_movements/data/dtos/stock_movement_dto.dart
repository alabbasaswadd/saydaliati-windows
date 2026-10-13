import 'package:json_annotation/json_annotation.dart';

part 'stock_movement_dto.g.dart';

@JsonSerializable(createToJson: false)
class StockMovementDto {
  const StockMovementDto({
    this.id,
    this.medicineId,
    this.quantityDelta,
    this.type,
    this.occurredOn,
    this.note,
    this.referenceType,
    this.stock,
  });

  final String? id;
  final String? medicineId;
  final num? quantityDelta;
  final int? type;
  final DateTime? occurredOn;
  final String? note;
  final String? referenceType;
  final MovementStockDto? stock;

  factory StockMovementDto.fromJson(Map<String, dynamic> json) =>
      _$StockMovementDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MovementStockDto {
  const MovementStockDto({this.expiryDate, this.medicine});

  final DateTime? expiryDate;
  final MovementMedicineDto? medicine;

  factory MovementStockDto.fromJson(Map<String, dynamic> json) =>
      _$MovementStockDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MovementMedicineDto {
  const MovementMedicineDto({this.brandName, this.genericName});

  final String? brandName;
  final String? genericName;

  factory MovementMedicineDto.fromJson(Map<String, dynamic> json) =>
      _$MovementMedicineDtoFromJson(json);
}
