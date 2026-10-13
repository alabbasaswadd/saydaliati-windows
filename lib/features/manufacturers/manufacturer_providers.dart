import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/manufacturers/data/datasources/manufacturer_local_data_source.dart';
import 'package:saydaliati/features/manufacturers/data/datasources/manufacturer_remote_data_source.dart';
import 'package:saydaliati/features/manufacturers/data/repositories/manufacturer_repository_impl.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';
import 'package:saydaliati/features/manufacturers/domain/repositories/manufacturer_repository.dart';

part 'manufacturer_providers.g.dart';

@riverpod
ManufacturerRemoteDataSource manufacturerRemoteDataSource(Ref ref) =>
    ManufacturerRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
ManufacturerLocalDataSource manufacturerLocalDataSource(Ref ref) =>
    ManufacturerLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
ManufacturerRepository manufacturerRepository(Ref ref) =>
    ManufacturerRepositoryImpl(
      ref.watch(manufacturerRemoteDataSourceProvider),
      ref.watch(manufacturerLocalDataSourceProvider),
    );

@riverpod
Future<List<Manufacturer>> manufacturers(Ref ref) async {
  final result =
      await ref.watch(manufacturerRepositoryProvider).getManufacturers();
  return result.fold((list) => list, (failure) => throw failure);
}
