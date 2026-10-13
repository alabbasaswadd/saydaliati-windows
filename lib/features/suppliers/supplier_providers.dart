import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/suppliers/data/datasources/supplier_remote_data_source.dart';
import 'package:saydaliati/features/suppliers/data/repositories/supplier_repository_impl.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/domain/repositories/supplier_repository.dart';

part 'supplier_providers.g.dart';

@riverpod
SupplierRemoteDataSource supplierRemoteDataSource(Ref ref) =>
    SupplierRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
SupplierRepository supplierRepository(Ref ref) =>
    SupplierRepositoryImpl(ref.watch(supplierRemoteDataSourceProvider));

@riverpod
Future<List<Supplier>> suppliers(Ref ref) async {
  final result = await ref.watch(supplierRepositoryProvider).getSuppliers();
  return result.fold((list) => list, (failure) => throw failure);
}
