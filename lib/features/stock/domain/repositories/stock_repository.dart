import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';

/// Stock (inventory) — read list + receive/remove batches. Online-only.
abstract interface class StockRepository {
  Future<Result<List<Stock>>> getStocks({int? limit, int? offset});
  Future<Result<void>> create(CreateStockInput input);
  Future<Result<void>> update(String id, UpdateStockInput input);
  Future<Result<void>> delete(String id);
}
