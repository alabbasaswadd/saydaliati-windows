import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/features/dashboard/dashboard_providers.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';

part 'dashboard_provider.g.dart';

/// The home dashboard as an [AsyncValue]. It folds the repository's [Result]
/// into async state: a [Failure] is rethrown so it surfaces as `AsyncError`
/// (rendered by `ErrorState.fromError`, including the offline treatment).
///
/// Refresh with `ref.invalidate(dashboardProvider)` or pull-to-refresh.
@riverpod
Future<DashboardSummary> dashboard(Ref ref) async {
  final result = await ref.watch(dashboardRepositoryProvider).getDashboard();
  return result.fold((summary) => summary, (failure) => throw failure);
}
