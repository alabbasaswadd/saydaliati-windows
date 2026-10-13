import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:saydaliati/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:saydaliati/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/customers/domain/repositories/customer_repository.dart';

part 'customer_providers.g.dart';

@riverpod
CustomerRemoteDataSource customerRemoteDataSource(Ref ref) =>
    CustomerRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
CustomerLocalDataSource customerLocalDataSource(Ref ref) =>
    CustomerLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
CustomerRepository customerRepository(Ref ref) => CustomerRepositoryImpl(
      ref.watch(customerRemoteDataSourceProvider),
      ref.watch(customerLocalDataSourceProvider),
    );

@riverpod
Future<List<Customer>> customers(Ref ref) async {
  final result = await ref.watch(customerRepositoryProvider).getCustomers();
  return result.fold((list) => list, (failure) => throw failure);
}
