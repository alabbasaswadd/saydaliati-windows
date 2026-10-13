import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/stock_movements/data/datasources/stock_movement_remote_data_source.dart';
import 'package:saydaliati/features/stock_movements/data/repositories/stock_movement_repository_impl.dart';
import 'package:saydaliati/features/stock_movements/domain/entities/stock_movement.dart';
import 'package:saydaliati/features/stock_movements/domain/repositories/stock_movement_repository.dart';

part 'stock_movement_providers.g.dart';

@riverpod
StockMovementRemoteDataSource stockMovementRemoteDataSource(Ref ref) =>
    StockMovementRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
StockMovementRepository stockMovementRepository(Ref ref) =>
    StockMovementRepositoryImpl(ref.watch(stockMovementRemoteDataSourceProvider));

@riverpod
Future<List<StockMovement>> stockMovements(
    Ref ref, String? medicineId, String? categoryId,
    [String? fromIso, String? toIso]) async {
  final result = await ref.watch(stockMovementRepositoryProvider).getMovements(
        medicineId: medicineId,
        categoryId: categoryId,
        fromIso: fromIso,
        toIso: toIso,
      );
  return result.fold((list) => list, (failure) => throw failure);
}
