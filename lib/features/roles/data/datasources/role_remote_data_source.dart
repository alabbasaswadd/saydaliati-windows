import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/Roles`.
class RoleRemoteDataSource {
  const RoleRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(ApiEndpoints.roles);
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    final data = await _api.post(ApiEndpoints.roles, data: body);
    return (data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> updatePermissions(
      String roleId, List<String> permissionIds) async {
    final data = await _api.put(
      ApiEndpoints.rolePermissions(roleId),
      data: {'permissionIds': permissionIds},
    );
    return (data as Map).cast<String, dynamic>();
  }

  Future<void> delete(String roleId) =>
      _api.delete(ApiEndpoints.roleById(roleId));
}
