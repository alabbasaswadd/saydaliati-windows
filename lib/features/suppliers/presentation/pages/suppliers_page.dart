import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/supplier_providers.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// Suppliers management — list + add/edit/delete.
class SuppliersPage extends ConsumerWidget {
  const SuppliersPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Supplier? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null ? AppStrings.addSupplier : AppStrings.editSupplier,
      fields: [
        EntityField(
          key: 'name',
          label: AppStrings.name,
          initial: existing?.name,
          isRequired: true,
        ),
        EntityField(
          key: 'contactPerson',
          label: AppStrings.contactPerson,
          initial: existing?.contactPerson,
        ),
        EntityField(
          key: 'email',
          label: AppStrings.email,
          initial: existing?.email,
        ),
      ],
    );
    if (values == null || !context.mounted) return;

    final repo = ref.read(supplierRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            name: values['name']!,
            contactPerson: values['contactPerson'] ?? '',
            email: values['email'] ?? '')
        : await repo.update(
            id: existing.id,
            name: values['name']!,
            contactPerson: values['contactPerson'] ?? '',
            email: values['email'] ?? '');
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(suppliersProvider);
        AppSnackbar.success(context,
            existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Supplier s) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: s.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(supplierRepositoryProvider).delete(s.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(suppliersProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(suppliersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.suppliers)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Supplier>(
        value: async,
        emptyMessage: AppStrings.noSuppliers,
        onRefresh: () => ref.refresh(suppliersProvider.future),
        itemBuilder: (context, s) => ListTile(
          leading: const Icon(Icons.local_shipping_outlined),
          title: Text(s.name),
          subtitle: s.contactPerson.isEmpty && s.email.isEmpty
              ? null
              : Text([s.contactPerson, s.email].where((x) => x.isNotEmpty).join(' · ')),
          onTap: () => _addOrEdit(context, ref, s),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref, s),
          ),
        ),
      ),
    );
  }
}
