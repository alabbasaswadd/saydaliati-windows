import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD + كشف حساب فوق `pharmacy-api/Account`.
class AccountRemoteDataSource {
  const AccountRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(
      ApiEndpoints.accounts,
      queryParameters: {'limit': 500, 'offset': 0},
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.accounts, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.accountById(id), data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.accountById(id));

  Future<Map<String, dynamic>> statement(
    String id, {
    DateTime? from,
    DateTime? to,
  }) async {
    final data = await _api.get(
      ApiEndpoints.accountStatement(id),
      queryParameters: {
        'from': ?from?.toIso8601String(),
        'to': ?to?.toIso8601String(),
      },
    );
    return (data as Map).cast<String, dynamic>();
  }
}
