import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/expenses/expense_providers.dart';
import 'package:saydaliati/features/expenses/presentation/pages/expense_form_dialog.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// سجلّ المصاريف — تتبّع بحت بهذه المرحلة (بلا قيد محاسبي)، راجع
/// EXPENSES_PLAN.md §6 للمرحلة اللاحقة.
class ExpensesListPage extends ConsumerWidget {
  const ExpensesListPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      List<ExpenseCategory> categories, [Expense? existing]) async {
    if (categories.isEmpty) {
      await showErrorDialog(context,
          message: 'أضِف تصنيف مصاريف واحداً على الأقل أولاً');
      return;
    }
    // الحفظ يحدث داخل الحوار نفسه (مع مؤشّر تحميل) — هنا فقط نُحدِّث القائمة
    // ونعرض إشعار النجاح عند عودة `true`.
    final saved =
        await showExpenseFormDialog(context, categories: categories, existing: existing);
    if (saved != true || !context.mounted) return;

    ref.invalidate(expensesListProvider);
    AppSnackbar.success(
      context,
      existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Expense e) async {
    final ok = await showDeleteConfirmationDialog(context,
        itemName: '#${e.number} — ${e.categoryName}');
    if (!ok || !context.mounted) return;
    final result = await ref.read(expenseRepositoryProvider).delete(e.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(expensesListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expensesListProvider);
    final categories = ref.watch(expenseCategoriesProvider).value ?? const <ExpenseCategory>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expenses),
        actions: [
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
                label: const Text(AppStrings.addExpense),
                onPressed: () => _addOrEdit(context, ref, categories),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(expensesListProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(
                icon: Icons.receipt_long_outlined, message: AppStrings.noExpenses)
            : SimpleEntityGrid<Expense>(
                items: items,
                idOf: (e) => e.id,
                columns: [
                  SimpleEntityColumn('#', (e) => '${e.number}', width: 70),
                  SimpleEntityColumn(
                      AppStrings.expenseDate, (e) => AppDate.ymd(e.spentOn),
                      width: 110),
                  SimpleEntityColumn(
                      AppStrings.expenseCategoryColumn, (e) => e.categoryName,
                      width: 180),
                  SimpleEntityColumn(AppStrings.expenseAmount,
                      (e) => Formatters.money(e.amount, e.currencyCode),
                      width: 150),
                  SimpleEntityColumn(AppStrings.expensePaymentSource,
                      (e) => e.paymentAccountName,
                      width: 130),
                  SimpleEntityColumn(AppStrings.expenseNote, (e) => e.note, width: 220),
                ],
                onEdit: (e) => _addOrEdit(context, ref, categories, e),
                onDelete: (e) => _delete(context, ref, e),
              ),
      ),
    );
  }
}
