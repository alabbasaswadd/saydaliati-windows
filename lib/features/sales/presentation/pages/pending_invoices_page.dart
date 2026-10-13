import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/features/sales/domain/entities/pending_sale.dart';
import 'package:saydaliati/features/sales/presentation/pages/sales_page.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// The POS "cloud" screen: invoices still waiting to be synced to the server.
/// Each can be edited (re-opens the POS, saving back to the queue) or deleted
/// (which restores its quantities to the local cache). A "sync now" action pushes
/// them when online.
class PendingInvoicesPage extends ConsumerWidget {
  const PendingInvoicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingSalesProvider);
    final online = ref.watch(effectiveOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.pendingInvoices),
        actions: [
          IconButton(
            tooltip: AppStrings.syncNow,
            icon: const Icon(Icons.cloud_upload_outlined),
            onPressed: online
                ? () {
                    ref.read(dataSyncControllerProvider.notifier).syncAll();
                    AppSnackbar.info(context, AppStrings.syncing);
                  }
                : null,
          ),
        ],
      ),
      body: pendingAsync.when(
        loading: () => const LoadingState(message: AppStrings.loading),
        error: (e, _) => ErrorState.fromError(e),
        data: (rows) {
          if (rows.isEmpty) {
            return const EmptyState(
              icon: Icons.cloud_done_outlined,
              message: AppStrings.pendingInvoicesEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _PendingCard(sale: rows[i]),
          );
        },
      ),
    );
  }
}

class _PendingCard extends ConsumerWidget {
  const _PendingCard({required this.sale});

  final PendingSale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final failed = sale.failed;

    return Card(
      child: ListTile(
        leading: Icon(
          failed ? Icons.error_outline : Icons.cloud_off_outlined,
          color: failed ? theme.colorScheme.error : theme.colorScheme.primary,
        ),
        title: Text(
          '${AppStrings.unsyncedInvoice} • ${sale.total.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppStrings.itemsCountLabel}: ${sale.itemCount}'),
            if (sale.date != null) Text(_fmt(sale.date!)),
            Text(
              failed
                  ? '${AppStrings.queuedStatusFailed}${sale.lastError != null ? ' — ${sale.lastError}' : ''}'
                  : AppStrings.queuedStatusPending,
              style: TextStyle(
                color: failed ? theme.colorScheme.error : Colors.orange.shade800,
                fontSize: 12,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: AppStrings.edit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SalesPage(
                    queuedId: sale.id,
                    queuedPayload: sale.payload,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: AppStrings.delete,
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmationDialog(
      context,
      title: AppStrings.delete,
      message: AppStrings.deleteQueuedConfirm,
      confirmLabel: AppStrings.delete,
      icon: Icons.delete_outline,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final result =
        await ref.read(saleRepositoryProvider).deleteQueuedSale(sale.id);
    if (!context.mounted) return;
    result.fold(
      (_) => AppSnackbar.success(context, AppStrings.deletedSuccess),
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  static String _fmt(DateTime t) =>
      '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} '
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
