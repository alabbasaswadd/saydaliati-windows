import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/purchases/data/datasources/purchase_remote_data_source.dart';
import 'package:saydaliati/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/domain/repositories/purchase_repository.dart';

part 'purchase_providers.g.dart';

@riverpod
PurchaseRemoteDataSource purchaseRemoteDataSource(Ref ref) =>
    PurchaseRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
PurchaseRepository purchaseRepository(Ref ref) =>
    PurchaseRepositoryImpl(ref.watch(purchaseRemoteDataSourceProvider));

@riverpod
Future<List<Purchase>> purchasesList(Ref ref) async {
  final result = await ref.watch(purchaseRepositoryProvider).getPurchases();
  return result.fold((list) => list, (failure) => throw failure);
}
