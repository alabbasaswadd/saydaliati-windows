import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_return_page.dart';
import 'package:saydaliati/features/reports/domain/entities/purchases_grid.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Purchases report — the project-standard tree grid (TrinaGrid): each parent
/// row is a purchase invoice (number, date, supplier, total); expanding it
/// shows its line items (unit price, pieces count, batch, expiry, total).
/// Per-column "contains" filters, sortable headers, stat chips on top.
class PurchasesReportPage extends ConsumerStatefulWidget {
  const PurchasesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<PurchasesReportPage> createState() =>
      _PurchasesReportPageState();
}

class _PurchasesReportPageState extends ConsumerState<PurchasesReportPage> {
  late ReportPeriod _period = widget.initialPeriod;

  /// مدير الشبكة — لفتح نافذة إظهار/إخفاء الأعمدة من زر «الأعمدة».
  TrinaGridStateManager? _gridManager;

  // Column field keys.
  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fParty = 'party';
  static const _fPayment = 'payment';
  static const _fCurrency = 'currency';
  static const _fUnitPrice = 'unitPrice';
  static const _fQty = 'qty';
  static const _fBonus = 'bonus';
  static const _fDiscount = 'discount';
  static const _fBatch = 'batch';
  static const _fExpiry = 'expiry';
  static const _fTotal = 'total';
  static const _fActions = 'actions';

