import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Talks to `pharmacy-api/PurchaseReturn`.
class PurchaseReturnRemoteDataSource {
  const PurchaseReturnRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> returnableLines(String purchaseId) async {
    final data = await _api.get(ApiEndpoints.purchaseReturnableLines(purchaseId));
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.purchaseReturns, data: payload);

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.purchaseReturns,
      queryParameters: {'limit': limit ?? 50, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
