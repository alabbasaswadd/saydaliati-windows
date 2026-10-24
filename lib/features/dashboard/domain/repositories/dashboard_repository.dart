import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';

/// Contract for reading the home dashboard snapshot. Implemented in the data
/// layer; the presentation layer depends only on this.
abstract interface class DashboardRepository {
  Future<Result<DashboardSummary>> getDashboard();
  Future<Result<DashboardProfit>> getProfit(String period);
}
