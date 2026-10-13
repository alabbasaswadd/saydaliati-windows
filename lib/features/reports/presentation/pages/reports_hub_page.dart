import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/pages/expiry_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/inventory_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/prescriptions_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/profit_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/purchases_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/sales_report_page.dart';
import 'package:saydaliati/features/reports/presentation/pages/stocktake_report_page.dart';

/// Reports landing screen: a clear card per report. Each report opens with a
/// sensible default period and lets the user change it from its own side sheet.
class ReportsHubPage extends StatelessWidget {
  const ReportsHubPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // Reports that take a period open on "this month" by default.
    final defaultPeriod = ReportPeriod.month();
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.reports)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _reportCard(
            context,
            icon: Icons.point_of_sale_outlined,
            title: AppStrings.salesReport,
            subtitle: AppStrings.salesReportHint,
            onTap: () =>
                _open(context, SalesReportPage(initialPeriod: defaultPeriod)),
          ),
          _reportCard(
            context,
            icon: Icons.trending_up_outlined,
            title: AppStrings.profitReportTitle,
            subtitle: AppStrings.profitReportHint,
            onTap: () =>
                _open(context, ProfitReportPage(initialPeriod: defaultPeriod)),
          ),
          _reportCard(
            context,
            icon: Icons.shopping_cart_outlined,
            title: AppStrings.purchasesReport,
            subtitle: AppStrings.purchasesReportHint,
            onTap: () => _open(
                context, PurchasesReportPage(initialPeriod: defaultPeriod)),
          ),
          _reportCard(
            context,
            icon: Icons.inventory_2_outlined,
            title: AppStrings.inventoryReport,
            subtitle: AppStrings.inventoryReportHint,
            onTap: () => _open(context, const InventoryReportPage()),
          ),
          _reportCard(
            context,
            icon: Icons.event_busy_outlined,
            title: AppStrings.expiryReport,
            subtitle: AppStrings.expiryReportHint,
            onTap: () => _open(context, const ExpiryReportPage()),
          ),
          _reportCard(
            context,
            icon: Icons.fact_check_outlined,
            title: AppStrings.stocktakeReport,
            subtitle: AppStrings.stocktakeReportHint,
            onTap: () => _open(context, const StocktakeReportPage()),
          ),
          _reportCard(
            context,
            icon: Icons.medical_services_outlined,
            title: AppStrings.prescriptionsReport,
            subtitle: AppStrings.prescriptionsReportHint,
            onTap: () => _open(context, const PrescriptionsReportPage()),
          ),
        ],
      ),
    );
  }

  Widget _reportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: AppRadius.brMd,
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
                child: Icon(icon, color: theme.colorScheme.primary, size: AppSizes.iconLg),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}
