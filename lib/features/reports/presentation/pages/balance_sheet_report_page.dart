import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// الميزانية العمومية — IFRS / عرض عمودي متعدد المستويات.
///
/// البيانات: أرصدة الحسابات الحالية من [accountsListProvider].
/// لا endpoint جديد — كل ما يلزم موجود في [Account.currentBalance].
///
///   (I)   الأصول          Assets
///   (II)  الالتزامات      Liabilities
///   (III) حقوق الملكية   Equity
///
/// معادلة الميزانية:  الأصول = الالتزامات + حقوق الملكية
class BalanceSheetReportPage extends ConsumerStatefulWidget {
  const BalanceSheetReportPage({super.key});

  @override
  ConsumerState<BalanceSheetReportPage> createState() =>
      _BalanceSheetReportPageState();
}

class _BalanceSheetReportPageState
    extends ConsumerState<BalanceSheetReportPage> {
  int _level = 2;

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsListProvider);
    final base = ref.watch(baseCurrencyProvider);
    final baseCode = base?.code ?? '';

    return ReportScaffold(
      title: 'الميزانية العمومية',
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: 6),
          child: SegmentedButton<int>(
            style: SegmentedButton.styleFrom(
              minimumSize: const Size(60, 34),
              textStyle: const TextStyle(fontSize: 13),
            ),
            segments: const [
              ButtonSegment(value: 1, label: Text('المستوى 1')),
              ButtonSegment(value: 2, label: Text('المستوى 2')),
              ButtonSegment(value: 3, label: Text('المستوى 3')),
            ],
            selected: {_level},
            onSelectionChanged: (s) => setState(() => _level = s.first),
          ),
        ),
      ],
      onRefresh: () => ref.invalidate(accountsListProvider),
      body: accountsAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(accountsListProvider),
        ),
        data: (all) => _BalanceSheetBody(
          accounts: all.where((a) => a.isActive).toList(),
          level: _level,
          baseCode: baseCode,
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Tree node
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BsNode {
  _BsNode(this.account);
  final Account account;
  final List<_BsNode> children = [];

  /// Leaf → own balance; parent → sum of all direct children's balances.
  double get balance {
    if (children.isEmpty) return account.currentBalance;
    return children.fold(0.0, (s, c) => s + c.balance);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Body — builds tree and three sections
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BalanceSheetBody extends StatelessWidget {
  const _BalanceSheetBody({
    required this.accounts,
    required this.level,
    required this.baseCode,
  });

  final List<Account> accounts;
  final int level;
  final String baseCode;

  @override
  Widget build(BuildContext context) {
    // ── Build tree ────────────────────────────────────────────────────────
    final map = <String, _BsNode>{
      for (final a in accounts) a.id: _BsNode(a),
    };
    for (final a in accounts) {
      final pid = a.parentId;
      if (pid != null) map[pid]?.children.add(map[a.id]!);
    }
    for (final n in map.values) {
      n.children.sort((a, b) => a.account.code.compareTo(b.account.code));
    }

    // ── Section roots ─────────────────────────────────────────────────────
    final assetRoots =
        _sectionRoots(map, {AccountType.asset, AccountType.contraAsset});
    final liabRoots = _sectionRoots(map, {AccountType.liability});
    final equityRoots = _sectionRoots(map, {AccountType.equity});

    // ── Totals ────────────────────────────────────────────────────────────
    double sectionTotal(List<_BsNode> roots) => roots.fold(0.0, (s, n) {
          return s +
              (n.account.accountType == AccountType.contraAsset
                  ? -n.balance
                  : n.balance);
        });

    final totalAssets = sectionTotal(assetRoots);
    final totalLiab = sectionTotal(liabRoots);
    final totalEquity = sectionTotal(equityRoots);

    // ── Net income (Revenue − Expense) ────────────────────────────────────
    // أرباح الفترة غير المقفَلة تظل في حسابات الإيرادات والمصروفات؛
    // تُضاف إلى حقوق الملكية لإتمام معادلة الميزانية.
    final totalRevenue = accounts
        .where((a) => a.accountType == AccountType.revenue)
        .fold<double>(0, (s, a) => s + a.currentBalance);
    final totalExpense = accounts
        .where((a) => a.accountType == AccountType.expense)
        .fold<double>(0, (s, a) => s + a.currentBalance);
    final netIncome = totalRevenue - totalExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BsHeader(baseCode: baseCode),
          const SizedBox(height: AppSpacing.lg),

          // ── (I) Assets ───────────────────────────────────────────────
          _BsSection(
            number: 'I',
            label: 'الأصول',
            subtitle: 'Assets',
            nodes: assetRoots,
            level: level,
            total: totalAssets,
            totalLabel: 'إجمالي الأصول (I)',
            baseCode: baseCode,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── (II) Liabilities ─────────────────────────────────────────
          _BsSection(
            number: 'II',
            label: 'الالتزامات',
            subtitle: 'Liabilities',
            nodes: liabRoots,
            level: level,
            total: totalLiab,
            totalLabel: 'إجمالي الالتزامات (II)',
            baseCode: baseCode,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── (III) Equity ─────────────────────────────────────────────
          _BsSection(
            number: 'III',
            label: 'حقوق الملكية',
            subtitle: 'Equity',
            nodes: equityRoots,
            level: level,
            total: totalEquity,
            totalLabel: 'إجمالي حقوق الملكية (III)',
            baseCode: baseCode,
            netIncome: netIncome,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Equation check ───────────────────────────────────────────
          _BsEquation(
            netAssets: totalAssets,
            totalLiab: totalLiab,
            totalEquity: totalEquity + netIncome,
            baseCode: baseCode,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  /// Returns the top-level nodes for a section — accounts whose type belongs
  /// to [types] but whose parent's type does NOT (or who have no parent).
  static List<_BsNode> _sectionRoots(
      Map<String, _BsNode> map, Set<AccountType> types) {
    final out = <_BsNode>[];
    for (final n in map.values) {
      if (!types.contains(n.account.accountType)) continue;
      final pid = n.account.parentId;
      final parentInSection = pid != null &&
          map[pid] != null &&
          types.contains(map[pid]!.account.accountType);
      if (!parentInSection) out.add(n);
    }
    out.sort((a, b) => a.account.code.compareTo(b.account.code));
    return out;
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Section card
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BsSection extends StatelessWidget {
  const _BsSection({
    required this.number,
    required this.label,
    required this.subtitle,
    required this.nodes,
    required this.level,
    required this.total,
    required this.totalLabel,
    required this.baseCode,
    this.netIncome,
  });

  final String number;
  final String label;
  final String subtitle;
  final List<_BsNode> nodes;
  final int level;
  final double total;
  final String totalLabel;
  final String baseCode;
  /// صافي الربح/الخسارة للفترة — يُعرض فقط في قسم حقوق الملكية.
  final double? netIncome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int maxDepth = level - 1;
    final flat = _flatten(nodes, maxDepth);
    final ni = netIncome;
    final hasNetIncome = ni != null && ni.abs() > 0.001;
    final isEmpty = flat.isEmpty && !hasNetIncome;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: theme.extension<AppSemanticColors>()!.border, width: 1.5),
      ),
      child: Column(
        children: [
          _BsSectionHeader(
              number: number, label: label, subtitle: subtitle),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'لا توجد حسابات في هذا القسم',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            for (int i = 0; i < flat.length; i++)
              _BsRow(
                node: flat[i].$2,
                depth: flat[i].$1,
                isLast: i == flat.length - 1 && !hasNetIncome,
                baseCode: baseCode,
              ),
            if (hasNetIncome)
              _BsNetIncomeRow(value: ni!, baseCode: baseCode),
          ],
          _BsSectionTotal(
              label: totalLabel,
              value: total + (netIncome ?? 0),
              baseCode: baseCode),
        ],
      ),
    );
  }

  static List<(int, _BsNode)> _flatten(
      List<_BsNode> nodes, int maxDepth) {
    final out = <(int, _BsNode)>[];
    void visit(List<_BsNode> ns, int d) {
      for (final n in ns) {
        out.add((d, n));
        if (d < maxDepth) visit(n.children, d + 1);
      }
    }
    visit(nodes, 0);
    return out;
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Row widgets
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BsSectionHeader extends StatelessWidget {
  const _BsSectionHeader({
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                color: theme.colorScheme.primary, shape: BoxShape.circle),
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

class _BsRow extends StatelessWidget {
  const _BsRow({
    required this.node,
    required this.depth,
    required this.baseCode,
    this.isLast = false,
  });

  final _BsNode node;
  final int depth;
  final String baseCode;
  final bool isLast;

  static const _indentPerLevel = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = node.account;
    final balance = node.balance;
    final isContra = a.accountType == AccountType.contraAsset;

    final balanceColor = isContra
        ? theme.colorScheme.error
        : balance < 0
            ? theme.colorScheme.error
            : null;

    final nameStyle = switch (depth) {
      0 => theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      1 => theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      _ => theme.textTheme.bodySmall,
    };

    final balanceStyle = switch (depth) {
      0 => theme.textTheme.bodyMedium
          ?.copyWith(fontWeight: FontWeight.w700, color: balanceColor),
      1 => theme.textTheme.bodyMedium?.copyWith(color: balanceColor),
      _ => theme.textTheme.bodySmall?.copyWith(color: balanceColor),
    };

    final border = isLast
        ? null
        : Border(
            bottom: BorderSide(
              color: theme.extension<AppSemanticColors>()!.border.withValues(
                  alpha: depth == 0 ? 1.0 : 0.4),
            ),
          );

    return Container(
      decoration: BoxDecoration(border: border),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md + depth * _indentPerLevel,
          0,
          AppSpacing.md,
          0,
        ),
        child: Row(
          children: [
            // Hierarchy bullet
            if (depth > 0) ...[
              Icon(Icons.subdirectory_arrow_left_rounded,
                  size: 14, color: theme.hintColor.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
            ],
            // Account code
            if (a.code.isNotEmpty) ...[
              Text(a.code,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.hintColor)),
              const SizedBox(width: AppSpacing.sm),
            ],
            // Account name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(a.name, style: nameStyle),
              ),
            ),
            // Balance
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                isContra
                    ? '( ${Formatters.number(balance.abs())} )'
                    : Formatters.number(balance),
                style: balanceStyle,
              ),
            ),
            if (baseCode.isNotEmpty && depth == 0) ...[
              const SizedBox(width: 4),
              Text(baseCode,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.hintColor)),
            ],
          ],
        ),
      ),
    );
  }
}

class _BsNetIncomeRow extends StatelessWidget {
  const _BsNetIncomeRow({required this.value, required this.baseCode});

  final double value;
  final String baseCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoss = value < 0;
    final color = isLoss ? theme.colorScheme.error : context.semantic.success;
    final label = isLoss ? 'خسارة الفترة الحالية' : 'صافي ربح الفترة الحالية';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.extension<AppSemanticColors>()!.border
                .withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 10),
        child: Row(
          children: [
            Icon(isLoss ? Icons.trending_down : Icons.trending_up,
                size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500, color: color)),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                Formatters.number(value.abs()),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500, color: color),
              ),
            ),
            if (baseCode.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(baseCode,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.hintColor)),
            ],
          ],
        ),
      ),
    );
  }
}

