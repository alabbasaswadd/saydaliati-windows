import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    final cashBoxes = _cashBoxBalances(accounts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات'),
        actions: [
          AppRefreshButton(
            onRefresh: () {
              ref.invalidate(dashboardProvider);
              ref.invalidate(dashboardProfitProvider);
              ref.invalidate(accountsListProvider);
            },
          ),
        ],
      ),
      body: dashboardAsync.when(
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
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: _ChartsRow(summary: summary, cashBoxes: cashBoxes),
        ),
      ),
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

/// Sales-trend bar chart + top-medicines ranked bars + profit donut + top
/// suppliers-owed ranked bars + capital gauge — cards that wrap 3/2/1 per row
/// as the window narrows.
class _ChartsRow extends StatelessWidget {
  const _ChartsRow({required this.summary, required this.cashBoxes});

  final DashboardSummary summary;
  final List<({String currencyCode, double balance})> cashBoxes;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      AppCard(child: _SalesTrendChart(points: summary.salesTrend)),
      AppCard(child: _TopMedicinesChart(items: summary.topMedicines)),
      const AppCard(child: _ProfitChartCard()),
      AppCard(child: _CashBoxChartCard(boxes: cashBoxes)),
      AppCard(
        child: _TopPayablesChart(
          items: summary.topPayables,
          total: summary.totalPayables,
        ),
      ),
      AppCard(child: _CapitalChartCard(value: summary.totalStockValue)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1700
            ? 3
            : constraints.maxWidth >= 700
                ? 2
                : 1;
        if (columns == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) AppSpacing.vLg,
                cards[i],
              ],
            ],
          );
        }
        final gap = AppSpacing.lg * (columns - 1);
        final cardWidth = (constraints.maxWidth - gap) / columns;
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            for (final c in cards) SizedBox(width: cardWidth, child: c),
          ],
        );
      },
    );
  }
}

/// Last-7-days sales total, one bar per day — the brand-green single series.
class _SalesTrendChart extends StatelessWidget {
  const _SalesTrendChart({required this.points});

  final List<SalesTrendPoint> points;

  double get _maxY {
    final m = points.fold<double>(0, (a, p) => p.totalAmount > a ? p.totalAmount : a);
    return m <= 0 ? 10 : m * 1.45;
  }

  double get _total => points.fold<double>(0, (a, p) => a + p.totalAmount);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasData = points.any((p) => p.totalAmount > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dashSalesTrendTitle, style: theme.textTheme.titleMedium),
        AppSpacing.vSm,
        Text(
          Formatters.number(_total),
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
        ),
        AppSpacing.vMd,
        SizedBox(
          height: 220,
          child: !hasData
              ? const EmptyState(icon: Icons.show_chart_outlined)
              : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _maxY / 4,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: theme.dividerColor.withValues(alpha: 0.6),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= points.length) {
                              return const SizedBox.shrink();
                            }
                            final d = points[i].date.toLocal();
                            return Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.xs),
                              child: Text(
                                '${d.day}/${d.month}',
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 6,
                        getTooltipItem: (group, _, _, _) {
                          final p = points[group.x.toInt()];
                          return BarTooltipItem(
                            Formatters.number(p.totalAmount),
                            theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < points.length; i++)
                        BarChartGroupData(
                          x: i,
                          showingTooltipIndicators: const [0],
                          barRods: [
                            BarChartRodData(
                              toY: points[i].totalAmount,
                              color: theme.colorScheme.primary,
                              width: 22,
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// Top 5 medicines by revenue — a direct-labeled ranked bar list.
class _TopMedicinesChart extends StatelessWidget {
  const _TopMedicinesChart({required this.items});

  final List<DashboardTopMedicine> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;
    final maxRevenue =
        items.isEmpty ? 0.0 : items.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dashTopMedicinesTitle, style: theme.textTheme.titleMedium),
        AppSpacing.vMd,
        SizedBox(
          height: 220,
          child: items.isEmpty
              ? const EmptyState(icon: Icons.bar_chart_outlined)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final m in items)
                      _TopMedicineBar(item: m, maxRevenue: maxRevenue, color: color),
                  ],
                ),
        ),
      ],
    );
  }
}

class _TopMedicineBar extends StatelessWidget {
  const _TopMedicineBar({
    required this.item,
    required this.maxRevenue,
    required this.color,
  });

