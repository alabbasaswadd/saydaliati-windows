import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// تقرير كشف الحساب — اختر حساباً (زبون / صندوق / أي حساب) لعرض حركاته
/// مع الرصيد المتراكم خلال الفترة المحدَّدة.
class AccountReportPage extends ConsumerStatefulWidget {
  const AccountReportPage({super.key});

  @override
  ConsumerState<AccountReportPage> createState() => _AccountReportPageState();
}

class _AccountReportPageState extends ConsumerState<AccountReportPage> {
  Account? _selected;
  ReportPeriod _period = ReportPeriod.month();

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsListProvider);
    final accounts = accountsAsync.value ?? const <Account>[];

    return ReportScaffold(
      title: 'كشف حساب',
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: _selected == null
          ? null
          : () => ref.invalidate(accountStatementProvider),
      inlineFilters: [
        SizedBox(
          width: 320,
          child: AccountPickerField(
            accounts: accounts,
            selectedId: _selected?.id,
            label: 'الحساب',
            hint: 'اختر حساباً لعرض كشفه',
            leafOnly: false,
            onSelected: (a) => setState(() => _selected = a),
          ),
        ),
      ],
      body: _selected == null
          ? _emptyHint(context)
          : _StatementBody(
              account: _selected!,
              period: _period,
            ),
    );
  }

  Widget _emptyHint(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'اختر حساباً من القائمة أعلاه\nلعرض كشف حركاته',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}

class _StatementBody extends ConsumerWidget {
  const _StatementBody({required this.account, required this.period});

  final Account account;
  final ReportPeriod period;

  static const _fDate = 'date';
  static const _fDesc = 'desc';
  static const _fDebit = 'debit';
  static const _fCredit = 'credit';
  static const _fBalance = 'balance';
  static const _fCurrency = 'currency';
  static const _fOrigDebit = 'origDebit';
  static const _fOrigCredit = 'origCredit';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(accountStatementProvider(
      account.id,
      from: period.start.toUtc(),
      to: period.end.toUtc(),
    ));

