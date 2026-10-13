import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/pages/expiry_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/inventory_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/prescriptions_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/profit_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/purchases_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/sales_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/stocktake_report_page.dart';
import 'package:saydaliati/shared/widgets/animations/fade_slide_in.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';

/// Dashboard — quick navigation grid for operational sections and reports.
///
/// Desktop changes vs mobile:
///  • Grid columns scale with available width (4 on ≥ 900 px, 3 on narrower).
///  • Barcode-scan FAB removed (desktop uses search / USB scanner input).
///  • Quick-action taps use [context.go] instead of push so they switch the
///    sidebar's active item rather than stacking a new route.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  List<_QuickAction> _actions() {
    final month = ReportPeriod.month();
    return <_QuickAction>[
      // Operational sections
      const _QuickAction(AppStrings.sales, Icons.point_of_sale_outlined,
          route: AppRoutes.sales),
      const _QuickAction(AppStrings.products, Icons.medication_outlined,
          route: AppRoutes.products),
      const _QuickAction(AppStrings.purchases, Icons.local_shipping_outlined,
          route: AppRoutes.purchases),
      const _QuickAction(AppStrings.inventory, Icons.inventory_2_outlined,
          route: AppRoutes.inventory),
      const _QuickAction(AppStrings.stockMovements, Icons.swap_vert_outlined,
          route: AppRoutes.stockMovements),
      // Quick-access reports
      _QuickAction(AppStrings.salesReport, Icons.point_of_sale_outlined,
          open: (_) => SalesReportPage(initialPeriod: month)),
      _QuickAction(AppStrings.profitReportTitle, Icons.trending_up_outlined,
          open: (_) => ProfitReportPage(initialPeriod: month)),
      _QuickAction(AppStrings.purchasesReport, Icons.shopping_cart_outlined,
          open: (_) => PurchasesReportPage(initialPeriod: month)),
      _QuickAction(AppStrings.inventoryReport, Icons.inventory_2_outlined,
          open: (_) => const InventoryReportPage()),
      _QuickAction(AppStrings.expiryReport, Icons.event_busy_outlined,
          open: (_) => const ExpiryReportPage()),
      _QuickAction(AppStrings.stocktakeReport, Icons.fact_check_outlined,
          open: (_) => const StocktakeReportPage()),
      _QuickAction(
          AppStrings.prescriptionsReport, Icons.medical_services_outlined,
          open: (_) => const PrescriptionsReportPage()),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending =
        ref.watch(pendingOperationsCountProvider).value ?? 0;
    final actions = _actions();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.sectionsTitle),
        actions: [
          const NotificationBell(),
          if (pending > 0)
            IconButton(
              tooltip: AppStrings.pendingOperations,
              onPressed: () =>
                  ref.read(syncControllerProvider.notifier).pushNow(),
              icon: Badge(
                label: Text('$pending'),
                child: const Icon(Icons.cloud_upload_outlined),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppStrings.settings,
            // go() keeps the sidebar in sync with the active branch
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 4 columns on wide screens, 3 on narrower panes
          final crossAxisCount = constraints.maxWidth >= 900 ? 4 : 3;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.1,
            children: [
              for (var i = 0; i < actions.length; i++)
                FadeSlideIn(
                  delay: Duration(milliseconds: 30 + i * 30),
                  child: _ActionTile(action: actions[i]),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: () {
        if (action.route != null) {
          // go() switches the sidebar active item; push() would stack a route.
          context.go(action.route!);
        } else if (action.open != null) {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: action.open!));
        }
      },
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            action.icon,
            size: AppSizes.iconLg,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.label, this.icon, {this.route, this.open});

  final String label;
  final IconData icon;
  final String? route;
  final WidgetBuilder? open;
}
