import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/offline/offline_providers.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/currencies/data/datasources/currency_local_data_source.dart';
import 'package:saydaliati/features/currencies/data/datasources/currency_remote_data_source.dart';
import 'package:saydaliati/features/currencies/data/repositories/currency_repository_impl.dart';
import 'package:saydaliati/features/currencies/domain/repositories/currency_repository.dart';

part 'currency_providers.g.dart';

/// Composition root for the currencies feature.

@riverpod
CurrencyRemoteDataSource currencyRemoteDataSource(Ref ref) =>
    CurrencyRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
CurrencyLocalDataSource currencyLocalDataSource(Ref ref) =>
    CurrencyLocalDataSource(
      db: ref.watch(appDatabaseProvider),
      tenantId: ref.watch(currentTenantKeyProvider),
    );

@riverpod
CurrencyRepository currencyRepository(Ref ref) => CurrencyRepositoryImpl(
      ref.watch(currencyRemoteDataSourceProvider),
      ref.watch(currencyLocalDataSourceProvider),
    );
