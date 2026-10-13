import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/categories/category_providers.dart';
import 'package:saydaliati/features/categories/domain/entities/category.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

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
      appBar: AppBar(title: const Text(AppStrings.categories)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Category>(
        value: async,
        emptyMessage: AppStrings.noCategories,
        onRefresh: () => ref.refresh(categoriesProvider.future),
        itemBuilder: (context, c) {
          final theme = Theme.of(context);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.category_outlined,
                    color: theme.colorScheme.primary),
              ),
              title: Text(c.categoryName,
                  style:
                      theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: c.description.isEmpty ? null : Text(c.description,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _addOrEdit(context, ref, c),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _countBadge(theme, c.medicinesCount),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: AppStrings.delete,
                    onPressed: () => _delete(context, ref, c),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _countBadge(ThemeData theme, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication_outlined,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text('$count ${AppStrings.medicinesUnit}',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}
