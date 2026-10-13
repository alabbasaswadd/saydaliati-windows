import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/notifications/notification_center_providers.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Official pharmacy website — the pricing/plans section anchor.
const String _kPricingUrl = 'https://codetechsyria.com/saydaliati/#pricing';

/// Technical-support WhatsApp numbers (full international, no '+').
const List<_Support> _kSupportNumbers = <_Support>[
  _Support(display: '0985 311 971', wa: '963985311971'),
  _Support(display: '0962 097 736', wa: '963962097736'),
];

/// Tab 4 — المزيد. A grouped menu of the remaining sections, each routed on the
/// root navigator so it covers the shell, plus technical-support (WhatsApp) and
/// a link to the pricing/plans page on the official website.
class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _items = <_MoreItem>[
    _MoreItem(AppStrings.stockMovements, Icons.swap_vert, AppRoutes.stockMovements),
    _MoreItem(AppStrings.suppliers, Icons.store_outlined, AppRoutes.suppliers),
    _MoreItem(AppStrings.customers, Icons.people_outline, AppRoutes.customers),
    _MoreItem(AppStrings.categories, Icons.category_outlined, AppRoutes.categories),
    _MoreItem(AppStrings.manufacturers, Icons.store_outlined, AppRoutes.manufacturers),
    _MoreItem(AppStrings.unitsList, Icons.straighten_outlined, AppRoutes.units),
    _MoreItem(AppStrings.currenciesList, Icons.attach_money, AppRoutes.currencies),
    _MoreItem(AppStrings.account, Icons.person_outline, AppRoutes.profile),
    _MoreItem(AppStrings.settings, Icons.settings_outlined, AppRoutes.settings),
    _MoreItem(AppStrings.aboutApp, Icons.info_outline, AppRoutes.about),
  ];

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      AppSnackbar.error(context, AppStrings.linkOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unread = ref.watch(notificationsUnreadCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.more),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () => context.push(AppRoutes.notifications),
            icon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // شروحات تعليمية — مدخل بارز
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                onTap: () => context.push(AppRoutes.tutorials),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      const Icon(Icons.school_rounded,
                          color: Colors.white, size: 30),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الشروحات التعليمية',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('فيديوهات قصيرة تشرح كل خطوة',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_left, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, indent: 56),

          // الإشعارات — مع شارة غير المقروء
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('الإشعارات'),
            trailing: unread > 0
                ? Badge.count(count: unread)
                : const Icon(Icons.chevron_left, size: 20),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          const Divider(height: 1, indent: 56),

          for (final item in _items) ...[
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_left, size: 20),
              onTap: () => context.push(item.route),
            ),
            const Divider(height: 1, indent: 56),
          ],

          // الدعم الفني — أرقام واتساب
          _sectionHeader(theme, AppStrings.techSupport),
          for (final s in _kSupportNumbers)
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(s.display, textDirection: TextDirection.ltr),
              subtitle: const Text(AppStrings.techSupportHint),
              trailing: const Icon(Icons.chat, color: Color(0xFF25D366)),
              onTap: () => _open(context, 'https://wa.me/${s.wa}'),
            ),

          // الأسعار والخطط — الموقع الرسمي
          _sectionHeader(theme, AppStrings.pricingAndPlans),
          ListTile(
            leading: const Icon(Icons.sell_outlined),
            title: const Text(AppStrings.pricingAndPlans),
            subtitle: const Text(AppStrings.pricingAndPlansHint),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _open(context, _kPricingUrl),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      );
}

class _MoreItem {
  const _MoreItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}

class _Support {
  const _Support({required this.display, required this.wa});

  /// Local, human-readable form shown in the tile.
  final String display;

  /// Full international number (no '+') for the wa.me link.
  final String wa;
}
