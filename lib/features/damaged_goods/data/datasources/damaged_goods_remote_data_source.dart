import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

class DamagedGoodsRemoteDataSource {
  const DamagedGoodsRemoteDataSource(this._api);

  final ApiClient _api;

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.damagedGoods, data: body);
}
