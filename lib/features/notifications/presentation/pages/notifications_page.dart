import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/notifications/domain/app_notification.dart';
import 'package:saydaliati/features/notifications/notification_center_providers.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Notification center. A clean, grouped list that clearly marks system notices
/// apart from business ones, highlights unread items, and lets the user mark one
/// (tap) or all (app-bar action) as read.
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationCenterProvider);
    final unread = async.asData?.value?.unreadCount ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          if (unread > 0)
            TextButton.icon(
              onPressed: () =>
                  ref.read(notificationCenterProvider.notifier).markAllRead(),
              icon: const Icon(Icons.done_all, size: 20),
              label: const Text('تمييز الكل'),
            ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.read(notificationCenterProvider.notifier).refresh(),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_outlined,
              message: 'لا توجد إشعارات',
            );
          }
          final theme = Theme.of(context);
          final groups = _groupByDate(state.items);
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(notificationCenterProvider.notifier).refresh(),
            // أقسام (اليوم / أمس / أقدم): كل قسم بإطار بسيط خاص به — فتُفصل
            // الأقسام عن بعضها بالبوردر، وداخل كل قسم بوردر رفيع بين الإشعارات.
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final (label, items) in groups) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppSpacing.sm, top: AppSpacing.md),
                    child: Text(label,
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: context.semantic.textSecondary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.brSm,
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: theme.dividerColor),
                          _NotificationTile(
                            notification: items[i],
                            onTap: () => _onTap(context, ref, items[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// يُقسّم الإشعارات إلى أقسام زمنية (اليوم / أمس / أقدم) مع الحفاظ على ترتيبها.
List<(String, List<AppNotification>)> _groupByDate(List<AppNotification> items) {
  final now = DateTime.now();
  final today = <AppNotification>[];
  final yesterday = <AppNotification>[];
  final earlier = <AppNotification>[];
  for (final n in items) {
    final d = n.createdOn;
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(d.year, d.month, d.day))
        .inDays;
    if (diff <= 0) {
      today.add(n);
    } else if (diff == 1) {
      yesterday.add(n);
    } else {
      earlier.add(n);
    }
  }
  return [
    if (today.isNotEmpty) ('اليوم', today),
    if (yesterday.isNotEmpty) ('أمس', yesterday),
    if (earlier.isNotEmpty) ('أقدم', earlier),
  ];
}

/// Mark the notification read and, if it carries a link (e.g. a video), open it.
Future<void> _onTap(BuildContext context, WidgetRef ref, AppNotification n) async {
  ref.read(notificationCenterProvider.notifier).markRead(n.id);
  final url = n.linkUrl;
  if (url != null) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _TypeStyle.of(context, notification.type);
    final unread = !notification.isRead;
    final isSystem = notification.type.isSystem;

    return Material(
      color: unread
          ? style.color.withValues(alpha: 0.06)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type avatar — system gets a filled badge, others a tinted one.
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSystem ? style.color : style.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  style.icon,
                  color: isSystem ? Colors.white : style.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _TypeChip(label: style.label, color: style.color, filled: isSystem),
                        const Spacer(),
                        Text(
                          _timeAgo(notification.createdOn),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: context.semantic.textSecondary),
                        ),
                        if (unread) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: style.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    if (notification.body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        notification.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: context.semantic.textSecondary),
                      ),
                    ],
                    // Tappable cue when the notification carries a link (video).
                    if (notification.linkUrl != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_fill, size: 18, color: style.color),
                          const SizedBox(width: 4),
                          Text(
                            'مشاهدة الفيديو',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: style.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small pill labelling the notification type. System = filled (stands out).
class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, required this.color, required this.filled});

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.12),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: filled ? Colors.white : color,
        ),
      ),
    );
  }
}

/// Resolves a notification type to its icon, color and Arabic label — the single
/// place that defines how each kind looks.
class _TypeStyle {
  const _TypeStyle(this.icon, this.color, this.label);

  final IconData icon;
  final Color color;
  final String label;

  static _TypeStyle of(BuildContext context, NotificationType type) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    switch (type) {
      case NotificationType.system:
        return _TypeStyle(Icons.campaign_rounded, scheme.primary, 'النظام');
      case NotificationType.sale:
        return _TypeStyle(Icons.point_of_sale_outlined, semantic.success, 'مبيعات');
      case NotificationType.purchase:
        return _TypeStyle(Icons.shopping_cart_outlined, semantic.info, 'مشتريات');
      case NotificationType.stock:
        return _TypeStyle(Icons.inventory_2_outlined, semantic.warning, 'المخزون');
      case NotificationType.expiry:
        return _TypeStyle(Icons.event_busy_outlined, scheme.error, 'انتهاء صلاحية');
      case NotificationType.account:
        return _TypeStyle(
            Icons.account_balance_wallet_outlined, scheme.secondary, 'الحساب');
      case NotificationType.video:
        return const _TypeStyle(
            Icons.smart_display, Color(0xFFE53935), 'فيديو');
      case NotificationType.general:
        return _TypeStyle(
            Icons.notifications_outlined, semantic.textSecondary, 'عام');
    }
  }
}

/// Compact Arabic relative time.
String _timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inSeconds < 60) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  if (diff.inDays < 30) return 'قبل ${diff.inDays} ي';
  final d = time;
  return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
}
