import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/expenses/presentation/pages/expenses_list_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_detail_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_returns_list_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_detail_page.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_returns_list_page.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';
import 'package:saydaliati/features/vouchers/presentation/pages/voucher_form_dialog.dart';
import 'package:saydaliati/features/vouchers/voucher_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// السندات (قيود محاسبية) — يدوية أو تابعة لفاتورة/مصروف/مرتجع. السندات
/// التابعة (علامة القفل) لا تُحذَف من هنا — فقط من مصدرها؛ أيقونة خاصة بها
/// تفتح المستند الأصلي.
class VouchersListPage extends ConsumerWidget {
  const VouchersListPage({super.key});

  static const _fDate = 'date';
  static const _fTime = 'time';
  static const _fDesc = 'desc';
  static const _fDebit = 'debit';
  static const _fCredit = 'credit';
  static const _fAmount = 'amount';
  static const _fCurrency = 'currency';
  static const _fActions = 'actions';
  static const _fId = '_id';

  Future<void> _add(BuildContext context, WidgetRef ref, List<Account> accounts) async {
    if (accounts.isEmpty) {
      await showErrorDialog(context, message: 'لا توجد حسابات متاحة');
      return;
    }
    final saved = await showVoucherFormDialog(context, accounts: accounts);
    if (saved != true || !context.mounted) return;
    ref.invalidate(vouchersListProvider);
    AppSnackbar.success(context, AppStrings.createdSuccess);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Voucher v) async {
    if (v.hasOrigin) {
      await showErrorDialog(context,
          message: 'هذا السند تابع لفاتورة/مصروف/مرتجع — حذفه يتم من مصدره');
      return;
    }
    final ok = await showDeleteConfirmationDialog(context, itemName: v.description);
    if (!ok || !context.mounted) return;
    final result = await ref.read(voucherRepositoryProvider).delete(v.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(vouchersListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _openOrigin(BuildContext context, WidgetRef ref, Voucher v) async {
    final id = v.originId;
    if (id == null) return;

    switch (v.originType) {
      case 'Sale':
        final result = await ref.read(saleRepositoryProvider).getSale(id);
        if (!context.mounted) return;
        result.fold(
          (sale) => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => SaleDetailPage(sale: sale))),
          (failure) => showFailureSnackbar(context, failure),
        );
      case 'Purchase':
        final result = await ref.read(purchaseRepositoryProvider).getPurchase(id);
        if (!context.mounted) return;
        result.fold(
          (purchase) => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => PurchaseDetailPage(purchase: purchase))),
          (failure) => showFailureSnackbar(context, failure),
        );
      case 'Expense':
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const ExpensesListPage()));
      case 'SaleReturn':
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const SaleReturnsListPage()));
      case 'PurchaseReturn':
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const PurchaseReturnsListPage()));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(vouchersListProvider);
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('السندات'),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(vouchersListProvider),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: SizedBox(
              height: 36,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: context.semantic.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('سند جديد'),
                onPressed: () => _add(context, ref, accounts),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(vouchersListProvider)),
        data: (vouchers) => vouchers.isEmpty
            ? const EmptyState(
                icon: Icons.description_outlined, message: 'لا توجد سندات بعد')
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _VouchersGrid(
                  // الأحدث تاريخاً ووقتاً أولاً.
                  vouchers: [...vouchers]..sort((a, b) => b.date.compareTo(a.date)),
                  onDelete: (v) => _delete(context, ref, v),
                  onOpenOrigin: (v) => _openOrigin(context, ref, v),
                ),
              ),
      ),
    );
  }
}

class _VouchersGrid extends StatelessWidget {
  const _VouchersGrid({
    required this.vouchers,
    required this.onDelete,
    required this.onOpenOrigin,
  });

  final List<Voucher> vouchers;
  final ValueChanged<Voucher> onDelete;
  final ValueChanged<Voucher> onOpenOrigin;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final v in vouchers) v.id: v};

    return AppGrid(
      key: ValueKey(vouchers.length ^ vouchers.hashCode),
      columns: [
        appGridTextColumn('التاريخ', VouchersListPage._fDate,
            width: 110, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn('الوقت', VouchersListPage._fTime,
            width: 80, textAlign: TrinaColumnTextAlign.center),
        appGridTextColumn('البيان', VouchersListPage._fDesc, width: 200),
        appGridTextColumn('مدين', VouchersListPage._fDebit, width: 180),
        appGridTextColumn('دائن', VouchersListPage._fCredit, width: 180),
        appGridNumberColumn('المبلغ', VouchersListPage._fAmount, width: 120,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.number(n),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: context.semantic.success, fontWeight: FontWeight.w700),
            ),
          );
        }),
        appGridTextColumn('العملة', VouchersListPage._fCurrency,
            width: 90, textAlign: TrinaColumnTextAlign.center),
        TrinaColumn(
          title: '',
          field: VouchersListPage._fActions,
          type: TrinaColumnType.text(),
          width: 100,
          enableEditingMode: false,
          enableContextMenu: false,
          enableFilterMenuItem: false,
          enableSorting: false,
          renderer: (ctx) {
            final v = byId[ctx.row.cells[VouchersListPage._fId]?.value];
            if (v == null) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (v.hasOrigin)
                  IconButton(
                    icon: const Icon(Icons.open_in_new, size: 16),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'الذهاب إلى المصدر',
                    onPressed: () => onOpenOrigin(v),
                  ),
                if (!v.hasOrigin)
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: Theme.of(context).colorScheme.error),
                    visualDensity: VisualDensity.compact,
                    tooltip: AppStrings.delete,
                    onPressed: () => onDelete(v),
                  ),
              ],
            );
          },
        ),
        TrinaColumn(
            title: '', field: VouchersListPage._fId, type: TrinaColumnType.text(), hide: true),
      ],
      rows: [
        for (final v in vouchers)
          TrinaRow(cells: {
            VouchersListPage._fDate: TrinaCell(value: AppDate.ymd(v.date)),
            VouchersListPage._fTime: TrinaCell(value: AppDate.hm(v.date)),
            VouchersListPage._fDesc: TrinaCell(value: v.description),
            VouchersListPage._fDebit: TrinaCell(value: v.debitAccountName),
            VouchersListPage._fCredit: TrinaCell(value: v.creditAccountName),
            VouchersListPage._fAmount: TrinaCell(value: v.totalDebit),
            VouchersListPage._fCurrency: TrinaCell(value: v.currencyCode ?? ''),
            VouchersListPage._fId: TrinaCell(value: v.id),
          }),
      ],
    );
  }
}
