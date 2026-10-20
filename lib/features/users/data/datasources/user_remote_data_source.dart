import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/Users`.
class UserRemoteDataSource {
  const UserRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(ApiEndpoints.users);
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final data = await _api.post(ApiEndpoints.users, data: body);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> assignRole(String id, String roleId) async {
    final data =
        await _api.put(ApiEndpoints.userRole(id), data: {'roleId': roleId});
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> setActive(String id, bool isActive) async {
    final data = await _api
        .put(ApiEndpoints.userActive(id), data: {'isActive': isActive});
    return (data as Map).cast<String, dynamic>();
  }
}
