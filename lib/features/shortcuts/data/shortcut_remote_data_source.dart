import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// `pharmacy-api/Shortcut` — تخصيصات اختصارات لوحة المفاتيح.
class ShortcutRemoteDataSource {
  const ShortcutRemoteDataSource(this._api);

  final ApiClient _api;

  /// التخصيصات المخزَّنة فقط (قد تكون فارغة على تثبيت جديد).
  Future<List<Map<String, dynamic>>> list() async {
    final data = await _api.get(ApiEndpoints.shortcuts);
    if (data is! List) return const [];
    return data.cast<Map<String, dynamic>>();
  }

  /// يحفظ الحالة الكاملة: ما لا يَرِد هنا يُحذف تخصيصه على الخادم.
  Future<List<Map<String, dynamic>>> save(
      List<Map<String, dynamic>> items) async {
    final data = await _api.put(ApiEndpoints.shortcuts, data: {'items': items});
    if (data is! List) return const [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> reset() => _api.post(ApiEndpoints.shortcutsReset);
}
