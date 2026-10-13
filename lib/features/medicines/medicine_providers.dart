import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/medicines/data/datasources/medicine_local_data_source.dart';
import 'package:saydaliati/features/medicines/data/datasources/medicine_remote_data_source.dart';
import 'package:saydaliati/features/medicines/data/repositories/medicine_repository_impl.dart';
import 'package:saydaliati/features/medicines/domain/repositories/medicine_repository.dart';

part 'medicine_providers.g.dart';

/// Composition root for the medicines feature.

@riverpod
MedicineRemoteDataSource medicineRemoteDataSource(Ref ref) =>
    MedicineRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
MedicineLocalDataSource medicineLocalDataSource(Ref ref) =>
    MedicineLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
MedicineRepository medicineRepository(Ref ref) => MedicineRepositoryImpl(
      ref.watch(medicineRemoteDataSourceProvider),
      ref.watch(medicineLocalDataSourceProvider),
    );
