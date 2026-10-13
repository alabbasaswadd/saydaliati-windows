import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';

/// Talks to the backend notification endpoints. Returns unwrapped payloads and
/// throws clean `AppException`s (envelope + Dio handling live in [ApiClient]).
class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._api);

  final ApiClient _api;

  /// GET list → `{ unreadCount, items: [...] }`.
  Future<Map<String, dynamic>> list({int limit = 50, int offset = 0}) async {
    final data = await _api.get(
      ApiEndpoints.notifications,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return (data as Map).cast<String, dynamic>();
  }

  /// Mark one as read → returns the new unread count.
  Future<int> markRead(String id) async {
    final data = await _api.post(ApiEndpoints.notificationRead(id));
    return _unread(data);
  }

  /// Mark all as read → returns the new unread count (0).
  Future<int> markAllRead() async {
    final data = await _api.post(ApiEndpoints.notificationsReadAll);
    return _unread(data);
  }

  int _unread(dynamic data) =>
      data is Map ? ((data['unreadCount'] as num?)?.toInt() ?? 0) : 0;
}
