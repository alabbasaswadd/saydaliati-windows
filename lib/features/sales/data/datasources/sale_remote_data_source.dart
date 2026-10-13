import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Talks to `pharmacy-api/Sale`.
class SaleRemoteDataSource {
  const SaleRemoteDataSource(this._api);

  final ApiClient _api;

  /// POSTs a sale (payload already in wire shape). Returns the created id.
  Future<String?> create(Map<String, dynamic> payload) async {
    final data = await _api.post(ApiEndpoints.sales, data: payload);
    if (data is Map) return data['id'] as String?;
    return null;
  }

  Future<List<Map<String, dynamic>>> list({
    int? limit,
    int? offset,
    String? fromIso,
    String? toIso,
    String? customerId,
    String? medicineId,
    String? currencyId,
    bool? isPrescription,
  }) async {
    final data = await _api.get(
      ApiEndpoints.sales,
      queryParameters: {
        'limit': limit ?? 50,
        'offset': offset ?? 0,
        if (fromIso != null && fromIso.isNotEmpty) 'from': fromIso,
        if (toIso != null && toIso.isNotEmpty) 'to': toIso,
        if (customerId != null && customerId.isNotEmpty) 'customerId': customerId,
        if (medicineId != null && medicineId.isNotEmpty) 'medicineId': medicineId,
        if (currencyId != null && currencyId.isNotEmpty) 'currencyId': currencyId,
        'isPrescription': ?isPrescription,
      },
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final data = await _api.get(ApiEndpoints.saleById(id));
    return (data as Map).cast<String, dynamic>();
  }

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.saleById(id), data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.saleById(id));
}
