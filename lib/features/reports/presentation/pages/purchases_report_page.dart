import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_summary.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_hero_stat.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/presentation/widgets/stat_tile.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Purchases report: hero total cost + invoice count, and a table of invoice
/// line items (invoice #, date, medicine, qty, price, subtotal).
class PurchasesReportPage extends ConsumerStatefulWidget {
  const PurchasesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<PurchasesReportPage> createState() =>
      _PurchasesReportPageState();
}

class _PurchasesReportPageState extends ConsumerState<PurchasesReportPage> {
  late ReportPeriod _period = widget.initialPeriod;

  @override
  Widget build(BuildContext context) {
    final async = ref
        .watch(purchasesSummaryProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.purchasesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.invalidate(purchasesSummaryProvider(
          _period.startUtcIso, _period.endUtcIso)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(purchasesSummaryProvider(
              _period.startUtcIso, _period.endUtcIso)),
        ),
        data: (s) => _content(context, s),
      ),
    );
  }

  Widget _content(BuildContext context, PurchasesSummary s) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ReportHeroStat(
          label: AppStrings.totalCost,
          value: Formatters.money(s.totalCost),
          icon: Icons.shopping_cart_outlined,
        ),
        const SizedBox(height: AppSpacing.md),
        StatTile(
          label: AppStrings.invoicesCount,
          value: Formatters.integer(s.invoicesCount),
          icon: Icons.receipt_long_outlined,
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportList(
          emptyMessage: AppStrings.noDataForPeriod,
          items: [
            for (final inv in s.invoices)
              ReportItem(
                title: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}',
                subtitle: _ymd(inv.purchaseDate),
                trailing: Formatters.money(inv.totalAmount),
                children: [
                  for (final line in inv.items)
                    ReportItem(
                      title: line.brandName,
                      subtitle:
                          '${Formatters.qty(line.quantity)} × ${Formatters.number(line.unitPrice)}',
                      trailing: Formatters.money(line.subTotal),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
