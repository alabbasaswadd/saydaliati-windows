import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Customers management — list + add/edit/delete.
class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Customer? existing]) async {
    final values = await showEntityFormDialog(
      context,
      title: existing == null ? AppStrings.addCustomer : AppStrings.editCustomer,
      icon: Icons.person_add_alt_1_outlined,
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
      appBar: AppBar(
        title: const Text(AppStrings.customers),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: FilledButton.icon(
              onPressed: () => _addOrEdit(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('إضافة زبون'),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(customersProvider)),
        data: (items) => items.isEmpty
            ? const EmptyState(message: AppStrings.noCustomers)
            : SimpleEntityGrid<Customer>(
                items: items,
                idOf: (c) => c.id,
                columns: [
                  SimpleEntityColumn(AppStrings.name, (c) => c.fullName,
                      width: 220),
                  SimpleEntityColumn(AppStrings.phone, (c) => c.phone,
                      width: 150),
                  SimpleEntityColumn(AppStrings.address, (c) => c.address,
                      width: 220),
                ],
                onEdit: (c) => _addOrEdit(context, ref, c),
                onDelete: (c) => _delete(context, ref, c),
              ),
      ),
    );
  }
}
