import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// Customers management — list + add/edit/delete.
class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Customer? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null ? AppStrings.addCustomer : AppStrings.editCustomer,
      fields: [
        EntityField(
          key: 'firstName',
          label: AppStrings.firstName,
          initial: existing?.firstName,
          isRequired: true,
        ),
        EntityField(
          key: 'lastName',
          label: AppStrings.lastName,
          initial: existing?.lastName,
        ),
        EntityField(
          key: 'phone',
          label: AppStrings.phone,
          initial: existing?.phone,
        ),
        EntityField(
          key: 'address',
          label: AppStrings.address,
          initial: existing?.address,
        ),
      ],
    );
    if (values == null || !context.mounted) return;

    final repo = ref.read(customerRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            firstName: values['firstName']!,
            lastName: values['lastName'] ?? '',
            phone: values['phone'] ?? '',
            address: values['address'] ?? '')
        : await repo.update(
            id: existing.id,
            firstName: values['firstName']!,
            lastName: values['lastName'] ?? '',
            phone: values['phone'] ?? '',
            address: values['address'] ?? '');
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(customersProvider);
        AppSnackbar.success(context,
            existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Customer c) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: c.fullName);
    if (!ok || !context.mounted) return;
    final result = await ref.read(customerRepositoryProvider).delete(c.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(customersProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(customersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.customers)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Customer>(
        value: async,
        emptyMessage: AppStrings.noCustomers,
        onRefresh: () => ref.refresh(customersProvider.future),
        itemBuilder: (context, c) => ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(c.fullName),
          subtitle: c.phone.isEmpty ? null : Text(c.phone),
          onTap: () => _addOrEdit(context, ref, c),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref, c),
          ),
        ),
      ),
    );
  }
}
