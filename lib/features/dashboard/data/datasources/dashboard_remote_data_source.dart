import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/features/dashboard/data/dtos/dashboard_dto.dart';

/// Talks to `GET pharmacy-api/Dashboard`. Returns the parsed DTO or throws an
/// `AppException` (from [ApiClient]) on any transport/business failure.
class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._api);

  final ApiClient _api;

  Future<DashboardDto> getDashboard() async {
    final data = await _api.get(ApiEndpoints.dashboard);
    return DashboardDto.fromJson((data as Map).cast<String, dynamic>());
  }
}
