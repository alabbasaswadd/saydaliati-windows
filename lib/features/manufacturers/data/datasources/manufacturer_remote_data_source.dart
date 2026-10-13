import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

class ManufacturerRemoteDataSource {
  const ManufacturerRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.manufacturers,
      queryParameters: {'limit': limit ?? 500, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.manufacturers, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.manufacturerById(id), data: body);

  Future<void> delete(String id) =>
      _api.delete(ApiEndpoints.manufacturerById(id));
}
