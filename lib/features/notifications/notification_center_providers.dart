import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/providers/core_providers.dart';
import 'package:saydaliati/features/notifications/data/notification_remote_data_source.dart';
import 'package:saydaliati/features/notifications/domain/app_notification.dart';

part 'notification_center_providers.g.dart';

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) =>
    NotificationRemoteDataSource(ref.watch(apiClientProvider));

/// Immutable view of the notification center: the list + the unread count.
class NotificationCenterState {
  const NotificationCenterState({this.items = const [], this.unreadCount = 0});

  final List<AppNotification> items;
  final int unreadCount;
}

/// Loads notifications and applies read-state changes with optimistic local
/// updates (so the list/badge react instantly). Kept alive so the unread badge
/// stays warm across tab switches.
@Riverpod(keepAlive: true)
class NotificationCenter extends _$NotificationCenter {
  @override
  Future<NotificationCenterState> build() => _load();

  Future<NotificationCenterState> _load() async {
    final raw = await ref.read(notificationRemoteDataSourceProvider).list();
    final items = ((raw['items'] as List?) ?? const [])
        .map((e) => AppNotification.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    final unread = (raw['unreadCount'] as num?)?.toInt() ?? 0;
    return NotificationCenterState(items: items, unreadCount: unread);
  }

  /// Pull-to-refresh / after a push arrives.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<void> markRead(String id) async {
    final current = state.asData?.value;
    if (current == null) return;
    try {
      final unread = await ref.read(notificationRemoteDataSourceProvider).markRead(id);
      final items = [
        for (final n in current.items) n.id == id ? n.copyWith(isRead: true) : n,
      ];
      state = AsyncData(NotificationCenterState(items: items, unreadCount: unread));
    } catch (_) {
      // leave state unchanged on failure
    }
  }

  Future<void> markAllRead() async {
    final current = state.asData?.value;
    if (current == null) return;
    try {
      await ref.read(notificationRemoteDataSourceProvider).markAllRead();
      final items = [for (final n in current.items) n.copyWith(isRead: true)];
      state = AsyncData(NotificationCenterState(items: items, unreadCount: 0));
    } catch (_) {
      // leave state unchanged on failure
    }
  }
}

/// Unread count for the bell badge — 0 while loading / on error.
@riverpod
int notificationsUnreadCount(Ref ref) =>
    ref.watch(notificationCenterProvider).asData?.value.unreadCount ?? 0;
