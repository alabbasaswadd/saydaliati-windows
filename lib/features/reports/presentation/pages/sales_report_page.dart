import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_summary.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_hero_stat.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/presentation/widgets/stat_tile.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/lists/app_section_header.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Sales report: hero profit, secondary KPIs, and tables for the payment-method
/// breakdown and top-selling medicines. Period from the side sheet.
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
    final code = ref.watch(baseCurrencyProvider)?.code ?? '';
    final profitColor =
        s.grossProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportHeroStat(
          label: AppStrings.grossProfit,
          value: Formatters.money(s.grossProfit, code),
          icon: Icons.trending_up_outlined,
          color: profitColor,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: AppStrings.totalRevenue,
                value: Formatters.money(s.totalRevenue, code),
                icon: Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: AppStrings.costOfGoods,
                value: Formatters.money(s.costOfGoods, code),
                icon: Icons.shopping_bag_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: AppStrings.invoicesCount,
                value: Formatters.integer(s.invoicesCount),
                icon: Icons.receipt_long_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppSectionHeader(title: AppStrings.byPaymentMethod),
        const SizedBox(height: AppSpacing.sm),
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [
            for (final b in s.byPaymentMethod)
              ReportItem(
                title: _payLabel(b.paymentMethod),
                trailing: Formatters.money(b.total, code),
                fields: [
                  ReportField(AppStrings.invoicesCount,
                      Formatters.integer(b.count)),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppSectionHeader(title: AppStrings.topSellingMedicines),
        const SizedBox(height: AppSpacing.sm),
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [
            for (final m in s.topMedicines)
              ReportItem(
                title: m.brandName,
                trailing: Formatters.money(m.revenue, code),
                fields: [
                  ReportField(
                      AppStrings.qtySold, Formatters.qty(m.quantitySold)),
                ],
              ),
          ],
        ),
      ],
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
