import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/providers/sales_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// تقرير الوصفات الطبية — غريد شجري حقيقي بنفس أسلوب تقرير المبيعات: صف الأب
/// وصفة (رقمها، تاريخها، عميلها، إجماليها)، وتوسيعه يُظهر أدويتها سطراً سطراً.
/// فلترة «يحتوي» تحت كل رأس عمود، فرز، وشريط إحصاءات أعلى الشبكة. الفلاتر
/// (الفترة/العميل) تبقى في اللوحة الجانبية كما كانت.
class PrescriptionsReportPage extends ConsumerStatefulWidget {
  const PrescriptionsReportPage({super.key});

  @override
  ConsumerState<PrescriptionsReportPage> createState() =>
      _PrescriptionsReportPageState();
}

class _PrescriptionsReportPageState
    extends ConsumerState<PrescriptionsReportPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// مدير الشبكة — لزر «الأعمدة» (إظهار/إخفاء).
  TrinaGridStateManager? _gridManager;

  ReportPeriod? _period;
  String? _customerId;

  bool get _hasFilters => _period != null || _customerId != null;

  // مفاتيح الأعمدة.
  static const _fInvoice = 'invoice';
  static const _fUnitPrice = 'unitPrice';
  static const _fQty = 'qty';
  static const _fTotal = 'total';
  static const _fDate = 'date';
  static const _fParty = 'party';
  static const _fCurrency = 'currency';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider).value ?? const <Customer>[];
    String customerName(String id) =>
        customers.where((c) => c.id == id).map((c) => c.fullName).firstOrNull ??
        '';

    final provider = salesListProvider(
      isPrescription: true,
      fromIso: _period?.startUtcIso,
      toIso: _period?.endUtcIso,
      customerId: _customerId,
    );
    final async = ref.watch(provider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.prescriptionsReport),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
          IconButton(
            tooltip: AppStrings.filters,
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Badge(
              isLabelVisible: _hasFilters,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      endDrawer: FilterSideSheet(
        onClear: _hasFilters
            ? () => setState(() {
                  _period = null;
                  _customerId = null;
                })
            : null,
        children: [
          Text(AppStrings.period,
              style: Theme.of(context).textTheme.labelLarge),
          PeriodFilterList(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
          AppDropdown<String?>(
            label: AppStrings.filterByCustomer,
            value: _customerId,
            items: [
              const AppDropdownItem<String?>(value: null, label: AppStrings.all),
              for (final c in customers)
                AppDropdownItem<String?>(value: c.id, label: c.fullName),
            ],
            onChanged: (v) => setState(() => _customerId = v),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(provider)),
        data: (sales) => _content(sales, customerName),
      ),
    );
  }

  Widget _content(List<Sale> sales, String Function(String) customerName) {
    if (sales.isEmpty) {
      return const EmptyState(
        icon: Icons.medical_services_outlined,
        message: AppStrings.noPrescriptions,
      );
    }

    final code = sales.first.currencyCode;
    final total = sales.fold<double>(0, (s, x) => s + x.totalAmount);
    final items = sales.fold<int>(0, (s, x) => s + x.items.length);
    // عدد العملاء المميَّزين — الوصفة تستلزم عميلاً، فالرقم ذو معنى هنا.
    final patients =
        sales.map((s) => s.customerId).where((id) => id.isNotEmpty).toSet().length;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatChipsBar(chips: [
            StatChip(
              label: 'عدد الوصفات',
              value: Formatters.integer(sales.length),
              icon: Icons.medical_services_outlined,
            ),
            StatChip(
              label: AppStrings.total,
              value: Formatters.money(total, code),
              icon: Icons.payments_outlined,
            ),
            StatChip(
              label: AppStrings.piecesCountColumn,
              value: Formatters.integer(items),
              icon: Icons.medication_outlined,
            ),
            StatChip(
              label: 'عدد المرضى',
              value: Formatters.integer(patients),
              icon: Icons.person_outline,
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: AppGrid(
              tree: true,
              columns: _columns(),
              rows: [
                for (final sale in sales) _saleRow(sale, customerName),
              ],
              onLoaded: (m) => _gridManager = m,
            ),
          ),
        ],
      ),
    );
  }

  List<TrinaColumn> _columns() {
    return [
      appGridTextColumn('الوصفة / الدواء', _fInvoice, width: 220),
      appGridNumberColumn(AppStrings.unitPriceColumn, _fUnitPrice, width: 110),
      appGridNumberColumn(AppStrings.piecesCountColumn, _fQty, width: 95),
      appGridNumberColumn(AppStrings.total, _fTotal,
          width: 130, renderer: _totalCell),
      appGridTextColumn(AppStrings.dateColumn, _fDate,
          width: 150, textAlign: TrinaColumnTextAlign.center),
      appGridTextColumn('العميل / البيان', _fParty, width: 200),
      appGridTextColumn(AppStrings.filterByCurrency, _fCurrency,
          width: 90, hide: true, textAlign: TrinaColumnTextAlign.center),
    ];
  }

  Widget _totalCell(TrinaColumnRendererContext ctx) {
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

  /// صف الأب: الوصفة. أعمدة الإفرادي والكمية تبقى فارغة — معناها على السطر.
  TrinaRow<dynamic> _saleRow(Sale sale, String Function(String) customerName) {
    final name = customerName(sale.customerId);
    return TrinaRow(
      cells: {
        _fInvoice:
            TrinaCell(value: '${AppStrings.invoiceLabel} #${sale.invoiceNumber}'),
        _fUnitPrice: TrinaCell(value: ''),
        _fQty: TrinaCell(value: ''),
        _fTotal: TrinaCell(value: sale.totalAmount),
        _fDate: TrinaCell(value: AppDate.ymdHm(sale.saleDate)),
        _fParty: TrinaCell(value: name.isNotEmpty ? name : AppStrings.notSet),
        _fCurrency: TrinaCell(value: sale.currencyCode),
      },
      type: TrinaRowType.group(
        children: FilteredList(
          initialList: [for (final line in sale.items) _lineRow(line)],
        ),
      ),
    );
  }

  /// صف الابن: سطر دواء داخل الوصفة.
  TrinaRow<dynamic> _lineRow(SaleLine line) {
    return TrinaRow(
      cells: {
        _fInvoice: TrinaCell(value: line.medicineName),
        _fUnitPrice: TrinaCell(value: line.individual),
        _fQty: TrinaCell(value: line.quantity),
        _fTotal: TrinaCell(value: line.subTotal),
        _fDate: TrinaCell(value: ''),
        _fParty: TrinaCell(value: line.unitName),
        _fCurrency: TrinaCell(value: ''),
      },
    );
  }
}
