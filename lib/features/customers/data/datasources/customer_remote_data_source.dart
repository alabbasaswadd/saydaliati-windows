import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/Customer` (online-only).
class CustomerRemoteDataSource {
  const CustomerRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.customers,
      queryParameters: {'limit': limit ?? 500, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.customers, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.customerById(id), data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.customerById(id));
}
