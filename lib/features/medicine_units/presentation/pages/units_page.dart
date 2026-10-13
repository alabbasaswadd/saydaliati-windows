import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';
import 'package:saydaliati/features/medicine_units/unit_providers.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Units management — list + add/edit/delete.
class UnitsPage extends ConsumerWidget {
  const UnitsPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Unit? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null ? AppStrings.addUnit : AppStrings.editUnit,
      fields: [
        EntityField(
          key: 'name',
          label: AppStrings.unitName,
          initial: existing?.name,
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

    final repo = ref.read(unitRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            name: values['name']!, description: values['description'] ?? '')
        : await repo.update(
            id: existing.id,
            name: values['name']!,
            description: values['description'] ?? '');
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(unitsProvider);
        AppSnackbar.success(
          context,
          existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
        );
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Unit u) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: u.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(unitRepositoryProvider).delete(u.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(unitsProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(unitsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.unitsList),
        actions: [
          IconButton(
            tooltip: AppStrings.addNew,
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEdit(context, ref),
          ),
          const TutorialHelpButton(TutorialTopic.unitsAndPrices),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(unitsProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: AppStrings.noUnits)
            : SimpleEntityGrid<Unit>(
                items: items,
                idOf: (u) => u.id,
                columns: [
                  SimpleEntityColumn(AppStrings.unitName, (u) => u.name,
                      width: 200),
                  SimpleEntityColumn(AppStrings.description, (u) => u.description,
                      width: 260),
                ],
                onEdit: (u) => _addOrEdit(context, ref, u),
                onDelete: (u) => _delete(context, ref, u),
              ),
      ),
    );
  }
}
