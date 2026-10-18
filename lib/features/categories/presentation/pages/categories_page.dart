import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/categories/category_providers.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Categories management — list + add/edit/delete. Online-only writes.
class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Category? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null ? AppStrings.addCategory : AppStrings.editCategory,
      fields: [
        EntityField(
          key: 'categoryName',
          label: AppStrings.categoryName,
          initial: existing?.categoryName,
          isRequired: true,
        ),
        EntityField(
          key: 'description',
          label: AppStrings.description,
          initial: existing?.description,
        ),
      ],
    );
    if (values == null || !context.mounted) return;

    final repo = ref.read(categoryRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            categoryName: values['categoryName']!,
            description: values['description'] ?? '',
          )
        : await repo.update(
            id: existing.id,
            categoryName: values['categoryName']!,
            description: values['description'] ?? '',
          );
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(categoriesProvider);
        AppSnackbar.success(
          context,
          existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
        );
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, Category c) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: c.categoryName);
    if (!ok || !context.mounted) return;
    final result = await ref.read(categoryRepositoryProvider).delete(c.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(categoriesProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categories),
        actions: [
          AddEntityButton(
            label: 'إضافة فئة',
            onPressed: () => _addOrEdit(context, ref),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(categoriesProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: AppStrings.noCategories)
            : SimpleEntityGrid<Category>(
                items: items,
                idOf: (c) => c.id,
                columns: [
                  SimpleEntityColumn(
                      AppStrings.categoryName, (c) => c.categoryName,
                      width: 220),
                  SimpleEntityColumn(AppStrings.description, (c) => c.description,
                      width: 260),
                  SimpleEntityColumn(AppStrings.medicinesUnit,
                      (c) => '${c.medicinesCount}',
                      width: 90),
                ],
                onEdit: (c) => _addOrEdit(context, ref, c),
                onDelete: (c) => _delete(context, ref, c),
              ),
      ),
    );
  }
}
