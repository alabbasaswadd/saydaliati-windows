// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovementDto _$StockMovementDtoFromJson(Map<String, dynamic> json) =>
    StockMovementDto(
      id: json['id'] as String?,
      medicineId: json['medicineId'] as String?,
      quantityDelta: json['quantityDelta'] as num?,
      type: (json['type'] as num?)?.toInt(),
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      note: json['note'] as String?,
      referenceType: json['referenceType'] as String?,
      stock: json['stock'] == null
          ? null
          : MovementStockDto.fromJson(json['stock'] as Map<String, dynamic>),
    );

MovementStockDto _$MovementStockDtoFromJson(Map<String, dynamic> json) =>
    MovementStockDto(
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      medicine: json['medicine'] == null
          ? null
          : MovementMedicineDto.fromJson(
              json['medicine'] as Map<String, dynamic>,
            ),
    );

MovementMedicineDto _$MovementMedicineDtoFromJson(Map<String, dynamic> json) =>
    MovementMedicineDto(
      brandName: json['brandName'] as String?,
      genericName: json['genericName'] as String?,
    );
