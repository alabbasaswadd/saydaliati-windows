import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';
import 'package:saydaliati/features/manufacturers/manufacturer_providers.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// Manufacturers management — list + add/edit/delete.
class ManufacturersPage extends ConsumerWidget {
  const ManufacturersPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Manufacturer? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null
          ? AppStrings.addManufacturer
          : AppStrings.editManufacturer,
      fields: [
        EntityField(
          key: 'name',
          label: AppStrings.manufacturerName,
          initial: existing?.name,
          isRequired: true,
        ),
        EntityField(
          key: 'location',
          label: AppStrings.location,
          initial: existing?.location,
        ),
      ],
    );
    if (values == null || !context.mounted) return;

    final repo = ref.read(manufacturerRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            name: values['name']!, location: values['location'] ?? '')
        : await repo.update(
            id: existing.id,
            name: values['name']!,
            location: values['location'] ?? '');
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(manufacturersProvider);
        AppSnackbar.success(
          context,
          existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess,
        );
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, Manufacturer m) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: m.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(manufacturerRepositoryProvider).delete(m.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(manufacturersProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(manufacturersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.manufacturers)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Manufacturer>(
        value: async,
        emptyMessage: AppStrings.noManufacturers,
        onRefresh: () => ref.refresh(manufacturersProvider.future),
        itemBuilder: (context, m) => ListTile(
          leading: const Icon(Icons.store_outlined),
          title: Text(m.name),
          subtitle: m.location.isEmpty ? null : Text(m.location),
          onTap: () => _addOrEdit(context, ref, m),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref, m),
          ),
        ),
      ),
    );
  }
}
