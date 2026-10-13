import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_local_data_source.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_remote_data_source.dart';
import 'package:saydaliati/features/stock/data/dtos/stock_dto.dart';
import 'package:saydaliati/features/stock/data/mappers/stock_mapper.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';
import 'package:saydaliati/features/stock/domain/repositories/stock_repository.dart';

/// Cache-first stock: refresh from the server when online (and warm the local
/// cache); fall back to the on-device cache otherwise. Writes are online-only.
class StockRepositoryImpl implements StockRepository {
  const StockRepositoryImpl(this._remote, this._local);

  final StockRemoteDataSource _remote;
  final StockLocalDataSource _local;

  @override
  Future<Result<List<Stock>>> getStocks({int? limit, int? offset}) async {
    try {
      final raw = await _remote.list(limit: limit, offset: offset);
      // Warm the whole cache only on an unpaged load, so paging can't wipe it.
      if (offset == null || offset == 0) {
        await _local.replaceAll(raw);
      }
      return Result.success(
          raw.map((m) => StockDto.fromJson(m).toEntity()).toList());
    } catch (error) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) {
        return Result.success(
            cached.map((m) => StockDto.fromJson(m).toEntity()).toList());
      }
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<void>> create(CreateStockInput input) => _guard(
        () => _remote.create(input.toJson()),
      );

  @override
  Future<Result<void>> update(String id, UpdateStockInput input) =>
      _guard(() => _remote.update(id, input.toJson()));

  @override
  Future<Result<void>> delete(String id) => _guard(() => _remote.delete(id));

  Future<Result<void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
