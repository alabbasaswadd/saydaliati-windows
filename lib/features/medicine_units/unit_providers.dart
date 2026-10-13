import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/medicine_units/data/datasources/unit_local_data_source.dart';
import 'package:saydaliati/features/medicine_units/data/datasources/unit_remote_data_source.dart';
import 'package:saydaliati/features/medicine_units/data/repositories/unit_repository_impl.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';
import 'package:saydaliati/features/medicine_units/domain/repositories/unit_repository.dart';

part 'unit_providers.g.dart';

@riverpod
UnitRemoteDataSource unitRemoteDataSource(Ref ref) =>
    UnitRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
UnitLocalDataSource unitLocalDataSource(Ref ref) => UnitLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
UnitRepository unitRepository(Ref ref) => UnitRepositoryImpl(
      ref.watch(unitRemoteDataSourceProvider),
      ref.watch(unitLocalDataSourceProvider),
    );

@riverpod
Future<List<Unit>> units(Ref ref) async {
  final result = await ref.watch(unitRepositoryProvider).getUnits();
  return result.fold((list) => list, (failure) => throw failure);
}
