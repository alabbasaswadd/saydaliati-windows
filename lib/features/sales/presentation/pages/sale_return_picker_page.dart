import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_return_page.dart';
import 'package:saydaliati/features/sales/presentation/providers/sales_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// اختيار فاتورة بيع لإنشاء مرتجع منها — نفس الغريد الموحّد المستخدَم بكل
/// شاشات قوائم الفواتير بالمشروع (`sales_list_page.dart`): فلترة لكل عمود
/// تحت رأسه بدل مربّع بحث عام، ونقرة مزدوجة لفتح شاشة المرتجع مباشرة.
/// يُرجِع `true` إن أُنشئ مرتجع فعلاً.
class SaleReturnPickerPage extends ConsumerStatefulWidget {
  const SaleReturnPickerPage({super.key});

  @override
  ConsumerState<SaleReturnPickerPage> createState() => _SaleReturnPickerPageState();
}

class _SaleReturnPickerPageState extends ConsumerState<SaleReturnPickerPage> {
  TrinaGridStateManager? _gridManager;

  static const _fId = 'id';
  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fItems = 'items';
  static const _fCurrency = 'currency';
  static const _fTotal = 'total';

  Future<void> _pick(Sale sale) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SaleReturnPage(saleId: sale.id, invoiceNumber: sale.invoiceNumber),
      ),
    );
    if (changed == true && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(salesListProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر فاتورة البيع لإرجاعها'),
        actions: [AppGridColumnsButton(managerGetter: () => _gridManager)],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(salesListProvider())),
        data: (sales) => _grid(sales),
      ),
    );
  }

  Widget _grid(List<Sale> sales) {
    if (sales.isEmpty) {
      return const EmptyState(
        icon: Icons.point_of_sale_outlined,
        message: 'لا توجد فواتير مبيعات',
      );
    }

    final byId = {for (final s in sales) s.id: s};

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppGrid(
        columns: [
          appGridNumberColumn('رقم الفاتورة', _fInvoice, width: 120, format: '#'),
          appGridTextColumn('التاريخ', _fDate,
              width: 150, textAlign: TrinaColumnTextAlign.center),
          appGridNumberColumn('عدد الأصناف', _fItems, width: 100, format: '#'),
          appGridTextColumn('العملة', _fCurrency,
              width: 90, hide: true, textAlign: TrinaColumnTextAlign.center),
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
          for (final s in sales)
            TrinaRow(cells: {
              _fId: TrinaCell(value: s.id),
              _fInvoice: TrinaCell(value: s.invoiceNumber),
              _fDate: TrinaCell(value: AppDate.ymdHm(s.saleDate)),
              _fItems: TrinaCell(value: s.items.length),
              _fCurrency: TrinaCell(value: s.currencyCode),
              _fTotal: TrinaCell(value: s.totalAmount),
            }),
        ],
        onLoaded: (m) => _gridManager = m,
        onRowDoubleTap: (e) {
          final sale = byId[e.row.cells[_fId]?.value];
          if (sale != null) _pick(sale);
        },
      ),
    );
  }
}
