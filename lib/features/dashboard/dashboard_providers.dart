import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:saydaliati/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:saydaliati/features/dashboard/domain/repositories/dashboard_repository.dart';

part 'dashboard_providers.g.dart';

/// Composition root for the dashboard feature — the only place that wires the
/// concrete data classes, exposed as a domain-typed provider. Everything else
/// depends on [DashboardRepository], never the implementation.

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) =>
    DashboardRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
DashboardRepository dashboardRepository(Ref ref) =>
    DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
