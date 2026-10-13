import 'package:saydaliati/core/enums/stock_movement_type.dart';
import 'package:saydaliati/features/stock_movements/data/dtos/stock_movement_dto.dart';
import 'package:saydaliati/features/stock_movements/domain/entities/stock_movement.dart';

extension StockMovementDtoMapper on StockMovementDto {
  StockMovement toEntity() => StockMovement(
        id: id ?? '',
        medicineId: medicineId ?? '',
        quantityDelta: (quantityDelta ?? 0).toDouble(),
        type: StockMovementType.fromWire(type),
        occurredOn: occurredOn ?? DateTime.now(),
        note: note ?? '',
        medicineName: stock?.medicine?.brandName ??
            stock?.medicine?.genericName ??
            '',
        referenceType: referenceType ?? '',
        // تجاهل التاريخ الافتراضي (0001-01-01) الذي يعني «بلا صلاحية».
        expiryDate: (stock?.expiryDate != null && stock!.expiryDate!.year > 1)
            ? stock!.expiryDate
            : null,
      );
}
