import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/medicine_report.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_value_widget.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// A per-medicine report — the project-standard grid style: stat chips, an
/// info grid (field/value), and a stock-batches grid (expiry-colored).
class MedicineReportPage extends ConsumerWidget {
  const MedicineReportPage({required this.medicineId, super.key});

  final String medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(medicineReportProvider(medicineId));
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicineReport),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(medicineReportProvider(medicineId)),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: async,
        onRetry: () => ref.invalidate(medicineReportProvider(medicineId)),
        data: (report) => _ReportBody(
          report: report,
          code: ref.watch(baseCurrencyProvider)?.code ?? '',
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.code});

  final MedicineReport report;
  final String code;

  static const _fWarehouse = 'warehouse';
  static const _fExpiry = 'expiry';
  static const _fQty = 'qty';
  static const _fDays = 'days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    final stats = StatChipsBar(chips: [
      StatChip(
        label: AppStrings.stockQuantity,
        value: Formatters.integer(report.stockQuantity),
        icon: Icons.inventory_2_outlined,
        color: report.isLowStock ? sem.warning : theme.colorScheme.primary,
      ),
      StatChip(
        label: AppStrings.soldQuantity,
        value: Formatters.integer(report.soldQuantity),
        icon: Icons.sell_outlined,
        color: sem.success,
      ),
      StatChip(
        label: AppStrings.reservedQuantity,
        value: Formatters.integer(report.reservedQuantity),
        icon: Icons.lock_clock_outlined,
        color: sem.info,
      ),
      StatChip(
        label: AppStrings.unitPriceLabel,
        value: Formatters.money(report.unitPrice, code),
        icon: Icons.payments_outlined,
        color: theme.colorScheme.secondary,
      ),
      StatChip(
        label: AppStrings.costPriceLabel,
        value: Formatters.money(report.purchaseCost, code),
        icon: Icons.shopping_bag_outlined,
        color: Colors.orange.shade800,
      ),
      StatChip(
        label: AppStrings.totalSales,
        value: Formatters.money(report.totalSalesAmount, code),
        icon: Icons.trending_up,
      ),
      StatChip(
        label: AppStrings.transactionsCount,
        value: Formatters.integer(report.totalTransactions),
        icon: Icons.receipt_long_outlined,
        color: sem.info,
      ),
    ]);

    final infoRows = <(String, String)>[
      if (report.category.isNotEmpty) (AppStrings.category, report.category),
      if (report.manufacturerName.isNotEmpty)
        (AppStrings.manufacturer, report.manufacturerName),
      if (report.expiryDate != null)
        (AppStrings.expiry, AppDate.ymd(report.expiryDate!)),
      if (report.notes.isNotEmpty) (AppStrings.notes, report.notes),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(report.name, style: theme.textTheme.headlineSmall),
        if (report.code.isNotEmpty)
          Text(report.code,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (report.isLowStock)
              _Flag(
                  label: AppStrings.lowStockFlag,
                  color: sem.warning,
                  icon: Icons.warning_amber_rounded),
            if (report.isNearExpiry)
              _Flag(
                  label: AppStrings.nearExpiry,
                  color: theme.colorScheme.error,
                  icon: Icons.event_busy_outlined),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        stats,
        if (infoRows.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.details, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 40 + 37.0 * infoRows.length,
            child: AppGrid(
              showColumnFilter: false,
              columns: [
                appGridTextColumn('الحقل', 'field', width: 170),
                appGridTextColumn('القيمة', 'value', width: 300, flexible: true),
              ],
              rows: [
                for (final (f, v) in infoRows)
                  TrinaRow(cells: {
                    'field': TrinaCell(value: f),
                    'value': TrinaCell(value: v),
                  }),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(AppStrings.stockBatchesTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        report.batches.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(AppStrings.noBatchesInStock,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.hintColor)),
              )
            : SizedBox(
                height: 320,
                child: AppGrid(
                  showColumnFilter: false,
                  columns: [
                    appGridTextColumn(AppStrings.warehouseColumn, _fWarehouse,
                        width: 160),
                    appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
                        width: 110, textAlign: TrinaColumnTextAlign.center),
                    appGridNumberColumn(AppStrings.qtyLabel, _fQty, width: 100),
                    appGridNumberColumn(AppStrings.daysLeftColumn, _fDays,
                        width: 100, format: '#', renderer: (ctx) {
                      final v = ctx.cell.value;
                      final n = v is num
                          ? v.toInt()
                          : int.tryParse(v?.toString() ?? '');
                      if (n == null) return const SizedBox.shrink();
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          '$n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _daysColor(n) ?? theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                  ],
                  rows: [
                    for (final b in report.batches)
                      TrinaRow(cells: {
                        _fWarehouse: TrinaCell(value: b.warehouseName),
                        _fExpiry: TrinaCell(
                            value: b.expiryDate == null
                                ? ''
                                : AppDate.ymd(b.expiryDate!)),
                        _fQty: TrinaCell(value: b.quantityAvailable),
                        _fDays: TrinaCell(value: b.daysLeft ?? ''),
                      }),
                  ],
                  rowColorCallback: (ctx) {
                    final d = ctx.row.cells[_fDays]?.value;
                    final n = d is num ? d.toInt() : int.tryParse(d?.toString() ?? '');
                    final color = _daysColor(n);
                    return color?.withValues(alpha: 0.06) ?? Colors.transparent;
                  },
                ),
              ),
      ],
    );
  }

  static Color? _daysColor(int? days) {
    if (days == null) return null;
    if (days < 0) return Colors.red.shade700;
    if (days <= 90) return Colors.orange.shade800;
    return null;
  }
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
