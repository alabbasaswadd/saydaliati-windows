import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

class PurchaseRemoteDataSource {
  const PurchaseRemoteDataSource(this._api);

  final ApiClient _api;

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.purchases, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.purchaseById(id), data: body);

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.purchases,
      queryParameters: {'limit': limit ?? 50, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final data = await _api.get(ApiEndpoints.purchaseById(id));
    return (data as Map).cast<String, dynamic>();
  }

  Future<void> delete(String id) => _api.delete(ApiEndpoints.purchaseById(id));
}
