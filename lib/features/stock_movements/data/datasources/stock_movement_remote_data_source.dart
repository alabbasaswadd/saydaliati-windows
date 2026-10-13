import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

class StockMovementRemoteDataSource {
  const StockMovementRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({
    int? limit,
    int? offset,
    String? medicineId,
    String? categoryId,
    String? fromIso,
    String? toIso,
  }) async {
    final data = await _api.get(
      ApiEndpoints.stockMovements,
      queryParameters: {
        'limit': limit ?? 100,
        'offset': offset ?? 0,
        if (medicineId != null && medicineId.isNotEmpty) 'medicineId': medicineId,
        if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
        if (fromIso != null && fromIso.isNotEmpty) 'from': fromIso,
        if (toIso != null && toIso.isNotEmpty) 'to': toIso,
      },
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
