import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/auth/presentation/widgets/migration_offer_dialog.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/animations/fade_slide_in.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Dashboard — KPIs and alerts. Charts live in the dedicated Analytics page.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;
    final dashboardAsync = ref.watch(dashboardProvider);

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
          AppRefreshButton(
            onRefresh: () {
              ref.invalidate(dashboardProvider);
              ref.invalidate(accountsListProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppStrings.settings,
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dashboardAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                        child: LoadingState(),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        child: ErrorState.fromError(
                          e,
                          onRetry: () => ref.invalidate(dashboardProvider),
                        ),
                      ),
                      data: (summary) =>
                          _DashboardContent(summary: summary, wide: wide),
                    ),
                  ],
                ),
              );
            },
          ),
          const MigrationOfferGate(),
        ],
      ),
    );
  }
}

/// The data-dependent dashboard body: KPI row + alert panels.
class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.summary, required this.wide});

  final DashboardSummary summary;
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    final cashBoxes = _cashBoxBalances(accounts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeSlideIn(child: _KpiRow(summary: summary, cashBoxes: cashBoxes)),
        AppSpacing.vLg,
        FadeSlideIn(
          delay: const Duration(milliseconds: 60),
          child: _AlertsRow(summary: summary, wide: wide),
        ),
      ],
    );
  }

  List<({String currencyCode, double balance})> _cashBoxBalances(
      List<Account> all) {
    final cashParent = all.where((a) => a.code == '1101').firstOrNull;
    if (cashParent == null) return const [];
    return [
      for (final a in all)
        if (a.parentId == cashParent.id && a.currencyId != null)
          (currencyCode: a.currencyCode ?? '', balance: a.currentBalanceForeign),
    ];
  }
}

/// Six KPI tiles — wraps naturally at any width instead of a hard breakpoint.
class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.summary, required this.cashBoxes});

  final DashboardSummary summary;
  final List<({String currencyCode, double balance})> cashBoxes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    final tiles = <Widget>[
      for (final box in cashBoxes)
        StatCard(
          label: 'رصيد الصندوق (${box.currencyCode})',
          value: Formatters.number(box.balance),
          icon: Icons.account_balance_wallet_outlined,
          color: sem.success,
        ),
      StatCard(
        label: AppStrings.dashSalesToday,
        value: Formatters.number(summary.salesToday),
        icon: Icons.point_of_sale_outlined,
      ),
      StatCard(
        label: AppStrings.dashInvoicesToday,
        value: Formatters.integer(summary.salesInvoicesToday),
        icon: Icons.receipt_long_outlined,
        color: theme.colorScheme.secondary,
      ),
      StatCard(
        label: AppStrings.dashPurchasesThisMonth,
        value: Formatters.number(summary.purchasesThisMonth),
        icon: Icons.local_shipping_outlined,
        color: sem.info,
      ),
      StatCard(
        label: AppStrings.dashTotalMedicines,
        value: Formatters.integer(summary.totalMedicines),
        icon: Icons.medication_outlined,
      ),
      StatCard(
        label: AppStrings.dashTotalCustomers,
        value: Formatters.integer(summary.totalCustomers),
        icon: Icons.people_outline,
        color: sem.success,
      ),
      StatCard(
        label: AppStrings.dashTotalSuppliers,
        value: Formatters.integer(summary.totalSuppliers),
        icon: Icons.inventory_outlined,
        color: sem.success,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 600
                ? 3
                : 2;
        final gap = AppSpacing.md * (perRow - 1);
        final tileWidth = (constraints.maxWidth - gap) / perRow;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final t in tiles) SizedBox(width: tileWidth, child: t),
          ],
        );
      },
    );
  }
}

/// Low-stock + near-expiry alert panels, side by side on wide screens.
class _AlertsRow extends StatelessWidget {
  const _AlertsRow({required this.summary, required this.wide});

  final DashboardSummary summary;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final sem = context.semantic;
    final theme = Theme.of(context);

    final lowStockCard = AppCard(
      child: _AlertPanel(
        title: AppStrings.dashLowStockAlertTitle,
        icon: Icons.warning_amber_rounded,
        color: theme.colorScheme.error,
        rows: [
          for (final l in summary.lowStockList.take(5))
            (l.brandName, Formatters.qty(l.quantityAvailable)),
        ],
        totalCount: summary.lowStockCount,
        emptyMessage: AppStrings.dashNoLowStock,
        viewAllRoute: AppRoutes.inventoryReport,
      ),
    );

    final expiringCard = AppCard(
      child: _AlertPanel(
        title: AppStrings.dashExpiringAlertTitle,
        icon: Icons.event_busy_outlined,
        color: sem.warning,
        rows: [
          for (final e in summary.expiringList.take(5))
            (e.brandName, '${e.daysLeft} ${AppStrings.daysUnit}'),
        ],
        totalCount: summary.expiringCount,
        emptyMessage: AppStrings.dashNoExpiring,
        viewAllRoute: AppRoutes.expiryReport,
      ),
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [lowStockCard, AppSpacing.vLg, expiringCard],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: lowStockCard),
          AppSpacing.hLg,
          Expanded(child: expiringCard),
        ],
      ),
    );
  }
}

class _AlertPanel extends StatelessWidget {
  const _AlertPanel({
    required this.title,
    required this.icon,
    required this.color,
    required this.rows,
    required this.totalCount,
    required this.emptyMessage,
    required this.viewAllRoute,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<(String, String)> rows;
  final int totalCount;
  final String emptyMessage;
  final String viewAllRoute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: AppSizes.iconMd, color: color),
            AppSpacing.hSm,
            Text(title, style: theme.textTheme.titleMedium),
          ],
        ),
        AppSpacing.vMd,
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: EmptyState(message: emptyMessage, icon: icon),
          )
        else ...[
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    r.$2,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: color, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          if (totalCount > rows.length) ...[
            AppSpacing.vSm,
            AppButton.text(
              label: '${AppStrings.dashViewAll} ($totalCount)',
              onPressed: () => context.go(viewAllRoute),
            ),
          ],
        ],
      ],
    );
  }
}