class _BsSectionTotal extends StatelessWidget {
  const _BsSectionTotal({
    required this.label,
    required this.value,
    required this.baseCode,
  });

  final String label;
  final double value;
  final String baseCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        value < 0 ? theme.colorScheme.error : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(
          top: BorderSide(
              color: theme.extension<AppSemanticColors>()!.border,
              width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${Formatters.number(value)}  $baseCode',
              style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Header & Equation check
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class _BsHeader extends StatelessWidget {
  const _BsHeader({required this.baseCode});
  final String baseCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance,
                size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'الميزانية العمومية',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'كما في: ${AppDate.ymd(DateTime.now())}'
          '${baseCode.isNotEmpty ? '  •  بالعملة: $baseCode' : ''}',
          textAlign: TextAlign.center,
          style:
              theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

class _BsEquation extends StatelessWidget {
  const _BsEquation({
    required this.netAssets,
    required this.totalLiab,
    required this.totalEquity,
    required this.baseCode,
  });

  final double netAssets;
  final double totalLiab;
  final double totalEquity;
  final String baseCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final liabEquity = totalLiab + totalEquity;
    final diff = (netAssets - liabEquity).abs();
    final isBalanced = diff < 0.01;
    final color = isBalanced
        ? context.semantic.success
        : theme.colorScheme.error;
    final icon =
        isBalanced ? Icons.check_circle_outline : Icons.error_outline;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      color: color.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  isBalanced
                      ? 'الميزانية متوازنة'
                      : 'تحذير: الميزانية غير متوازنة',
                  style: theme.textTheme.titleSmall?.copyWith(
                      color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${Formatters.number(netAssets)} $baseCode'
                '  =  '
                '${Formatters.number(totalLiab)} + ${Formatters.number(totalEquity)}'
                ' $baseCode',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'الأصول  =  الالتزامات + حقوق الملكية (شاملاً صافي الربح)',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.hintColor),
            ),
            if (!isBalanced) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'الفرق: ${Formatters.number(diff)} $baseCode'
                '  —  قد يكون بسبب أرباح لم تُقفَل بعد',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
