import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Read-only catalog over `pharmacy-api/Permissions`.
class PermissionRemoteDataSource {
  const PermissionRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(ApiEndpoints.permissions);
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