  @override
  Widget build(BuildContext context) {
    final async = ref
        .watch(purchasesGridProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.purchasesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.invalidate(
          purchasesGridProvider(_period.startUtcIso, _period.endUtcIso)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(
              purchasesGridProvider(_period.startUtcIso, _period.endUtcIso)),
        ),
        data: (rows) => _content(context, rows),
      ),
    );
  }

  Widget _content(BuildContext context, List<PurchasesGridInvoice> invoices) {
    if (invoices.isEmpty) {
      return const EmptyState(
        icon: Icons.local_shipping_outlined,
        message: AppStrings.noDataForPeriod,
      );
    }
    final sym = invoices.first.currencySymbol.isNotEmpty
        ? invoices.first.currencySymbol
        : invoices.first.currencyCode;
    final totalAmount = invoices.fold<double>(0, (s, i) => s + i.totalAmount);
    final totalDiscount =
        invoices.fold<double>(0, (s, i) => s + i.discountAmount);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatChipsBar(chips: [
                  StatChip(
                    label: AppStrings.totalCost,
                    value: Formatters.money(totalAmount, sym),
                    icon: Icons.shopping_cart_outlined,
                  ),
                  StatChip(
                    label: AppStrings.invoicesCount,
                    value: Formatters.integer(invoices.length),
                    icon: Icons.receipt_long_outlined,
                  ),
                  if (totalDiscount > 0)
                    StatChip(
                      label: AppStrings.discountShort,
                      value: Formatters.money(totalDiscount, sym),
                      icon: Icons.percent_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                ]),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppGridColumnsButton(managerGetter: () => _gridManager),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: AppGrid(
              tree: true,
              columns: _columns(context),
              rows: [for (final inv in invoices) _invoiceRow(inv)],
              onLoaded: (m) => _gridManager = m,
            ),
          ),
        ],
      ),
    );
  }

  List<TrinaColumn> _columns(BuildContext context) {
    return [
      // الإجراءات أولاً (الأبرز) — مرتجع لفاتورة الأب فقط، لا لأسطر الدواء.
      TrinaColumn(
        title: AppStrings.actionsColumn,
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 70,
        enableEditingMode: false,
        enableSorting: false,
        enableColumnDrag: false,
        enableContextMenu: false,
        textAlign: TrinaColumnTextAlign.center,
        renderer: (ctx) => _actionsCell(context, ctx),
      ),
      // فاتورة/الدواء، ثم الإفرادي وعدد القطع والإجمالي متتالية بعده مباشرة.
      appGridTextColumn(AppStrings.invoiceLabel, _fInvoice, width: 170),
      appGridNumberColumn(AppStrings.unitPriceColumn, _fUnitPrice, width: 100),
      appGridNumberColumn(AppStrings.piecesCountColumn, _fQty, width: 95),
      // البونص عمود مستقلّ: كميةٌ دخلت المخزون بلا ثمن، وثمنها عند البيع
      // ربحٌ صافٍ. إخفاؤه يجعل القارئ يرى كميةً بلا مصدر ظاهر.
      appGridNumberColumn('بونص', _fBonus, width: 85, renderer: (ctx) {
        final v = ctx.cell.value;
        final n = v is num ? v.toDouble() : 0.0;
        if (n == 0) return const SizedBox.shrink();
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            Formatters.number(n),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.semantic.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }),
      appGridNumberColumn(AppStrings.total, _fTotal,
          width: 120, renderer: (ctx) => _totalCell(context, ctx)),
      appGridTextColumn(AppStrings.dateColumn, _fDate,
          width: 105, textAlign: TrinaColumnTextAlign.center),
      appGridTextColumn('المورّد / البيان', _fParty, width: 180),
      // مخفيان افتراضياً — يُظهَران من زر «الأعمدة» أو قائمة رأس العمود.
      appGridTextColumn(AppStrings.paymentMethod, _fPayment,
          width: 110, hide: true),
      // العملة ظاهرة: مبالغ الفاتورة بعملتها هي، وفاتورتان بعملتين في
      // الجدول نفسه تُقرآن خطأً بلا وسم — والعمود كان مخفيّاً افتراضياً.
      appGridTextColumn(AppStrings.filterByCurrency, _fCurrency,
          width: 90, textAlign: TrinaColumnTextAlign.center),
      appGridNumberColumn(AppStrings.discountShort, _fDiscount, width: 90),
      appGridTextColumn(AppStrings.batchLabel, _fBatch,
          width: 100, hide: true),
      appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
          width: 105, textAlign: TrinaColumnTextAlign.center),
    ];
  }

  Widget _totalCell(BuildContext context, TrinaColumnRendererContext ctx) {
    final v = ctx.cell.value;
    final n = v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '');
    if (n == null || n == 0) return const SizedBox.shrink();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        Formatters.number(n),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  TrinaRow<dynamic> _invoiceRow(PurchasesGridInvoice inv) {
    return TrinaRow(
      cells: {
        // قيمة الخلية هي الفاتورة الكاملة — نفس نمط سجلّ المبيعات الشجري.
        _fActions: TrinaCell(value: inv),
        _fInvoice: TrinaCell(
            value: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}'),
        _fDate: TrinaCell(value: _ymd(inv.purchaseDate)),
        _fParty: TrinaCell(
            value: inv.supplierName.isNotEmpty
                ? inv.supplierName
                : AppStrings.supplier),
        _fPayment: TrinaCell(value: _payLabel(inv.paymentMethod)),
        _fCurrency: TrinaCell(
            value: inv.currencySymbol.isNotEmpty
                ? inv.currencySymbol
                : inv.currencyCode),
        _fUnitPrice: TrinaCell(value: ''),
        _fQty: TrinaCell(value: inv.itemsCount),
        _fBonus: TrinaCell(value: inv.bonusQuantity),
        _fDiscount: TrinaCell(value: inv.discountAmount),
        _fBatch: TrinaCell(value: ''),
        _fExpiry: TrinaCell(value: ''),
        _fTotal: TrinaCell(value: inv.totalAmount),
      },
      type: TrinaRowType.group(
        children: FilteredList(
          initialList: [
            for (final it in inv.items)
              _itemRow(
                it,
                // السطر الابن يحمل عملة فاتورته: الأب يغيب عن الشاشة عند
                // التمرير، فيبقى السعر الإفرادي بلا وحدة.
                currency: inv.currencySymbol.isNotEmpty
                    ? inv.currencySymbol
                    : inv.currencyCode,
              ),
          ],
        ),
      ),
    );
  }

  TrinaRow<dynamic> _itemRow(PurchasesGridItem it, {String currency = ''}) {
    return TrinaRow(
      cells: {
        _fActions: TrinaCell(value: null),
        _fInvoice: TrinaCell(value: it.brandName),
        _fDate: TrinaCell(value: ''),
        // البيان: اسم الوحدة (الإفرادي والعدد عمودان مستقلّان).
        _fParty: TrinaCell(value: it.unitName),
        _fPayment: TrinaCell(value: ''),
        _fCurrency: TrinaCell(value: currency),
        _fUnitPrice: TrinaCell(value: it.unitPrice),
        _fQty: TrinaCell(value: it.quantity),
        _fBonus: TrinaCell(value: it.bonusQuantity),
        _fDiscount: TrinaCell(value: it.discount),
        _fBatch: TrinaCell(value: it.batchNumber),
        _fExpiry: TrinaCell(
            value: it.expiryDate != null ? _ymd(it.expiryDate!) : ''),
        _fTotal: TrinaCell(value: it.subTotal),
      },
    );
  }

  /// أيقونة «مرتجع مشتريات» — تظهر فقط على صف الفاتورة (الأب). التأكيد الفعلي
  /// بشاشة المرتجع المستقلة (كميات لكل سطر ثم «تأكيد المرتجع»)، لا ببوب أب عابر.
  Widget _actionsCell(BuildContext context, TrinaColumnRendererContext ctx) {
    final inv = ctx.cell.value;
    if (inv is! PurchasesGridInvoice || inv.purchaseId.isEmpty) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: const Icon(Icons.assignment_return_outlined, size: 20),
      tooltip: AppStrings.purchaseReturnAction,
      visualDensity: VisualDensity.compact,
      onPressed: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PurchaseReturnPage(
                purchaseId: inv.purchaseId, invoiceNumber: inv.invoiceNumber),
          ),
        );
        if (changed == true && mounted) {
          ref.invalidate(
              purchasesGridProvider(_period.startUtcIso, _period.endUtcIso));
        }
      },
    );
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _payLabel(int method) =>
      method >= 1 && method <= 6 ? PaymentMethod.fromWire(method).label : '—';
}
