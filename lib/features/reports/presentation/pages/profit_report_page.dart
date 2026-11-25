import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';
import 'package:saydaliati/features/expenses/expense_providers.dart';
import 'package:saydaliati/features/reports/domain/entities/profit_report.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// قائمة الأرباح والخسائر — تنسيق النظام الإيطالي / IFRS:
///   (I)   الإيرادات
///   (II)  تكلفة البضاعة المباعة  → مجمل الربح التجاري
///   (III) المصاريف التشغيلية     → صافي الربح / الخسارة
/// مع تفاصيل الفواتير في قسم قابل للطيّ أسفل القائمة.
class ProfitReportPage extends ConsumerStatefulWidget {
  const ProfitReportPage({this.initialPeriod, super.key});

  final ReportPeriod? initialPeriod;

  @override
  ConsumerState<ProfitReportPage> createState() => _ProfitReportPageState();
}

class _ProfitReportPageState extends ConsumerState<ProfitReportPage> {
  late ReportPeriod _period = widget.initialPeriod ?? ReportPeriod.today();
  String? _displayCurrencyId;
  bool _showInvoices = false;

  TrinaGridStateManager? _gridManager;

  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fPayment = 'payment';
  static const _fRevenue = 'revenue';
  static const _fCost = 'cost';
  static const _fProfit = 'profit';
  static const _fOriginal = 'original';

