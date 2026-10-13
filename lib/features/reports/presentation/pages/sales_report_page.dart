import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_data_grid.dart';
import 'package:saydaliati/shared/widgets/lists/app_section_header.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Sales report — wakeed-style grid report: a slim stat-chips strip over
/// dense full-height data grids (payment methods + top medicines), side by
/// side on wide windows.
class SalesReportPage extends ConsumerStatefulWidget {
  const SalesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends ConsumerState<SalesReportPage> {
  late ReportPeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(salesSummaryProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.salesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.invalidate(
          salesSummaryProvider(_period.startUtcIso, _period.endUtcIso)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(
              salesSummaryProvider(_period.startUtcIso, _period.endUtcIso)),
        ),
        data: (s) => _content(context, s),
      ),
    );
  }

  Widget _content(BuildContext context, SalesSummary s) {
    final theme = Theme.of(context);
    final code = ref.watch(baseCurrencyProvider)?.code ?? '';
    final profitColor =
        s.grossProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    final stats = StatChipsBar(chips: [
      StatChip(
        label: AppStrings.grossProfit,
        value: Formatters.money(s.grossProfit, code),
        icon: Icons.trending_up_outlined,
        color: profitColor,
      ),
      StatChip(
        label: AppStrings.totalRevenue,
        value: Formatters.money(s.totalRevenue, code),
        icon: Icons.payments_outlined,
      ),
      StatChip(
        label: AppStrings.costOfGoods,
        value: Formatters.money(s.costOfGoods, code),
        icon: Icons.shopping_bag_outlined,
        color: theme.colorScheme.secondary,
      ),
      StatChip(
        label: AppStrings.invoicesCount,
        value: Formatters.integer(s.invoicesCount),
        icon: Icons.receipt_long_outlined,
      ),
    ]);

    Widget paymentsGrid({required bool expand}) => AppDataGrid<PaymentMethodBucket>(
          rows: s.byPaymentMethod,
          expand: expand,
          minWidth: 360,
          emptyMessage: AppStrings.noDataForPeriod,
          initialSortColumn: 2,
          initialAscending: false,
          columns: [
            AppDataColumn.text(
              label: AppStrings.paymentMethod,
              flex: 2,
              value: (b) => _payLabel(b.paymentMethod),
            ),
            AppDataColumn.text(
              label: AppStrings.invoicesCount,
              value: (b) => Formatters.integer(b.count),
              sortBy: (b) => b.count,
            ),
            AppDataColumn.text(
              label: AppStrings.total,
              alignEnd: true,
              emphasized: true,
              value: (b) => Formatters.money(b.total, code),
              sortBy: (b) => b.total,
            ),
          ],
        );

    Widget medicinesGrid({required bool expand}) => AppDataGrid<TopMedicineSales>(
          rows: s.topMedicines,
          expand: expand,
          minWidth: 360,
          emptyMessage: AppStrings.noDataForPeriod,
          initialSortColumn: 2,
          initialAscending: false,
          columns: [
            AppDataColumn.text(
              label: AppStrings.medicineName,
              flex: 2,
              value: (m) => m.brandName,
            ),
            AppDataColumn.text(
              label: AppStrings.qtySold,
              value: (m) => Formatters.qty(m.quantitySold),
              sortBy: (m) => m.quantitySold,
            ),
            AppDataColumn.text(
              label: AppStrings.totalRevenue,
              alignEnd: true,
              emphasized: true,
              value: (m) => Formatters.money(m.revenue, code),
              sortBy: (m) => m.revenue,
            ),
          ],
        );

    Widget section(String title, Widget grid, {required bool expandGrid}) {
      final column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: title),
          const SizedBox(height: AppSpacing.sm),
          expandGrid ? Expanded(child: grid) : grid,
        ],
      );
      return column;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= AppBreakpoints.medium;
        if (wide) {
          // Desktop: stats strip + the two grids FULL-HEIGHT side by side.
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                stats,
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: section(AppStrings.byPaymentMethod,
                            paymentsGrid(expand: true),
                            expandGrid: true),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: section(AppStrings.topSellingMedicines,
                            medicinesGrid(expand: true),
                            expandGrid: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        // Compact: stacked scroll.
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            stats,
            const SizedBox(height: AppSpacing.md),
            section(AppStrings.byPaymentMethod, paymentsGrid(expand: false),
                expandGrid: false),
            const SizedBox(height: AppSpacing.lg),
            section(AppStrings.topSellingMedicines,
                medicinesGrid(expand: false),
                expandGrid: false),
          ],
        );
      },
    );
  }

  static String _payLabel(int method) {
    switch (method) {
      case 1:
        return AppStrings.payCash;
      case 2:
        return AppStrings.payCreditCard;
      case 3:
        return AppStrings.payDebitCard;
      case 4:
        return AppStrings.payBankTransfer;
      case 5:
        return AppStrings.payMobileWallet;
      default:
        return '—';
    }
  }
}