  final DashboardTopMedicine item;
  final double maxRevenue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxRevenue <= 0 ? 0.0 : (item.revenue / maxRevenue).clamp(0.04, 1.0);

    return Tooltip(
      message: Formatters.number(item.revenue),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              item.brandName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          AppSpacing.hSm,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: AppRadius.brSm,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: 18,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(color: color, borderRadius: AppRadius.brSm),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.hSm,
          SizedBox(
            width: 64,
            child: Text(
              Formatters.number(item.revenue),
              textAlign: TextAlign.end,
              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top 5 suppliers by amount owed to them.
class _TopPayablesChart extends StatelessWidget {
  const _TopPayablesChart({required this.items, required this.total});

  final List<DashboardPayable> items;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;
    final maxBalance =
        items.isEmpty ? 0.0 : items.map((e) => e.balance).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dashPayablesTitle, style: theme.textTheme.titleMedium),
        AppSpacing.vSm,
        Text(
          Formatters.number(total),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
        AppSpacing.vMd,
        SizedBox(
          height: 220,
          child: items.isEmpty
              ? const EmptyState(
                  icon: Icons.assignment_turned_in_outlined,
                  message: AppStrings.dashNoPayables,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final p in items)
                      _TopPayableBar(item: p, maxBalance: maxBalance, color: color),
                  ],
                ),
        ),
        if (items.isNotEmpty) ...[
          AppSpacing.vSm,
          AppButton.text(
            label: AppStrings.dashViewAll,
            onPressed: () => context.go(AppRoutes.debtsSuppliers),
          ),
        ],
      ],
    );
  }
}

class _TopPayableBar extends StatelessWidget {
  const _TopPayableBar({
    required this.item,
    required this.maxBalance,
    required this.color,
  });

  final DashboardPayable item;
  final double maxBalance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxBalance <= 0 ? 0.0 : (item.balance / maxBalance).clamp(0.04, 1.0);