  @override
  Widget build(BuildContext context) {
    final base = ref.watch(baseCurrencyProvider);
    final currencies =
        ref.watch(currenciesProvider).value ?? const <Currency>[];
    final async = ref.watch(
        profitReportProvider(_period.startUtcIso, _period.endUtcIso, null));
    final targetId = _displayCurrencyId ?? base?.id;

    return ReportScaffold(
      title: AppStrings.profitReportTitle,
      actions: const [TutorialHelpButton(TutorialTopic.profitReport)],
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.refresh(profitReportProvider(
              _period.startUtcIso, _period.endUtcIso, null)
          .future),
      endDrawerExtra: [
        if (currencies.isNotEmpty)
          AppDropdown<String>(
            label: AppStrings.displayCurrency,
            value: targetId,
            items: [
              for (final c in currencies)
                AppDropdownItem(value: c.id, label: c.code),
            ],
            onChanged: (v) => setState(() => _displayCurrencyId = v),
          ),
      ],
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(profitReportProvider(
              _period.startUtcIso, _period.endUtcIso, null)),
        ),
        data: (r) => _content(context, r, base, currencies),
      ),
    );
  }

  Widget _content(BuildContext context, ProfitReport r, Currency? base,
      List<Currency> currencies) {
    final target =
        currencies.where((c) => c.id == (_displayCurrencyId ?? base?.id)).firstOrNull ??
            base;
    final code = target?.code ?? '';
    double conv(double v) => convertFromBase(v, base, target);

    // Expenses grouped by category for Section III detail
    final rawExpenses = ref
        .watch(expensesForPeriodProvider(_period.startUtcIso, _period.endUtcIso))
        .value ?? const <Expense>[];
    final Map<String, double> expensesByCategory = {};
    for (final e in rawExpenses) {
      final key = e.categoryName.isNotEmpty ? e.categoryName : 'مصاريف أخرى';
      expensesByCategory.update(key, (v) => v + e.baseAmount,
          ifAbsent: () => e.baseAmount);
    }

    if (r.invoices.isEmpty) {
      return const EmptyState(
        icon: Icons.trending_up_outlined,
        message: AppStrings.noDataForPeriod,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── قائمة الأرباح والخسائر ──────────────────────────────────────
          _PlStatement(
            period: _period,
            report: r,
            conv: conv,
            code: code,
            expensesByCategory: expensesByCategory,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── تفاصيل الفواتير (قابلة للطيّ) ───────────────────────────────
          _InvoicesSection(
            report: r,
            conv: conv,
            code: code,
            expanded: _showInvoices,
            onToggle: () => setState(() => _showInvoices = !_showInvoices),
            gridManager: _gridManager,
            onGridLoaded: (m) => _gridManager = m,
            fInvoice: _fInvoice,
            fDate: _fDate,
            fPayment: _fPayment,
            fRevenue: _fRevenue,
            fCost: _fCost,
            fProfit: _fProfit,
            fOriginal: _fOriginal,
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// قائمة الأرباح والخسائر — النظام الإيطالي / IFRS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _PlStatement extends StatelessWidget {
  const _PlStatement({
    required this.period,
    required this.report,
    required this.conv,
    required this.code,
    required this.expensesByCategory,
  });

  final ReportPeriod period;
  final ProfitReport report;
  final double Function(double) conv;
  final String code;
  final Map<String, double> expensesByCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = report;

    final revenue = conv(r.totalRevenue);
    final cogs = conv(r.totalCost);
    final grossProfit = revenue - cogs;
    final grossMargin = revenue > 0 ? (grossProfit / revenue * 100) : 0.0;
    final expenses = conv(r.totalExpenses);
    final netProfit = conv(r.totalProfit);
    final isLoss = netProfit < 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: theme.extension<AppSemanticColors>()!.border, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── رأس القائمة ───────────────────────────────────────────────
            _PlHeader(period: period, code: code),
            const SizedBox(height: AppSpacing.lg),

            // ── القسم (I): الإيرادات ──────────────────────────────────────
            _SectionHeader(
              number: 'I',
              label: 'الإيرادات',
              subtitle: 'Ricavi delle vendite',
            ),
            _LineRow(
              label: 'إيرادات المبيعات',
              detail: '${r.invoicesCount} فاتورة',
              value: revenue,
              code: code,
              indent: true,
            ),
            _SubtotalRow(
              label: 'إجمالي الإيرادات (I)',
              value: revenue,
              code: code,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── القسم (II): تكلفة البضاعة المباعة ────────────────────────
            _SectionHeader(
              number: 'II',
              label: 'تكلفة البضاعة المباعة',
              subtitle: 'Costo del venduto — COGS',
            ),
            _LineRow(
              label: 'تكلفة الأدوية المباعة',
              value: -cogs,
              code: code,
              indent: true,
              deductionStyle: true,
            ),
            _SubtotalRow(
              label: 'إجمالي التكلفة (II)',
              value: -cogs,
              code: code,
              deductionStyle: true,
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── مجمل الربح التجاري ────────────────────────────────────────
            _IntermediateResult(
              label: 'مجمل الربح التجاري  (I − II)',
              subtitle: 'Margine lordo / Gross Profit',
              value: grossProfit,
              code: code,
              extraLine: 'هامش الربح الإجمالي: '
                  '${Formatters.number(grossMargin.toDouble())}%',
            ),
            const SizedBox(height: AppSpacing.md),

            // ── القسم (III): المصاريف التشغيلية ──────────────────────────
            _SectionHeader(
              number: 'III',
              label: 'المصاريف التشغيلية',
              subtitle: 'Costi operativi',
            ),
            ..._expenseRows(expensesByCategory, expenses, conv, code),
            _SubtotalRow(
              label: 'إجمالي المصاريف (III)',
              value: -expenses,
              code: code,
              deductionStyle: true,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── النتيجة النهائية ──────────────────────────────────────────
            _NetResult(
              value: netProfit,
              code: code,
              isLoss: isLoss,
            ),

            // ── تلميح صيغة الحساب ─────────────────────────────────────────
            const SizedBox(height: AppSpacing.md),
            Text(
              'صافي الربح = الإيرادات − تكلفة المبيعات − المصاريف'
              '   |   (I) − (II) − (III)',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _expenseRows(Map<String, double> byCategory,
      double totalExpenses, double Function(double) conv, String code) {
    if (byCategory.isEmpty) {
      if (totalExpenses <= 0) {
        return [
          const _EmptySection(label: 'لا توجد مصاريف مسجَّلة في هذه الفترة'),
        ];
      }
      // Expenses still loading — show aggregated total as single line
      return [
        _LineRow(
          label: 'المصاريف التشغيلية',
          value: -conv(totalExpenses),
          code: code,
          indent: true,
          deductionStyle: true,
        ),
      ];
    }
    // Sort by amount descending
    final sorted = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final entry in sorted)
        _LineRow(
          label: entry.key,
          value: -conv(entry.value),
          code: code,
          indent: true,
          deductionStyle: true,
        ),
    ];
  }
}

// ── مكوّنات القائمة ──────────────────────────────────────────────────────────

class _PlHeader extends StatelessWidget {
  const _PlHeader({required this.period, required this.code});

  final ReportPeriod period;
  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.balance, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.profitReportTitle,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'من ${AppDate.ymd(period.start)} إلى ${AppDate.ymd(period.end)}'
          '${code.isNotEmpty ? '  •  بالعملة: $code' : ''}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: AppSpacing.md),
        Divider(
            thickness: 2,
            color: theme.extension<AppSemanticColors>()!.border),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.number,
    required this.label,
    required this.subtitle,
  });

  final String number;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: AppRadius.brSm,
        border: Border(
          right: BorderSide(
              color: theme.colorScheme.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.label,
    required this.value,
    required this.code,
    this.detail,
    this.indent = false,
    this.deductionStyle = false,
  });

  final String label;
  final String? detail;
  final double value;
  final String code;
  final bool indent;
  final bool deductionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final absVal = value.abs();
    final color = deductionStyle
        ? theme.colorScheme.error.withValues(alpha: 0.85)
        : theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: indent ? AppSpacing.xl : 0,
        bottom: 6,
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: theme.hintColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (detail != null) ...[
            Text(detail!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor)),
            const SizedBox(width: AppSpacing.md),
          ],
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              deductionStyle
                  ? '( ${Formatters.money(absVal, code)} )'
                  : Formatters.money(absVal, code),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtotalRow extends StatelessWidget {
  const _SubtotalRow({
    required this.label,
    required this.value,
    required this.code,
    this.deductionStyle = false,
  });

  final String label;
  final double value;
  final String code;
  final bool deductionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final absVal = value.abs();
    final color = deductionStyle
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: theme.extension<AppSemanticColors>()!.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              deductionStyle
                  ? '( ${Formatters.money(absVal, code)} )'
                  : Formatters.money(absVal, code),
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntermediateResult extends StatelessWidget {
  const _IntermediateResult({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.code,
    this.extraLine,
  });

  final String label;
  final String subtitle;
  final double value;
  final String code;
  final String? extraLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNeg = value < 0;
    final color = isNeg ? theme.colorScheme.error : context.semantic.success;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: AppRadius.brSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700, color: color)),
                Text(subtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
                if (extraLine != null)
                  Text(extraLine!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: color, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.money(value, code),
              style: theme.textTheme.titleMedium?.copyWith(
                  color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetResult extends StatelessWidget {
  const _NetResult({
    required this.value,
    required this.code,
    required this.isLoss,
  });

  final double value;
  final String code;
  final bool isLoss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isLoss ? theme.colorScheme.error : context.semantic.success;
    final label = isLoss ? 'صافي الخسارة' : 'صافي الربح';
    final icon = isLoss ? Icons.trending_down : Icons.trending_up;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'النتيجة الصافية للفترة  •  (I) − (II) − (III)',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.money(value.abs(), code),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm, horizontal: AppSpacing.xl),
      child: Text(
        label,
        style:
            theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
      ),
    );
  }
}

// ── قسم تفاصيل الفواتير ────────────────────────────────────────────────────

class _InvoicesSection extends StatelessWidget {
  const _InvoicesSection({
    required this.report,
    required this.conv,
    required this.code,
    required this.expanded,
    required this.onToggle,
    required this.gridManager,
    required this.onGridLoaded,
    required this.fInvoice,
    required this.fDate,
    required this.fPayment,
    required this.fRevenue,
    required this.fCost,
    required this.fProfit,
    required this.fOriginal,
  });

  final ProfitReport report;
  final double Function(double) conv;
  final String code;
  final bool expanded;
  final VoidCallback onToggle;
  final TrinaGridStateManager? gridManager;
  final ValueChanged<TrinaGridStateManager> onGridLoaded;
  final String fInvoice, fDate, fPayment, fRevenue, fCost, fProfit, fOriginal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: theme.extension<AppSemanticColors>()!.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'تفاصيل الفواتير  (${report.invoicesCount})',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  AppGridColumnsButton(managerGetter: () => gridManager),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(
                height: 1,
                color: theme.extension<AppSemanticColors>()!.border),
            SizedBox(
              height: 420,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: AppGrid(
                  key: ValueKey(Object.hash(
                    code,
                    report.invoices.length,
                    Object.hashAllUnordered(report.invoices.map((i) =>
                        Object.hash(
                            i.invoiceNumber, i.revenue, i.cost, i.profit))),
                  )),
                  columns: _columns(context),
                  rows: _rows(),
                  onLoaded: onGridLoaded,
                  rowColorCallback: (ctx) {
                    final p = ctx.row.cells[fProfit]?.value;
                    return (p is num && p < 0)
                        ? Colors.red.withValues(alpha: 0.05)
                        : Colors.transparent;
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<TrinaColumn> _columns(BuildContext context) => [
        appGridTextColumn(AppStrings.invoiceLabel, fInvoice, width: 130),
        appGridTextColumn(AppStrings.dateColumn, fDate,
            width: 105, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn(AppStrings.paymentMethod, fPayment,
            width: 110, hide: true),
        appGridNumberColumn(AppStrings.revenueShort, fRevenue, width: 120),
        appGridNumberColumn(AppStrings.costShort, fCost, width: 120),
        appGridNumberColumn(AppStrings.profitShort, fProfit,
            width: 120,
            renderer: (ctx) {
              final v = ctx.cell.value;
              final n = v is num ? v.toDouble() : 0.0;
              if (n == 0) return const SizedBox.shrink();
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  Formatters.number(n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: n >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
        appGridTextColumn(AppStrings.originalCurrency, fOriginal,
            width: 140, hide: true),
      ];

  List<TrinaRow> _rows() => [
        for (final inv in report.invoices)
          TrinaRow(cells: {
            fInvoice: TrinaCell(
                value: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}'),
            fDate: TrinaCell(value: AppDate.ymd(inv.saleDate)),
            fPayment: TrinaCell(value: _payLabel(inv.paymentMethod)),
            fRevenue: TrinaCell(value: conv(inv.revenue)),
            fCost: TrinaCell(value: conv(inv.cost)),
            fProfit: TrinaCell(value: conv(inv.profit)),
            fOriginal: TrinaCell(
                value: inv.originalCurrencyCode.isEmpty
                    ? ''
                    : '${Formatters.money(inv.revenue * inv.originalExchangeRate)} ${inv.originalCurrencyCode}'),
          }),
      ];

  static String _payLabel(int method) =>
      method >= 1 && method <= 6 ? PaymentMethod.fromWire(method).label : '—';
}
