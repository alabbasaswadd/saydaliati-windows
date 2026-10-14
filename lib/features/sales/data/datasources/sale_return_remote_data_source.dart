import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Talks to `pharmacy-api/SaleReturn`.
class SaleReturnRemoteDataSource {
  const SaleReturnRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> returnableLines(String saleId) async {
    final data = await _api.get(ApiEndpoints.saleReturnableLines(saleId));
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> payload) =>
      _api.post(ApiEndpoints.saleReturns, data: payload);

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.saleReturns,
      queryParameters: {'limit': limit ?? 50, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
