import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_create_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_detail_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/invoice_card.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// فواتير أول المدة — مخزون افتتاحي بلا مورّد، مقيَّد مقابل رأس المال
/// (راجع `PurchaseCreatePage.isOpeningBalance`). نفس بناء [PurchasesListPage]
/// المبسَّط: لا فلاتر هنا — عدد هذه الفواتير قليل عادةً (إعداد أوّلي مرّة أو
/// مرّات قليلة)، لا يستحق لوحة فلترة كاملة.
class OpeningBalanceInvoicesPage extends ConsumerWidget {
  const OpeningBalanceInvoicesPage({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    if (!context.mounted) return;
    ref.invalidate(purchasesListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(purchasesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('فواتير أول المدة'),
        actions: [
          AppRefreshButton(
            onRefresh: () => ref.refresh(purchasesListProvider.future),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: SizedBox(
              height: 36,
              child: FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('فاتورة أول المدة'),
                onPressed: () => _open(
                  context,
                  ref,
                  const PurchaseCreatePage(isOpeningBalance: true),
                ),
              ),
            ),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(message: AppStrings.loading),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(purchasesListProvider),
        ),
        data: (purchases) {
          final items = purchases.where((p) => p.isOpeningBalance).toList();
          if (items.isEmpty) {
            return const EmptyState(
              message: 'لا توجد فواتير أول مدة بعد',
              icon: Icons.account_balance_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(purchasesListProvider.future),
            child: InvoiceCardsGrid(
              children: [for (final p in items) _card(context, ref, p)],
            ),
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, WidgetRef ref, Purchase purchase) {
    return InvoiceCard(
      icon: Icons.account_balance_outlined,
      invoiceNumber: purchase.invoiceNumber,
      dateLabel: AppDate.ymdHm(purchase.purchaseDate),
      itemsCount: purchase.items.length,
      itemsPreview: _preview(purchase.items.map((e) => e.medicineName)),
      amount: purchase.totalAmount,
      currencyCode: '',
      onTap: () => _open(
          context, ref, PurchaseDetailPage(purchase: purchase)),
      onEdit: () => _open(
          context,
          ref,
          PurchaseCreatePage(purchaseToEdit: purchase, isOpeningBalance: true)),
    );
  }

  static String _preview(Iterable<String> names) {
    final list = names.where((n) => n.isNotEmpty).toList();
    if (list.isEmpty) return '';
    final shown = list.take(2).join('، ');
    final extra = list.length - 2;
    return extra > 0 ? '$shown +$extra' : shown;
  }
}