    return Tooltip(
      message: Formatters.number(item.balance),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              item.supplierName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          AppSpacing.hSm,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: AppRadius.brSm,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: 18,
                    width: constraints.maxWidth * ratio,
                    decoration: BoxDecoration(color: color, borderRadius: AppRadius.brSm),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.hSm,
          SizedBox(
            width: 64,
            child: Text(
              Formatters.number(item.balance),
              textAlign: TextAlign.end,
              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Capital deployed — a full radial ring (single value).
class _CapitalChartCard extends StatelessWidget {
  const _CapitalChartCard({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = context.semantic.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppStrings.dashCapital, style: theme.textTheme.titleMedium),
            Tooltip(
              message: AppStrings.dashCapitalInfo,
              child: IconButton(
                icon: Icon(Icons.info_outline, size: AppSizes.iconSm, color: theme.hintColor),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(AppStrings.dashCapital),
                    content: const Text(AppStrings.dashCapitalInfo),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(AppStrings.ok),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vMd,
        SizedBox(
          height: 220,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 14,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.15),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, color: color, size: AppSizes.iconMd),
                    AppSpacing.vSm,
                    Text(
                      Formatters.number(value),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Net-profit donut for a chosen period (day/week/month/year).
class _ProfitChartCard extends ConsumerStatefulWidget {
  const _ProfitChartCard();

  @override
  ConsumerState<_ProfitChartCard> createState() => _ProfitChartCardState();
}

class _ProfitChartCardState extends ConsumerState<_ProfitChartCard> {
  String _period = 'day';

  static const _periods = [
    ('day', AppStrings.dashPeriodDay),
    ('week', AppStrings.dashPeriodWeek),
    ('month', AppStrings.dashPeriodMonth),
    ('year', AppStrings.dashPeriodYear),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profitAsync = ref.watch(dashboardProfitProvider(_period));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dashProfitTitle, style: theme.textTheme.titleMedium),
        AppSpacing.vMd,
        _PeriodSelector(
          periods: _periods,
          selected: _period,
          onChanged: (p) => setState(() => _period = p),
        ),
        AppSpacing.vMd,
        SizedBox(
          height: 300,
          child: profitAsync.when(
            loading: () => const LoadingState(),
            error: (e, _) => ErrorState.fromError(
              e,
              onRetry: () => ref.invalidate(dashboardProfitProvider(_period)),
            ),
            data: (p) => _ProfitDonut(profit: p),
          ),
        ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  final List<(String, String)> periods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: sem.border),
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final p in periods)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () => onChanged(p.$1),
                borderRadius: AppRadius.brSm,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: p.$1 == selected
                        ? theme.colorScheme.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: AppRadius.brSm,
                  ),
                  child: Text(
                    p.$2,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: p.$1 == selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: p.$1 == selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfitDonut extends StatelessWidget {
  const _ProfitDonut({required this.profit});

  final DashboardProfit profit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final costColor = context.semantic.textSecondary;
    final profitColor = theme.colorScheme.primary;

    if (profit.revenue <= 0) {
      return const EmptyState(
        icon: Icons.pie_chart_outline,
        message: AppStrings.dashNoProfitData,
      );
    }

    final isLoss = profit.profit < 0;
    final profitSliceColor = isLoss ? theme.colorScheme.error : profitColor;
    final cost = profit.cost.abs();
    final profitAbs = profit.profit.abs();

    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 64,
                  sections: [
                    PieChartSectionData(
                      value: cost <= 0 ? 0.001 : cost,
                      gradient: _sliceGradient(costColor),
                      showTitle: false,
                      radius: 40,
                    ),
                    PieChartSectionData(
                      value: profitAbs <= 0 ? 0.001 : profitAbs,
                      gradient: _sliceGradient(profitSliceColor),
                      showTitle: false,
                      radius: 40,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Formatters.number(profit.profit),
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700, color: profitSliceColor),
                  ),
                  Text(AppStrings.profitShort, style: theme.textTheme.labelMedium),
                ],
              ),
            ],
          ),
        ),
        AppSpacing.hMd,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendRow(color: costColor, label: AppStrings.costShort, value: profit.cost),
            AppSpacing.vSm,
            _LegendRow(color: profitSliceColor, label: AppStrings.profitShort, value: profit.profit),
          ],
        ),
      ],
    );
  }

  Gradient _sliceGradient(Color base) => RadialGradient(
        center: Alignment.topLeft,
        radius: 1.4,
        colors: [Color.lerp(base, Colors.white, 0.35)!, base],
      );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
    this.labelColor,
  });

  final Color color;
  final String label;
  final double value;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.hSm,
        Text(label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: labelColor,
              fontWeight: labelColor != null ? FontWeight.w700 : null,
            )),
        AppSpacing.hSm,
        Text(
          Formatters.number(value),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: labelColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// Cash-box balance distribution by currency.
class _CashBoxChartCard extends ConsumerWidget {
  const _CashBoxChartCard({required this.boxes});

  final List<({String currencyCode, double balance})> boxes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sem = context.semantic;

    if (boxes.isEmpty || boxes.every((b) => b.balance == 0)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.dashCashBoxTitle, style: theme.textTheme.titleMedium),
          AppSpacing.vMd,
          const SizedBox(
            height: 220,
            child: EmptyState(
                icon: Icons.account_balance_wallet_outlined,
                message: AppStrings.dashNoCashBox),
          ),
        ],
      );
    }

    final base = ref.watch(baseCurrencyProvider);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final colors = [
      theme.colorScheme.primary,
      sem.info,
      sem.warning,
      sem.success,
      theme.colorScheme.secondary,
    ];

    double inBase(({String currencyCode, double balance}) b) {
      final cur = currencies.where((c) => c.code == b.currencyCode).firstOrNull;
      return convertToBase(b.balance, base, cur).abs();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.dashCashBoxTitle, style: theme.textTheme.titleMedium),
        AppSpacing.vMd,
        SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 50,
                    sections: [
                      for (var i = 0; i < boxes.length; i++)
                        PieChartSectionData(
                          value: inBase(boxes[i]) <= 0 ? 0.001 : inBase(boxes[i]),
                          gradient: _sliceGradient(colors[i % colors.length]),
                          showTitle: false,
                          radius: 40,
                        ),
                    ],
                  ),
                ),
              ),
              AppSpacing.hMd,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < boxes.length; i++) ...[
                    if (i > 0) AppSpacing.vSm,
                    _LegendRow(
                      color: colors[i % colors.length],
                      label: boxes[i].currencyCode,
                      value: boxes[i].balance,
                      labelColor: boxes[i].balance < 0
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Gradient _sliceGradient(Color base) => RadialGradient(
        center: Alignment.topLeft,
        radius: 1.4,
        colors: [Color.lerp(base, Colors.white, 0.35)!, base],
      );
}
