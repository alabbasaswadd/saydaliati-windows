import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_return_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// اختيار فاتورة شراء لإنشاء مرتجع منها — نفس الغريد الموحّد المستخدَم بكل
/// شاشات قوائم الفواتير بالمشروع: فلترة لكل عمود تحت رأسه بدل مربّع بحث
/// عام، ونقرة مزدوجة لفتح شاشة المرتجع مباشرة.
/// يُرجِع `true` إن أُنشئ مرتجع فعلاً.
class PurchaseReturnPickerPage extends ConsumerStatefulWidget {
  const PurchaseReturnPickerPage({super.key});

  @override
  ConsumerState<PurchaseReturnPickerPage> createState() => _PurchaseReturnPickerPageState();
}

class _PurchaseReturnPickerPageState extends ConsumerState<PurchaseReturnPickerPage> {
  TrinaGridStateManager? _gridManager;

  static const _fId = 'id';
  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fItems = 'items';
  static const _fTotal = 'total';

  Future<void> _pick(Purchase purchase) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PurchaseReturnPage(
            purchaseId: purchase.id, invoiceNumber: purchase.invoiceNumber),
      ),
    );
    if (changed == true && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(purchasesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر فاتورة الشراء لإرجاعها'),
        actions: [AppGridColumnsButton(managerGetter: () => _gridManager)],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(purchasesListProvider)),
        data: (purchases) => _grid(purchases),
      ),
    );
  }

  Widget _grid(List<Purchase> purchases) {
    if (purchases.isEmpty) {
      return const EmptyState(
        icon: Icons.local_shipping_outlined,
        message: 'لا توجد فواتير مشتريات',
      );
    }

    final byId = {for (final p in purchases) p.id: p};

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppGrid(
        columns: [
          appGridNumberColumn('رقم الفاتورة', _fInvoice, width: 120, format: '#'),
          appGridTextColumn('التاريخ', _fDate,
              width: 150, textAlign: TrinaColumnTextAlign.center),
          appGridNumberColumn('عدد الأصناف', _fItems, width: 100, format: '#'),
          appGridNumberColumn('الإجمالي', _fTotal, width: 130, renderer: (ctx) {
            final v = ctx.cell.value;
            final n = v is num ? v.toDouble() : 0.0;
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                Formatters.number(n),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700),
              ),
            );
          }),
          TrinaColumn(title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
        ],
        rows: [
          for (final p in purchases)
            TrinaRow(cells: {
              _fId: TrinaCell(value: p.id),
              _fInvoice: TrinaCell(value: p.invoiceNumber),
              _fDate: TrinaCell(value: AppDate.ymdHm(p.purchaseDate)),
              _fItems: TrinaCell(value: p.items.length),
              _fTotal: TrinaCell(value: p.totalAmount),
            }),
        ],
        onLoaded: (m) => _gridManager = m,
        onRowDoubleTap: (e) {
          final purchase = byId[e.row.cells[_fId]?.value];
          if (purchase != null) _pick(purchase);
        },
      ),
    );
  }
}
