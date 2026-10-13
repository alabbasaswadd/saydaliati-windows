import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_local_data_source.dart';
import 'package:saydaliati/features/stock/data/datasources/stock_remote_data_source.dart';
import 'package:saydaliati/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';
import 'package:saydaliati/features/stock/domain/repositories/stock_repository.dart';

part 'stock_providers.g.dart';

@riverpod
StockRemoteDataSource stockRemoteDataSource(Ref ref) =>
    StockRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
StockLocalDataSource stockLocalDataSource(Ref ref) => StockLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
StockRepository stockRepository(Ref ref) => StockRepositoryImpl(
      ref.watch(stockRemoteDataSourceProvider),
      ref.watch(stockLocalDataSourceProvider),
    );

@riverpod
Future<List<Stock>> stockList(Ref ref) async {
  final result = await ref.watch(stockRepositoryProvider).getStocks();
  return result.fold((list) => list, (failure) => throw failure);
}
