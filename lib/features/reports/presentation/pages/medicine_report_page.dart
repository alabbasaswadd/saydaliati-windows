import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_value_widget.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/cards/app_section_card.dart';

/// A modern per-medicine report: KPI tiles + flags + details.
class MedicineReportPage extends ConsumerWidget {
  const MedicineReportPage({required this.medicineId, super.key});

  final String medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(medicineReportProvider(medicineId));
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.medicineReport)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(medicineReportProvider(medicineId).future),
        child: AsyncValueWidget(
          value: async,
          onRetry: () => ref.invalidate(medicineReportProvider(medicineId)),
          data: (report) => _ReportBody(
            report: report,
            code: ref.watch(baseCurrencyProvider)?.code ?? '',
          ),
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.code});

  final MedicineReport report;
  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    final tiles = <Widget>[
      StatCard(
        label: AppStrings.stockQuantity,
        value: Formatters.integer(report.stockQuantity),
        icon: Icons.inventory_2_outlined,
        color: report.isLowStock ? sem.warning : theme.colorScheme.primary,
      ),
      StatCard(
        label: AppStrings.soldQuantity,
        value: Formatters.integer(report.soldQuantity),
        icon: Icons.sell_outlined,
        color: sem.success,
      ),
      StatCard(
        label: AppStrings.reservedQuantity,
        value: Formatters.integer(report.reservedQuantity),
        icon: Icons.lock_clock_outlined,
        color: sem.info,
      ),
      StatCard(
        label: AppStrings.unitPriceLabel,
        value: Formatters.money(report.unitPrice, code),
        icon: Icons.payments_outlined,
        color: theme.colorScheme.secondary,
      ),
      StatCard(
        label: AppStrings.costPriceLabel,
        value: Formatters.money(report.purchaseCost, code),
        icon: Icons.shopping_bag_outlined,
        color: Colors.orange.shade800,
      ),
      StatCard(
        label: AppStrings.totalSales,
        value: Formatters.money(report.totalSalesAmount, code),
        icon: Icons.trending_up,
        color: theme.colorScheme.primary,
      ),
      StatCard(
        label: AppStrings.transactionsCount,
        value: Formatters.integer(report.totalTransactions),
        icon: Icons.receipt_long_outlined,
        color: sem.info,
      ),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(report.name, style: theme.textTheme.headlineSmall),
        if (report.code.isNotEmpty)
          Text(report.code, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (report.isLowStock)
              _Flag(label: AppStrings.lowStockFlag, color: sem.warning, icon: Icons.warning_amber_rounded),
            if (report.isNearExpiry)
              _Flag(label: AppStrings.nearExpiry, color: theme.colorScheme.error, icon: Icons.event_busy_outlined),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.35,
          children: tiles,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSectionCard(
          title: AppStrings.details,
          icon: Icons.info_outline,
          child: Column(
            children: [
              if (report.category.isNotEmpty)
                _row(theme, AppStrings.category, report.category),
              if (report.manufacturerName.isNotEmpty)
                _row(theme, AppStrings.manufacturer, report.manufacturerName),
              if (report.expiryDate != null)
                _row(theme, AppStrings.expiry, AppDate.ymd(report.expiryDate!)),
              if (report.notes.isNotEmpty)
                _row(theme, AppStrings.notes, report.notes),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(AppStrings.stockBatchesTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ReportList(
          emptyMessage: AppStrings.noBatchesInStock,
          items: [
            for (final b in report.batches)
              ReportItem(
                title: b.warehouseName,
                accentColor: _daysColor(b.daysLeft),
                trailing: _daysText(b.daysLeft),
                trailingColor: _daysColor(b.daysLeft),
                trailingCaption: AppStrings.daysLeftColumn,
                fields: [
                  ReportField(AppStrings.expiryColumn,
                      b.expiryDate == null ? '—' : AppDate.ymd(b.expiryDate!)),
                  ReportField(AppStrings.qtyLabel,
                      Formatters.qty(b.quantityAvailable)),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static String _daysText(int? days) {
    if (days == null) return '—';
    return days >= 0
        ? '$days ${AppStrings.daysUnit}'
        : '-${-days} ${AppStrings.daysUnit}';
  }

  static Color? _daysColor(int? days) {
    if (days == null) return null;
    if (days < 0) return Colors.red.shade700;
    if (days <= 90) return Colors.orange.shade800;
    return null;
  }

  Widget _row(ThemeData theme, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ),
            Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
          ],
        ),
      );
}

class _Flag extends StatelessWidget {
  const _Flag({required this.label, required this.color, required this.icon});

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.brSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
