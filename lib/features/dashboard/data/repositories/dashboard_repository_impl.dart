import 'package:saydaliati/core/errors/failure_mapper.dart';
import 'package:saydaliati/core/result/result.dart';
import 'package:saydaliati/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:saydaliati/features/dashboard/data/mappers/dashboard_mapper.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:saydaliati/features/dashboard/domain/repositories/dashboard_repository.dart';

/// The only place data-layer exceptions become a domain [Failure]: the remote
/// source throws `AppException`, and this catch maps it so nothing infrastructural
/// leaks past the boundary. The presentation layer only ever sees `Result`.
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<Result<DashboardSummary>> getDashboard() async {
    try {
      final dto = await _remote.getDashboard();
      return Result.success(dto.toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }

  @override
  Future<Result<DashboardProfit>> getProfit(String period) async {
    try {
      final dto = await _remote.getProfit(period);
      return Result.success(dto.toEntity());
    } catch (error) {
      return Result.failure(mapExceptionToFailure(error));
    }
  }
}
