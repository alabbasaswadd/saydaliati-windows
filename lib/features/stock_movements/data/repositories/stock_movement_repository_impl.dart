import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/stock_movements/data/datasources/stock_movement_remote_data_source.dart';
import 'package:saydaliati/features/stock_movements/data/dtos/stock_movement_dto.dart';
import 'package:saydaliati/features/stock_movements/data/mappers/stock_movement_mapper.dart';
import 'package:saydaliati/features/stock_movements/domain/entities/stock_movement.dart';
import 'package:saydaliati/features/stock_movements/domain/repositories/stock_movement_repository.dart';

class StockMovementRepositoryImpl implements StockMovementRepository {
  const StockMovementRepositoryImpl(this._remote);

  final StockMovementRemoteDataSource _remote;

  @override
  Future<Result<List<StockMovement>>> getMovements(
      {int? limit,
      int? offset,
      String? medicineId,
      String? categoryId,
      String? fromIso,
      String? toIso}) async {
    try {
      final raw = await _remote.list(
          limit: limit,
          offset: offset,
          medicineId: medicineId,
          categoryId: categoryId,
          fromIso: fromIso,
          toIso: toIso);
      return Result.success(
          raw.map((m) => StockMovementDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
