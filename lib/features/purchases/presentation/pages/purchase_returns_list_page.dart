import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase_return.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_return_picker_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// قسم «مرتجع مشتريات» المستقل بالقائمة الجانبية — سجلّ مستندات المرتجع
/// المحفوظة، ونقطة الدخول لإنشاء مرتجع جديد (باختيار فاتورة الشراء أولاً).
class PurchaseReturnsListPage extends ConsumerStatefulWidget {
  const PurchaseReturnsListPage({super.key});

  @override
  ConsumerState<PurchaseReturnsListPage> createState() => _PurchaseReturnsListPageState();
}

class _PurchaseReturnsListPageState extends ConsumerState<PurchaseReturnsListPage> {
  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fItems = 'items';
  static const _fReason = 'reason';
  static const _fTotal = 'total';

  Future<void> _newReturn() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PurchaseReturnPickerPage()),
    );
    if (created == true) ref.invalidate(purchaseReturnsListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(purchaseReturnsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مرتجع مشتريات'),
        actions: [
          AppRefreshButton(
            onRefresh: () => ref.refresh(purchaseReturnsListProvider.future),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newReturn,
        icon: const Icon(Icons.add),
        label: const Text('مرتجع جديد'),
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(purchaseReturnsListProvider)),
        data: (returns) => _content(context, returns),
      ),
    );
  }

  Widget _content(BuildContext context, List<PurchaseReturnSummary> returns) {
    if (returns.isEmpty) {
      return const EmptyState(
        icon: Icons.assignment_return_outlined,
        message: 'لا توجد مستندات مرتجع مشتريات بعد',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppGrid(
        showColumnFilter: false,
        columns: [
          appGridNumberColumn('رقم الفاتورة الأصلية', _fInvoice, width: 150, format: '#'),
          appGridTextColumn('تاريخ الإرجاع', _fDate,
              width: 150, textAlign: TrinaColumnTextAlign.center),
          appGridNumberColumn('عدد الأصناف', _fItems, width: 100, format: '#'),
          appGridTextColumn('السبب', _fReason, width: 200, flexible: true),
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
        ],
        rows: [
          for (final r in returns)
            TrinaRow(cells: {
              _fInvoice: TrinaCell(value: r.purchaseInvoiceNumber),
              _fDate: TrinaCell(value: AppDate.ymdHm(r.returnDate)),
              _fItems: TrinaCell(value: r.itemsCount),
              _fReason: TrinaCell(value: r.reason ?? ''),
              _fTotal: TrinaCell(value: r.totalAmount),
            }),
        ],
      ),
    );
  }
}
