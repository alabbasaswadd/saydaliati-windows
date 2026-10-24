import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/reports/domain/entities/sales_grid.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_return_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// Sales report — a REAL tree grid (TrinaGrid): each parent row is an invoice
/// (number, date, customer, payment, cost, profit, margin, total); expanding
/// it shows its line items. Per-column "contains" filters under the headers,
/// sortable columns, and a stat-chips strip on top. Wakeed-style.
class SalesReportPage extends ConsumerStatefulWidget {
  const SalesReportPage({required this.initialPeriod, super.key});

  final ReportPeriod initialPeriod;

  @override
  ConsumerState<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends ConsumerState<SalesReportPage> {
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
  static const _fDiscount = 'discount';
  static const _fCost = 'cost';
  static const _fProfit = 'profit';
  static const _fMargin = 'margin';
  static const _fTotal = 'total';
  static const _fActions = 'actions';

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(salesGridProvider(_period.startUtcIso, _period.endUtcIso));

    return ReportScaffold(
      title: AppStrings.salesReport,
      period: _period,
      onPeriodChanged: (p) => setState(() => _period = p),
      onRefresh: () => ref.refresh(
          salesGridProvider(_period.startUtcIso, _period.endUtcIso).future),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(
              salesGridProvider(_period.startUtcIso, _period.endUtcIso)),
        ),
        data: (rows) => _content(context, rows),
      ),
    );
  }

  Widget _content(BuildContext context, List<SalesGridInvoice> invoices) {
    if (invoices.isEmpty) {
      return const EmptyState(
        icon: Icons.point_of_sale_outlined,
        message: AppStrings.noDataForPeriod,
      );
    }
    final theme = Theme.of(context);
    final sym = invoices.first.currencySymbol.isNotEmpty
        ? invoices.first.currencySymbol
        : invoices.first.currencyCode;

    final totalRevenue = invoices.fold<double>(0, (s, i) => s + i.totalAmount);
    final totalProfit = invoices.fold<double>(0, (s, i) => s + i.profit);
    final totalCost = invoices.fold<double>(0, (s, i) => s + i.cost);
    final profitColor =
        totalProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _statsBar(profitColor, theme,
                  totalProfit: totalProfit,
                  totalRevenue: totalRevenue,
                  totalCost: totalCost,
                  count: invoices.length,
                  sym: sym)),
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
              // بيع بخسارة → تظليل تحذيري خفيف على صف الفاتورة.
              rowColorCallback: (ctx) {
                final profit = ctx.row.cells[_fProfit]?.value;
                if (profit is num && profit < 0) {
                  return context.semantic.warning.withValues(alpha: 0.07);
                }
                return Colors.transparent;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsBar(Color profitColor, ThemeData theme,
      {required double totalProfit,
      required double totalRevenue,
      required double totalCost,
      required int count,
      required String sym}) {
    return StatChipsBar(chips: [
            StatChip(
              label: AppStrings.grossProfit,
              value: Formatters.money(totalProfit, sym),
              icon: Icons.trending_up_outlined,
              color: profitColor,
            ),
            StatChip(
              label: AppStrings.totalRevenue,
              value: Formatters.money(totalRevenue, sym),
              icon: Icons.payments_outlined,
            ),
            StatChip(
              label: AppStrings.costOfGoods,
              value: Formatters.money(totalCost, sym),
              icon: Icons.shopping_bag_outlined,
              color: theme.colorScheme.secondary,
            ),
            StatChip(
              label: AppStrings.invoicesCount,
              value: Formatters.integer(count),
              icon: Icons.receipt_long_outlined,
            ),
          ]);
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
      appGridNumberColumn(AppStrings.total, _fTotal,
          width: 120, renderer: (ctx) => _totalCell(context, ctx)),
      appGridTextColumn(AppStrings.dateColumn, _fDate,
          width: 105, textAlign: TrinaColumnTextAlign.center),
      appGridTextColumn('العميل / البيان', _fParty, width: 180),
      // مخفيان افتراضياً — يُظهَران من زر «الأعمدة» أو قائمة رأس العمود.
      appGridTextColumn(AppStrings.paymentMethod, _fPayment,
          width: 110, hide: true),
      appGridTextColumn(AppStrings.filterByCurrency, _fCurrency,
          width: 90, hide: true, textAlign: TrinaColumnTextAlign.center),
      appGridNumberColumn(AppStrings.discountShort, _fDiscount, width: 90),
      appGridNumberColumn(AppStrings.costShort, _fCost,
          width: 110, hide: true),
      appGridNumberColumn(AppStrings.profitShort, _fProfit,
          width: 110, renderer: (ctx) => _signedCell(context, ctx)),
      appGridNumberColumn(AppStrings.marginLabel, _fMargin,
          width: 85,
          format: '#,##0.#',
          renderer: (ctx) => _signedCell(context, ctx, suffix: '%')),
    ];
  }

  /// أيقونة «مرتجع مبيعات» — تظهر فقط على صف الفاتورة (الأب)، لا على أسطر
  /// أدويتها. تفتح شاشة مرتجع مستقلة (اختيار الأصناف والكميات) — التأكيد
  /// الفعلي يتم هناك بإدخال الكميات والضغط «تأكيد المرتجع»، لا ببوب أب عابر.
  Widget _actionsCell(BuildContext context, TrinaColumnRendererContext ctx) {
    final inv = ctx.cell.value;
    if (inv is! SalesGridInvoice || inv.saleId.isEmpty) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.assignment_return_outlined, size: 20),
      tooltip: AppStrings.saleReturnAction,
      visualDensity: VisualDensity.compact,
      onPressed: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => SaleReturnPage(
                saleId: inv.saleId, invoiceNumber: inv.invoiceNumber),
          ),
        );
        if (changed == true && mounted) {
          ref.invalidate(salesGridProvider(_period.startUtcIso, _period.endUtcIso));
        }
      },
    );
  }

  /// قيمة موقَّعة: خضراء للربح وحمراء للخسارة — LTR صراحةً حتى لا تظهر إشارة
  /// السالب بموضع مضلِّل وسط سياق RTL.
  Widget _signedCell(BuildContext context, TrinaColumnRendererContext ctx,
      {String suffix = ''}) {
    final v = ctx.cell.value;
    if (v == null || (v is String && v.isEmpty)) return const SizedBox.shrink();
    final n = v is num ? v.toDouble() : double.tryParse(v.toString());
    if (n == null || n == 0) return const SizedBox.shrink();
    final color = n >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        '${Formatters.number(n)}$suffix',
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
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

  TrinaRow<dynamic> _invoiceRow(SalesGridInvoice inv) {
    return TrinaRow(
      cells: {
        // قيمة الخلية هي الفاتورة الكاملة — الخلية تحمل بيانات الصف لتبنى منها
        // الأيقونة (نفس نمط تخزين كيان كامل بقيمة خلية مستخدَم بشاشات أخرى).
        _fActions: TrinaCell(value: inv),
        _fInvoice: TrinaCell(
            value: '${AppStrings.invoiceLabel} #${inv.invoiceNumber}'),
        _fDate: TrinaCell(value: _ymd(inv.saleDate)),
        _fParty: TrinaCell(
            value: inv.customerName.isNotEmpty
                ? inv.customerName
                : AppStrings.cashSale),
        _fPayment: TrinaCell(value: _payLabel(inv.paymentMethod)),
        _fCurrency: TrinaCell(
            value: inv.currencySymbol.isNotEmpty
                ? inv.currencySymbol
                : inv.currencyCode),
        _fUnitPrice: TrinaCell(value: ''),
        _fQty: TrinaCell(value: ''),
        _fDiscount: TrinaCell(value: inv.discountAmount),
        _fCost: TrinaCell(value: inv.cost),
        _fProfit: TrinaCell(value: inv.profit),
        _fMargin: TrinaCell(value: inv.profitMargin),
        _fTotal: TrinaCell(value: inv.totalAmount),
      },
      type: TrinaRowType.group(
        children: FilteredList(
          initialList: [for (final it in inv.items) _itemRow(it)],
        ),
      ),
    );
  }

  TrinaRow<dynamic> _itemRow(SalesGridItem it) {
    return TrinaRow(
      cells: {
        _fActions: TrinaCell(value: null),
        _fInvoice: TrinaCell(value: it.brandName),
        _fDate: TrinaCell(value: ''),
        // البيان: اسم الوحدة (الإفرادي والعدد صارا عمودين مستقلّين).
        _fParty: TrinaCell(value: it.unitName),
        _fPayment: TrinaCell(value: ''),
        _fCurrency: TrinaCell(value: ''),
        _fUnitPrice: TrinaCell(value: it.unitPrice),
        _fQty: TrinaCell(value: it.quantity),
        _fDiscount: TrinaCell(value: it.discount),
        _fCost: TrinaCell(value: it.lineCost),
        _fProfit: TrinaCell(value: it.lineProfit),
        _fMargin: TrinaCell(value: ''),
        _fTotal: TrinaCell(value: it.subTotal),
      },
    );
  }

  static String _ymd(DateTime d) {
    final l = d.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')}';
  }

  static String _payLabel(int method) =>
      method >= 1 && method <= 6 ? PaymentMethod.fromWire(method).label : '—';
}
