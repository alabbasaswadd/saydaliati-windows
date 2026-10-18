import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/expenses/expense_providers.dart';
import 'package:saydaliati/features/expenses/presentation/pages/expense_category_form_dialog.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// إدارة تصنيفات المصاريف — إضافة/تعديل/حذف، و**ربط التصنيف بحساب**.
///
/// الربط هو ما يجعل مصاريف التصنيف تؤثّر على الحسابات: المربوط يُنشئ قيداً
/// لكل مصروف فينقص رصيد الصندوق؛ غير المربوط تتبّع بحت. التصنيفات الافتراضية
/// (`isSystem`) يمكن تعديل اسمها وربطها لكن لا يمكن حذفها (قيد من الباك).
class ExpenseCategoriesPage extends ConsumerWidget {
  const ExpenseCategoriesPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [ExpenseCategory? existing]) async {
    final values = await showExpenseCategoryForm(context, existing: existing);
    if (values == null || !context.mounted) return;

    final repo = ref.read(expenseCategoryRepositoryProvider);
    final result = existing == null
        ? await repo.create(name: values.name, accountId: values.accountId)
        : await repo.update(
            id: existing.id,
            name: values.name,
            parentId: existing.parentId,
            isActive: existing.isActive,
            accountId: values.accountId,
          );
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(expenseCategoriesProvider);
        AppSnackbar.success(
          context,
          existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
        );
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, ExpenseCategory c) async {
    if (c.isSystem) {
      await showErrorDialog(context, message: 'لا يمكن حذف تصنيف افتراضي');
      return;
    }
    final ok = await showDeleteConfirmationDialog(context, itemName: c.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(expenseCategoryRepositoryProvider).delete(c.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(expenseCategoriesProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expenseCategoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expenseCategories),
        actions: [
          AddEntityButton(
            label: 'إضافة تصنيف',
            onPressed: () => _addOrEdit(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(expenseCategoriesProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: AppStrings.noExpenseCategories)
            : SimpleEntityGrid<ExpenseCategory>(
                items: items,
                idOf: (c) => c.id,
                columns: [
                  SimpleEntityColumn(
                      AppStrings.expenseCategoryName, (c) => c.name,
                      width: 240),
                  // غير المربوط لا يؤثّر على الحسابات — نقولها صراحةً بدل «—».
                  SimpleEntityColumn('الحساب المرتبط',
                      (c) => c.accountName ?? 'بلا ربط — لا يؤثّر',
                      width: 220),
                  SimpleEntityColumn(
                      'افتراضي', (c) => c.isSystem ? 'نعم' : 'لا',
                      width: 90),
                ],
                onEdit: (c) => _addOrEdit(context, ref, c),
                onDelete: (c) => _delete(context, ref, c),
              ),
      ),
    );
  }
}
