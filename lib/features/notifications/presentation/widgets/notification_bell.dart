import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/features/notifications/notification_center_providers.dart';

/// App-bar bell that opens the notification center and shows the unread count.
/// Drop into any AppBar `actions:` so the entry point is always in the header.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(notificationsUnreadCountProvider);
    return IconButton(
      tooltip: 'الإشعارات',
      onPressed: () => context.push(AppRoutes.notifications),
      icon: Badge.count(
        count: unread,
        isLabelVisible: unread > 0,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
