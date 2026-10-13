import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/stock_movements/domain/entities/stock_movement.dart';

abstract interface class StockMovementRepository {
  Future<Result<List<StockMovement>>> getMovements(
      {int? limit,
      int? offset,
      String? medicineId,
      String? categoryId,
      String? fromIso,
      String? toIso});
}
