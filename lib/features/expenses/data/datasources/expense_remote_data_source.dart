import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/Expense`.
class ExpenseRemoteDataSource {
  const ExpenseRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list({
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    final data = await _api.get(
      ApiEndpoints.expenses,
      queryParameters: {
        'categoryId': ?categoryId,
        'from': ?from?.toIso8601String(),
        'to': ?to?.toIso8601String(),
        'limit': limit ?? 200,
        'offset': offset ?? 0,
      },
    );
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.expenses, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.expenseById(id), data: body);

  Future<void> delete(String id) => _api.delete(ApiEndpoints.expenseById(id));
}
