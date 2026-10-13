import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/Currency` (+ base/exchange-rate actions).
class CurrencyRemoteDataSource {
  const CurrencyRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({int? limit, int? offset}) async {
    final data = await _api.get(
      ApiEndpoints.currencies,
      queryParameters: {'limit': limit ?? 500, 'offset': offset ?? 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.currencies, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.currencyById(id), data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.currencyById(id));

  /// Sets/clears the base currency. The backend binds scalar query params, so
  /// they're encoded into the path.
  Future<void> changeBase(String currencyId, bool isBase) => _api.post(
        '${ApiEndpoints.changeBaseCurrency}'
        '?currencyId=$currencyId&isBaseCurrency=$isBase',
      );

  /// Sets the exchange rate for a currency (scalar query params).
  Future<void> setExchangeRate(String currencyId, double rate) => _api.post(
        '${ApiEndpoints.exchangeRate}'
        '?currencyId=$currencyId&exchangeRate=$rate',
      );

  /// The exchange-rate history for a currency (newest first).
  Future<List<Map<String, dynamic>>> rateHistory(String currencyId) async {
    final data = await _api.get(ApiEndpoints.exchangeRateHistory(currencyId));
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }
}
