import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';
import 'package:saydaliati/features/stock/presentation/pages/add_stock_page.dart';
import 'package:saydaliati/features/stock/stock_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// Inventory — stock batches with quantity + expiry. Add via the FAB.
class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref, Stock s) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: s.medicineName);
    if (!ok || !context.mounted) return;
    final result = await ref.read(stockRepositoryProvider).delete(s.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(stockListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(stockListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.stockTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddStockPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.receiveStock),
      ),
      body: AsyncListView<Stock>(
        value: async,
        emptyMessage: AppStrings.noStock,
        onRefresh: () => ref.refresh(stockListProvider.future),
        itemBuilder: (context, s) {
          final theme = Theme.of(context);
          final expired = s.expiryDate != null &&
              s.expiryDate!.isBefore(DateTime.now());
          return ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(s.medicineName.isEmpty ? '—' : s.medicineName,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: s.expiryDate == null
                ? null
                : Text(
                    '${AppStrings.expiry}: ${AppDate.ymd(s.expiryDate!)}',
                    style: expired
                        ? theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.error)
                        : null,
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${AppStrings.available}: ${Formatters.qty(s.quantityAvailable)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: s.quantityAvailable <= 0
                        ? theme.colorScheme.error
                        : context.semantic.success,
                  ),
                ),
                IconButton(
                  tooltip: AppStrings.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => AddStockPage(stockToEdit: s)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context, ref, s),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
