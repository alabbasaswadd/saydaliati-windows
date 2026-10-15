import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// كشف حساب — حركات حساب واحد (مدين/دائن) مع الرصيد المتراكم، والرصيد
/// الافتتاحي/الختامي للفترة المحدَّدة. بلا فترة = كل التاريخ.
class AccountStatementPage extends ConsumerStatefulWidget {
  const AccountStatementPage({required this.account, super.key});

  final Account account;

  @override
  ConsumerState<AccountStatementPage> createState() => _AccountStatementPageState();
}

class _AccountStatementPageState extends ConsumerState<AccountStatementPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ReportPeriod? _period;

  static const _fDate = 'date';
  static const _fDesc = 'desc';
  static const _fDebit = 'debit';
  static const _fCredit = 'credit';
  static const _fBalance = 'balance';
  static const _fCurrency = 'currency';
  static const _fOrigDebit = 'origDebit';
  static const _fOrigCredit = 'origCredit';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(accountStatementProvider(
      widget.account.id,
      from: _period?.start.toUtc(),
      to: _period?.end.toUtc(),
    ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('كشف حساب — ${widget.account.name}'),
        actions: [
          IconButton(
            tooltip: 'تصفية بالفترة',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Badge(
              isLabelVisible: _period != null,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      endDrawer: FilterSideSheet(
        onClear: _period != null ? () => setState(() => _period = null) : null,
        children: [
          Text('الفترة', style: theme.textTheme.labelLarge),
          PeriodFilterList(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(accountStatementProvider)),
        data: (statement) => Column(
          children: [
            _summaryBar(theme, statement),
            Expanded(
              child: statement.entries.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_outlined, message: 'لا توجد حركات')
                  : Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: _grid(context, statement),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryBar(ThemeData theme, AccountStatement statement) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(bottom: BorderSide(color: theme.extension<AppSemanticColors>()!.border)),
      ),
      child: Row(
        children: [
          _balanceChip(theme, 'الرصيد الافتتاحي', statement.openingBalance,
              statement.baseCurrencyCode),
          const SizedBox(width: AppSpacing.lg),
          _balanceChip(theme, 'الرصيد الختامي', statement.closingBalance,
              statement.baseCurrencyCode),
          const Spacer(),
          // وحدة القياس تُقال صريحةً: كل أرقام الكشف بالعملة الأساسية، وعملة
          // الحساب الخاصة (إن كان صندوق عملة) شيء آخر يُعرض في عمودَيه.
          if (statement.accountCurrencyCode != null)
            _currencyNote(theme,
                'عملة الحساب: ${statement.accountCurrencyCode}'),
        ],
      ),
    );
  }

  Widget _currencyNote(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(text,
          style: theme.textTheme.labelMedium
              ?.copyWith(color: theme.colorScheme.primary)),
    );
  }

  Widget _balanceChip(
      ThemeData theme, String label, double value, String? currencyCode) {
    final color = value < 0 ? theme.colorScheme.error : theme.extension<AppSemanticColors>()!.success;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                Formatters.number(value),
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ),
            if (currencyCode != null) ...[
              const SizedBox(width: 4),
              Text(currencyCode,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.hintColor)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _grid(BuildContext context, AccountStatement statement) {
    final base = statement.baseCurrencyCode;
    final own = statement.accountCurrencyCode;
    String amountTitle(String label) => base == null ? label : '$label ($base)';

    return AppGrid(
      columns: [
        appGridTextColumn('التاريخ', _fDate,
            width: 110, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn('البيان', _fDesc, width: 260, flexible: true),
        // عملة إدخال السند — تُميّز سنداً كُتب بالدولار عن آخر كُتب بالأساسية
        // رغم أن كلا المبلغين معروضان بالأساسية.
        appGridTextColumn('العملة', _fCurrency,
            width: 90, textAlign: TrinaColumnTextAlign.center),
        appGridNumberColumn(amountTitle('مدين'), _fDebit, width: 130,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          return _amountCell(n == 0 ? '' : Formatters.number(n));
        }),
        appGridNumberColumn(amountTitle('دائن'), _fCredit, width: 130,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          return _amountCell(n == 0 ? '' : Formatters.number(n));
        }),
        appGridNumberColumn(amountTitle('الرصيد المتراكم'), _fBalance,
            width: 150, renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          final color =
              n < 0 ? Theme.of(context).colorScheme.error : context.semantic.success;
          return _amountCell(Formatters.number(n), color: color, bold: true);
        }),
        // صناديق العملات وحدها تحمل مبالغ بعملتها، مجمَّدة لحظة الترحيل.
        if (own != null) ...[
          appGridNumberColumn('مدين ($own)', _fOrigDebit, width: 130,
              renderer: (ctx) {
            final v = ctx.cell.value;
            final n = v is num ? v.toDouble() : 0.0;
            return _amountCell(n == 0 ? '' : Formatters.number(n));
          }),
          appGridNumberColumn('دائن ($own)', _fOrigCredit, width: 130,
              renderer: (ctx) {
            final v = ctx.cell.value;
            final n = v is num ? v.toDouble() : 0.0;
            return _amountCell(n == 0 ? '' : Formatters.number(n));
          }),
        ],
      ],
      rows: [
        for (final e in statement.entries)
          TrinaRow(cells: {
            _fDate: TrinaCell(value: AppDate.ymd(e.date)),
            _fDesc: TrinaCell(value: e.description),
            _fCurrency: TrinaCell(value: e.currencyCode ?? ''),
            _fDebit: TrinaCell(value: e.debit),
            _fCredit: TrinaCell(value: e.credit),
            _fBalance: TrinaCell(value: e.runningBalance),
            if (statement.accountCurrencyCode != null) ...{
              _fOrigDebit: TrinaCell(value: e.originalDebit),
              _fOrigCredit: TrinaCell(value: e.originalCredit),
            },
          }),
      ],
    );
  }

  Widget _amountCell(String text, {Color? color, bool bold = false}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: bold ? FontWeight.w700 : null),
      ),
    );
  }
}
