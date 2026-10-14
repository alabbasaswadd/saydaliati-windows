import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// CRUD over `pharmacy-api/ExpenseCategory`.
class ExpenseCategoryRemoteDataSource {
  const ExpenseCategoryRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(ApiEndpoints.expenseCategories);
    final list = (data as List?) ?? const [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> create(Map<String, dynamic> body) =>
      _api.post(ApiEndpoints.expenseCategories, data: body);

  Future<void> update(String id, Map<String, dynamic> body) =>
      _api.put(ApiEndpoints.expenseCategoryById(id), data: body);

  Future<void> delete(String id) =>
      _api.delete(ApiEndpoints.expenseCategoryById(id));
}
