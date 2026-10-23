import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/pages/account_form_dialog.dart';
import 'package:saydaliati/features/accounts/presentation/pages/account_statement_page.dart';
import 'package:saydaliati/features/accounts/presentation/pages/opening_balance_dialog.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// دليل الحسابات — شجرة (أب/أبناء) مع الرصيد الحالي لكل حساب. نقرة مزدوجة على
/// الصف تفتح تعديل الحساب؛ وزر الحذف يظهر للحسابات القابلة للحذف وحدها.
class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  static const _fName = 'name';
  static const _fCode = 'code';
  static const _fType = 'type';
  static const _fBalance = 'balance';
  static const _fActions = 'actions';
  static const _fId = '_id';

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      List<Account> accounts, [Account? existing]) async {
    final saved =
        await showAccountFormDialog(context, accounts: accounts, existing: existing);
    if (saved != true || !context.mounted) return;
    ref.invalidate(accountsListProvider);
    AppSnackbar.success(
      context,
      existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Account a) async {
    if (a.isSystem) {
      await showErrorDialog(context, message: 'لا يمكن حذف حساب أساسي من دليل الحسابات');
      return;
    }
    final ok = await showDeleteConfirmationDialog(context, itemName: a.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(accountRepositoryProvider).delete(a.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(accountsListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  void _openStatement(BuildContext context, Account a) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => AccountStatementPage(account: a),
    ));
  }

  Future<void> _openingBalance(BuildContext context, WidgetRef ref, Account a) async {
    final saved = await showOpeningBalanceDialog(context, account: a);
    if (saved != true || !context.mounted) return;
    ref.invalidate(accountsListProvider);
    AppSnackbar.success(context, 'تمّ تسجيل الرصيد الافتتاحي');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(accountsListProvider);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الحسابات'),
        actions: [
          AppRefreshButton(
            onRefresh: () => ref.refresh(accountsListProvider.future),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: SizedBox(
              height: 36,
              child: FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إضافة حساب'),
                onPressed: () =>
                    _addOrEdit(context, ref, async.value ?? const <Account>[]),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(accountsListProvider)),
        data: (accounts) => accounts.isEmpty
            ? const EmptyState(
                icon: Icons.account_balance_outlined, message: 'لا توجد حسابات')
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _AccountsGrid(
                  accounts: accounts,
                  currencies: currencies,
                  base: base,
                  onEdit: (a) => _addOrEdit(context, ref, accounts, a),
                  onDelete: (a) => _delete(context, ref, a),
                  onOpenStatement: (a) => _openStatement(context, a),
                  onOpeningBalance: (a) => _openingBalance(context, ref, a),
                ),
              ),
      ),
    );
  }
}

class _AccountsGrid extends StatefulWidget {
  const _AccountsGrid({
    required this.accounts,
    required this.currencies,
    required this.base,
    required this.onEdit,
    required this.onDelete,
    required this.onOpenStatement,
    required this.onOpeningBalance,
  });

  final List<Account> accounts;
  final List<Currency> currencies;
  final Currency? base;
  final ValueChanged<Account> onEdit;
  final ValueChanged<Account> onDelete;
  final ValueChanged<Account> onOpenStatement;
  final ValueChanged<Account> onOpeningBalance;

  @override
  State<_AccountsGrid> createState() => _AccountsGridState();
}

class _AccountsGridState extends State<_AccountsGrid> {
  TrinaGridStateManager? _manager;
  bool _lastHadFilter = false;

  /// البحث والتمدّد محفوظان عبر إعادة بناء الشبكة.
  ///
  /// مفتاح الشبكة مشتقّ من البيانات، فزرّ التحديث يبني `TrinaGrid` جديدة —
  /// فكان البحث يُمحى والشجرة تُطوى، ويعود المستخدم إلى الصفر بعد كل تحديث.
  /// تُسجَّل الحالة مع كل تغيير وتُعاد بعد البناء.
  List<TrinaRow<dynamic>>? _savedFilters;
  final Set<String> _expandedIds = {};

  /// أثناء الاستعادة لا تُسجَّل الحالة: الشبكة الجديدة تبدأ فارغة الفلترة
  /// مطويّةً، فتسجيلها حينها يمحو ما نحاول استعادته.
  bool _restoring = false;

  /// نتائج "الرصيد الإجمالي" المحسوبة عند الطلب لكل حساب — تُعرض كخط ملوَّن
  /// بجانب اسم الحساب (لا بوب أب)، وتبقى حتى يُعاد حسابها أو تتغيّر البيانات.
  final Map<String, double> _rollupResults = {};

  @override
  void dispose() {
    _manager?.removeListener(_onGridChanged);
    super.dispose();
  }

  /// عند تفعيل بحث/فلترة لأول مرة: تُوسَّع الشجرة كاملة — الفروع التي لا
  /// تحوي نتيجة مطابقة محذوفة أصلاً من العرض عبر فلترة TrinaGrid نفسها، فما
  /// يبقى ظاهراً بعد التوسيع هو فقط ما يحتوي النتيجة. لا تفعل شيئاً عند كل
  /// ضغطة حرف لاحقة (تفادياً لتوسيع متكرر)، فقط عند انتقال "بلا فلتر" → "بفلتر".
  void _onGridChanged() {
    final hasFilter = _manager?.hasFilter ?? false;
    if (hasFilter && !_lastHadFilter) {
      _manager?.expandAllRowGroups();
    }
    _lastHadFilter = hasFilter;

    if (!_restoring) _captureState();
  }

