import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// `pharmacy-api/Stock/adjust` — تسوية جرد دفعة واحدة.
class StockRemoteDataSource {
  const StockRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> adjust(Map<String, dynamic> body) async {
    final data = await _api.post(ApiEndpoints.stockAdjust, data: body);
    return (data as Map).cast<String, dynamic>();
  }
}
