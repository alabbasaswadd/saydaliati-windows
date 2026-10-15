import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/notifications/notification_center_providers.dart';

/// Bell that opens the notification center and shows the unread count.
/// It lives in the desktop title bar, so the entry point is in the app header
/// on every screen instead of being repeated per page AppBar.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({this.compact = false, super.key});

  /// نسخة شريط العنوان (ارتفاعه 40px): أيقونة أصغر بلا حشوة زائدة، بنفس
  /// مقاس زر المزامنة المجاور.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(notificationsUnreadCountProvider);
    return IconButton(
      tooltip: 'الإشعارات',
      iconSize: compact ? AppSizes.iconSm : null,
      constraints: compact
          ? const BoxConstraints(minWidth: 34, minHeight: 34)
          : null,
      padding: compact ? EdgeInsets.zero : null,
      onPressed: () => context.push(AppRoutes.notifications),
      icon: Badge.count(
        count: unread,
        isLabelVisible: unread > 0,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