  /// يسجّل فلترة الأعمدة والمجموعات المفتوحة.
  void _captureState() {
    final m = _manager;
    if (m == null) return;

    _savedFilters = List<TrinaRow<dynamic>>.of(m.filterRows);

    _expandedIds.clear();
    for (final row in m.iterateAllRowGroup) {
      if (!row.type.group.expanded) continue;
      final id = row.cells[AccountsPage._fId]?.value?.toString();
      if (id != null) _expandedIds.add(id);
    }
  }

  /// يعيد الفلترة والتمدّد على الشبكة المبنيّة حديثاً.
  ///
  /// التمدّد يُطبَّق على **كل** مجموعة لا على الظاهر فقط: الحساب الحفيد لا
  /// يظهر قبل فتح أبيه، فالمرور على الظاهر وحده يفتح المستوى الأول فقط.
  void _restoreState(TrinaGridStateManager m) {
    if (_savedFilters == null && _expandedIds.isEmpty) return;

    _restoring = true;
    try {
      final filters = _savedFilters;
      if (filters != null && filters.isNotEmpty) {
        m.setFilterWithFilterRows(filters, notify: false);
      }

      for (final row in m.iterateAllRowGroup) {
        final id = row.cells[AccountsPage._fId]?.value?.toString();
        if (id == null || !_expandedIds.contains(id)) continue;
        m.toggleExpandedRowGroup(rowGroup: row, expanded: true, notify: false);
      }

      m.notifyListeners();
      _lastHadFilter = m.hasFilter;
    } finally {
      _restoring = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = widget.accounts;
    final onEdit = widget.onEdit;
    final onDelete = widget.onDelete;
    final onOpenStatement = widget.onOpenStatement;
    final byId = {for (final a in accounts) a.id: a};
    final childrenOf = <String?, List<Account>>{};
    for (final a in accounts) {
      childrenOf.putIfAbsent(a.parentId, () => []).add(a);
    }
    final roots = childrenOf[null] ?? const <Account>[];

    TrinaRow<dynamic> rowOf(Account a) {
      final cells = {
        AccountsPage._fName: TrinaCell(value: a.name),
        AccountsPage._fCode: TrinaCell(value: a.code),
        AccountsPage._fType: TrinaCell(value: a.accountType.label),
        // لحساب له عملة خاصة: رصيده الحقيقي بتلك العملة؛ غيره: بالأساسية.
        AccountsPage._fBalance: TrinaCell(
            value: a.currencyId != null ? a.currentBalanceForeign : a.currentBalance),
        AccountsPage._fId: TrinaCell(value: a.id),
      };
      final children = childrenOf[a.id];
      if (children == null || children.isEmpty) {
        return TrinaRow(cells: cells);
      }
      return TrinaRow(
        cells: cells,
        type: TrinaRowType.group(
          children: FilteredList(initialList: [for (final c in children) rowOf(c)]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.unfold_more, size: 18),
                label: const Text('توسيع الكل'),
                onPressed: () => _manager?.expandAllRowGroups(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.unfold_less, size: 18),
                label: const Text('طي الكل'),
                onPressed: () => _manager?.collapseAllRowGroups(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(child: _buildGrid(context, byId, childrenOf, roots, rowOf, onEdit,
            onDelete, onOpenStatement, widget.onOpeningBalance)),
      ],
    );
  }

  /// الرصيد الإجمالي لحساب بالعملة الأساسية: رصيده الخاص (محوَّلاً من عملته
  /// الخاصة إن وُجدت) + كل الفروع تحته (أولاد وأحفاد) تراكمياً، كلٌّ محوَّل
  /// لعملته هو قبل الجمع — فلا تُجمَع أرقام بعملات مختلفة كأنها عملة واحدة.
  double _rollupBalance(Account a, Map<String?, List<Account>> childrenOf) {
    var total = _ownBalanceInBase(a);
    for (final child in childrenOf[a.id] ?? const <Account>[]) {
      total += _rollupBalance(child, childrenOf);
    }
    return total;
  }

  /// رصيد الحساب نفسه (بلا فروع) مُحوَّلاً للعملة الأساسية.
  double _ownBalanceInBase(Account a) {
    if (a.currencyId == null) return a.currentBalance;
    final accountCurrency =
        widget.currencies.where((c) => c.id == a.currencyId).firstOrNull;
    return convertToBase(a.currentBalanceForeign, widget.base, accountCurrency);
  }

  /// يحسب (أو يُخفي) الرصيد الإجمالي لحساب — يظهر كخط ملوَّن بجانب اسمه
  /// بدل بوب أب، فنقرة ثانية على الأيقونة تُخفيه (تبديل).
  void _toggleRollup(Account a, Map<String?, List<Account>> childrenOf) {
    setState(() {
      if (_rollupResults.containsKey(a.id)) {
        _rollupResults.remove(a.id);
      } else {
        _rollupResults[a.id] = _rollupBalance(a, childrenOf);
      }
    });
  }

  Widget _buildGrid(
    BuildContext context,
    Map<String, Account> byId,
    Map<String?, List<Account>> childrenOf,
    List<Account> roots,
    TrinaRow<dynamic> Function(Account) rowOf,
    ValueChanged<Account> onEdit,
    ValueChanged<Account> onDelete,
    ValueChanged<Account> onOpenStatement,
    ValueChanged<Account> onOpeningBalance,
  ) {
    return AppGrid(
      // بلا مفتاح متغيّر لا يُعاد بناء TrinaGrid الداخلي عند تغيّر البيانات
      // (نفس نمط SimpleEntityGrid/المصاريف) — فزر الرفرش يُحدِّث المزوِّد لكن
      // الشبكة تبقى معروضة بصفوفها الأولى القديمة بلا هذا المفتاح.
      key: ValueKey(widget.accounts.length ^ widget.accounts.hashCode),
      tree: true,
      // تعديل الحساب بنقرة مزدوجة على صفه — بديل زر القلم الذي كان يتكرّر
      // في كل صف ويُثقل عمود الإجراءات.
      onRowDoubleTap: (e) {
        final a = byId[e.row.cells[AccountsPage._fId]?.value];
        if (a != null) onEdit(a);
      },
      onLoaded: (m) {
        _manager = m;
        m.addListener(_onGridChanged);
        // بعد اكتمال الإطار: الصفوف والمجموعات لم تُركَّب بعد أثناء onLoaded.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !identical(_manager, m)) return;
          _restoreState(m);
        });
      },
      columns: [
        appGridTextColumn('اسم الحساب', AccountsPage._fName, width: 260,
            renderer: (ctx) {
          final a = byId[ctx.row.cells[AccountsPage._fId]?.value];
          final rollup = a == null ? null : _rollupResults[a.id];
          if (rollup == null) return Text(ctx.cell.value?.toString() ?? '');
          final color =
              rollup < 0 ? Theme.of(context).colorScheme.error : context.semantic.success;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(ctx.cell.value?.toString() ?? '',
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppSpacing.xs),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  a?.currencyCode == null
                      ? Formatters.number(rollup)
                      : '${Formatters.number(rollup)} ${a!.currencyCode}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        }),
        appGridTextColumn('الرمز', AccountsPage._fCode, width: 100),
        appGridTextColumn('النوع', AccountsPage._fType, width: 110),
        appGridNumberColumn('الرصيد', AccountsPage._fBalance, width: 150,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          if (n == 0) return const SizedBox.shrink();
          final a = byId[ctx.row.cells[AccountsPage._fId]?.value];
          final color = n < 0
              ? Theme.of(context).colorScheme.error
              : context.semantic.success;
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              a?.currencyCode == null
                  ? Formatters.number(n)
                  : '${Formatters.number(n)} ${a!.currencyCode}',
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          );
        }),
        TrinaColumn(
          title: '',
          field: AccountsPage._fActions,
          type: TrinaColumnType.text(),
          width: 170,
          enableEditingMode: false,
          enableContextMenu: false,
          enableFilterMenuItem: false,
          enableSorting: false,
          renderer: (ctx) {
            final a = byId[ctx.row.cells[AccountsPage._fId]?.value];
            if (a == null) return const SizedBox.shrink();
            final hasChildren = (childrenOf[a.id] ?? const <Account>[]).isNotEmpty;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasChildren)
                  IconButton(
                    icon: Icon(Icons.summarize_outlined,
                        size: 16,
                        color: _rollupResults.containsKey(a.id)
                            ? context.semantic.success
                            : null),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'الرصيد الإجمالي (مع الفروع)',
                    onPressed: () => _toggleRollup(a, childrenOf),
                  ),
                IconButton(
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'كشف الحساب',
                  onPressed: () => onOpenStatement(a),
                ),
                // الرصيد الافتتاحي متاح فقط لصناديق العملات (CurrencyId
                // يميّزها وحدها) — نفس قيد الخادم تماماً.
                if (a.currencyId != null)
                  IconButton(
                    icon: const Icon(Icons.savings_outlined, size: 16),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'رصيد افتتاحي',
                    onPressed: () => onOpeningBalance(a),
                  ),
                // التعديل بنقرة مزدوجة على الصف (بلا زر قلم في كل صف)، والحذف
                // يظهر فقط للحسابات القابلة للحذف — الحساب الأساسي بلا أيقونة
                // قفل معطّلة لا فائدة منها.
                if (!a.isSystem)
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: Theme.of(context).colorScheme.error),
                    visualDensity: VisualDensity.compact,
                    tooltip: AppStrings.delete,
                    onPressed: () => onDelete(a),
                  ),
              ],
            );
          },
        ),
        TrinaColumn(
            title: '', field: AccountsPage._fId, type: TrinaColumnType.text(), hide: true),
      ],
      rows: [for (final a in roots) rowOf(a)],
    );
  }
}
