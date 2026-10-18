import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/shared/widgets/buttons/add_entity_button.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/catalog/presentation/pages/catalog_page.dart';
import 'package:saydaliati/features/manufacturers/domain/entities/manufacturer.dart';
import 'package:saydaliati/features/manufacturers/manufacturer_providers.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/simple_entity_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.manufacturers),
          actions: [
            AddEntityButton(
              label: 'إضافة شركة',
              onPressed: () => _addOrEdit(context, ref),
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'شركاتي'), Tab(text: 'شركات الكتالوغ')],
          ),
        ),
        body: TabBarView(
          children: [
            async.when(
              loading: () => const LoadingState(),
              error: (e, _) => ErrorState.fromError(e,
                  onRetry: () => ref.invalidate(manufacturersProvider)),
              data: (items) => items.isEmpty
                  ? const EmptyState(message: AppStrings.noManufacturers)
                  : SimpleEntityGrid<Manufacturer>(
                      items: items,
                      idOf: (m) => m.id,
                      columns: [
                        SimpleEntityColumn(
                            AppStrings.manufacturerName, (m) => m.name,
                            width: 240),
                        SimpleEntityColumn(
                            AppStrings.location, (m) => m.location,
                            width: 200),
                      ],
                      onEdit: (m) => _addOrEdit(context, ref, m),
                      onDelete: (m) => _delete(context, ref, m),
                    ),
            ),
            // شركات الكاتلوغ العام (انتقلت من شاشة الكتالوغ).
            const CatalogCompaniesTab(),
          ],
        ),
      ),
    );
  }
}
