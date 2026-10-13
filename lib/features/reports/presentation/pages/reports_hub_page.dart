import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// Reports landing screen: a responsive grid of report cards (2–4 columns by
/// width). Each report is a nested shell route (`context.go`) so the sidebar
/// stays visible and highlighted while the report is open.
class ReportsHubPage extends StatelessWidget {
  const ReportsHubPage({super.key});

  static const List<(IconData, String, String, String)> _reports = [
    (
      Icons.point_of_sale_outlined,
      AppStrings.salesReport,
      AppStrings.salesReportHint,
      AppRoutes.salesReport,
    ),
    (
      Icons.trending_up_outlined,
      AppStrings.profitReportTitle,
      AppStrings.profitReportHint,
      AppRoutes.profitReport,
    ),
    (
      Icons.shopping_cart_outlined,
      AppStrings.purchasesReport,
      AppStrings.purchasesReportHint,
      AppRoutes.purchasesReport,
    ),
    (
      Icons.inventory_2_outlined,
      AppStrings.inventoryReport,
      AppStrings.inventoryReportHint,
      AppRoutes.inventoryReport,
    ),
    (
      Icons.event_busy_outlined,
      AppStrings.expiryReport,
      AppStrings.expiryReportHint,
      AppRoutes.expiryReport,
    ),
    (
      Icons.fact_check_outlined,
      AppStrings.stocktakeReport,
      AppStrings.stocktakeReportHint,
      AppRoutes.stocktakeReport,
    ),
    (
      Icons.medical_services_outlined,
      AppStrings.prescriptionsReport,
      AppStrings.prescriptionsReportHint,
      AppRoutes.prescriptionsReport,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.reports)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final columns = w >= AppBreakpoints.expanded
              ? 4
              : w >= AppBreakpoints.medium
                  ? 3
                  : w >= 560
                      ? 2
                      : 1;
          return ConstrainedContent(
            maxWidth: 1280,
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                mainAxisExtent: 112,
              ),
              itemCount: _reports.length,
              itemBuilder: (context, i) {
                final (icon, title, subtitle, route) = _reports[i];
                return _ReportCard(
                  icon: icon,
                  title: title,
                  subtitle: subtitle,
                  onTap: () => context.go(route),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    color: theme.colorScheme.primary, size: AppSizes.iconLg),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