    return async.when(
      loading: () => const LoadingState(),
      error: (e, _) => ErrorState.fromError(
        e,
        onRetry: () => ref.invalidate(accountStatementProvider),
      ),
      data: (statement) {
        final totalDebit =
            statement.entries.fold<double>(0, (s, e) => s + e.debit);
        final totalCredit =
            statement.entries.fold<double>(0, (s, e) => s + e.credit);
        final totalOrigDebit =
            statement.entries.fold<double>(0, (s, e) => s + e.originalDebit);
        final totalOrigCredit =
            statement.entries.fold<double>(0, (s, e) => s + e.originalCredit);
        final base = statement.baseCurrencyCode;
        final ownRaw = statement.accountCurrencyCode;
        final own = (ownRaw == null || ownRaw == base) ? null : ownRaw;

        return Column(
          children: [
            _summaryBar(context, statement),
            Expanded(
              child: statement.entries.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_outlined,
                      message: 'لا توجد حركات في هذه الفترة')
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                      child: _grid(context, statement),
                    ),
            ),
            if (statement.entries.isNotEmpty)
              _totalsBar(
                context,
                statement,
                totalDebit: totalDebit,
                totalCredit: totalCredit,
                totalOrigDebit: totalOrigDebit,
                totalOrigCredit: totalOrigCredit,
                base: base,
                own: own,
              ),
          ],
        );
      },
    );
  }

  Widget _summaryBar(BuildContext context, AccountStatement statement) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
            bottom: BorderSide(
                color: theme.extension<AppSemanticColors>()!.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_outlined,
              size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(account.name,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(width: AppSpacing.lg),
          _balanceChip(theme, 'الرصيد الافتتاحي', statement.openingBalance,
              statement.baseCurrencyCode),
          const SizedBox(width: AppSpacing.lg),
          _balanceChip(theme, 'الرصيد الختامي', statement.closingBalance,
              statement.baseCurrencyCode),
          const Spacer(),
          if (statement.accountCurrencyCode != null &&
              statement.accountCurrencyCode != statement.baseCurrencyCode)
            _currencyNote(theme,
                'عملة الحساب: ${statement.accountCurrencyCode}'),
        ],
      ),
    );
  }

  Widget _totalsBar(
    BuildContext context,
    AccountStatement statement, {
    required double totalDebit,
    required double totalCredit,
    required double totalOrigDebit,
    required double totalOrigCredit,
    required String? base,
    required String? own,
  }) {
    final theme = Theme.of(context);
    final net = totalDebit - totalCredit;
    final netColor =
        net > 0 ? theme.colorScheme.error : context.semantic.success;

    String amt(double v, {String? code}) {
      final s = Formatters.number(v.abs());
      return code != null ? '$s $code' : s;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
            top: BorderSide(
                color: theme.extension<AppSemanticColors>()!.border,
                width: 1.5)),
      ),
      child: Row(
        children: [
          _totalChip(theme, 'مجموع المدين', amt(totalDebit, code: base),
              icon: Icons.arrow_upward, color: theme.colorScheme.error),
          const SizedBox(width: AppSpacing.lg),
          _totalChip(theme, 'مجموع الدائن', amt(totalCredit, code: base),
              icon: Icons.arrow_downward, color: context.semantic.success),
          const SizedBox(width: AppSpacing.lg),
          _totalChip(
            theme,
            'صافي الحركة',
            '${net > 0 ? '+' : net < 0 ? '-' : ''}${amt(net, code: base)}',
            icon: Icons.balance,
            color: netColor,
          ),
          if (own != null) ...[
            const VerticalDivider(width: AppSpacing.xl),
            _totalChip(theme, 'مدين ($own)', amt(totalOrigDebit, code: own),
                icon: Icons.arrow_upward,
                color: theme.colorScheme.error.withValues(alpha: 0.7)),
            const SizedBox(width: AppSpacing.lg),
            _totalChip(theme, 'دائن ($own)', amt(totalOrigCredit, code: own),
                icon: Icons.arrow_downward,
                color: context.semantic.success.withValues(alpha: 0.7)),
          ],
          const Spacer(),
          Text(
            '${statement.entries.length} حركة',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _totalChip(ThemeData theme, String label, String value,
      {required IconData icon, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.hintColor)),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                    color: color, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _currencyNote(ThemeData theme, String text) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.brSm,
        ),
        child: Text(text,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.primary)),
      );

  Widget _balanceChip(
      ThemeData theme, String label, double value, String? code) {
    final color = value < 0
        ? theme.colorScheme.error
        : theme.extension<AppSemanticColors>()!.success;
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
            if (code != null) ...[
              const SizedBox(width: 4),
              Text(code,
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
    final ownRaw = statement.accountCurrencyCode;
    final own = (ownRaw == null || ownRaw == base) ? null : ownRaw;
    String amountTitle(String label) => base == null ? label : '$label ($base)';

    return AppGrid(
      columns: [
        appGridTextColumn('التاريخ', _fDate,
            width: 150, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn('البيان', _fDesc, width: 260, flexible: true),
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
          final color = n < 0
              ? Theme.of(context).colorScheme.error
              : context.semantic.success;
          return _amountCell(Formatters.number(n),
              color: color, bold: true);
        }),
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
            _fDate: TrinaCell(value: AppDate.ymdHm(e.date.toLocal())),
            _fDesc: TrinaCell(value: e.description),
            _fCurrency: TrinaCell(value: e.currencyCode ?? ''),
            _fDebit: TrinaCell(value: e.debit),
            _fCredit: TrinaCell(value: e.credit),
            _fBalance: TrinaCell(value: e.runningBalance),
            if (own != null) ...{
              _fOrigDebit: TrinaCell(value: e.originalDebit),
              _fOrigCredit: TrinaCell(value: e.originalCredit),
            },
          }),
      ],
    );
  }

  Widget _amountCell(String text, {Color? color, bool bold = false}) =>
      Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: color, fontWeight: bold ? FontWeight.w700 : null),
        ),
      );
}
