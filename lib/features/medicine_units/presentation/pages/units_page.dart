import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';
import 'package:saydaliati/features/medicine_units/unit_providers.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

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
          actions: const [TutorialHelpButton(TutorialTopic.unitsAndPrices)]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Unit>(
        value: async,
        emptyMessage: AppStrings.noUnits,
        onRefresh: () => ref.refresh(unitsProvider.future),
        itemBuilder: (context, u) => ListTile(
          leading: const Icon(Icons.straighten_outlined),
          title: Text(u.name),
          subtitle: u.description.isEmpty ? null : Text(u.description),
          onTap: () => _addOrEdit(context, ref, u),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref, u),
          ),
        ),
      ),
    );
  }
}
