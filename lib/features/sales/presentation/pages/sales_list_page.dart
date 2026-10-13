import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/pages/sale_detail_page.dart';
import 'package:saydaliati/features/sales/presentation/pages/sales_page.dart';
import 'package:saydaliati/features/sales/presentation/providers/sales_provider.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:trina_grid/trina_grid.dart';

/// The sales invoices (online). Each row shows the invoice number, time, and
/// amount in its ORIGINAL transaction currency. Filters (الفترة / العميل /
/// الدواء / العملة) live in a right-side panel opened from the AppBar.
class SalesListPage extends ConsumerStatefulWidget {
  const SalesListPage({super.key});

  @override
  ConsumerState<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends ConsumerState<SalesListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// مدير الشبكة — لزر إظهار/إخفاء الأعمدة.
  TrinaGridStateManager? _gridManager;
  ReportPeriod? _period;
  String? _customerId;
  String? _medicineId;
  String? _currencyId;

  bool get _hasFilters =>
      _period != null ||
      _customerId != null ||
      _medicineId != null ||
      _currencyId != null;

  void _clear() => setState(() {
        _period = null;
        _customerId = null;
        _medicineId = null;
        _currencyId = null;
      });

  Future<void> _edit(Sale sale) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SalesPage(saleToEdit: sale)),
    );
  }

  Future<void> _delete(Sale sale) async {
    final ok = await showDeleteConfirmationDialog(context,
        itemName: '${AppStrings.invoiceLabel} #${sale.invoiceNumber}');
    if (!ok || !context.mounted) return;
    final result = await ref.read(saleRepositoryProvider).deleteSale(sale.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        ref.invalidate(salesListProvider);
        ref.invalidate(dashboardProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = salesListProvider(
      fromIso: _period?.startUtcIso,
      toIso: _period?.endUtcIso,
      customerId: _customerId,
      medicineId: _medicineId,
      currencyId: _currencyId,
    );
    final async = ref.watch(provider);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    String codeFor(String id) =>
        currencies.where((c) => c.id == id).map((c) => c.code).firstOrNull ?? '';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.salesList),
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
      endDrawer: _FilterDrawer(
        period: _period,
        customerId: _customerId,
        medicineId: _medicineId,
        currencyId: _currencyId,
        onClear: _hasFilters ? _clear : null,
        onPeriod: (p) => setState(() => _period = p),
        onCustomer: (v) => setState(() => _customerId = v),
        onMedicine: (v) => setState(() => _medicineId = v),
        onCurrency: (v) => setState(() => _currencyId = v),
      ),
      // الغريد المعتمد: صف لكل فاتورة، فلترة لكل عمود، نقرة مزدوجة للتفاصيل.
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (sales) {
          if (sales.isEmpty) {
            return const Center(child: Text(AppStrings.noSales));
          }
          final byId = {for (final s in sales) s.id: s};
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppGrid(
              columns: _columns(byId),
              rows: [for (final s in sales) _row(s, codeFor)],
              onLoaded: (m) => _gridManager = m,
              onRowDoubleTap: (e) {
                final sale = byId[e.row.cells[_fId]?.value];
                if (sale != null) {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => SaleDetailPage(sale: sale)));
                }
              },
            ),
          );
        },
      ),
    );
  }

  static const _fId = 'id';
  static const _fInvoice = 'invoice';
  static const _fDate = 'date';
  static const _fItems = 'items';
  static const _fCurrency = 'currency';
  static const _fTotal = 'total';
  static const _fActions = 'actions';

  List<TrinaColumn> _columns(Map<String, Sale> byId) {
    return [
      appGridNumberColumn(AppStrings.invoiceLabel, _fInvoice,
          width: 110, format: '#'),
      appGridTextColumn(AppStrings.dateColumn, _fDate,
          width: 150, textAlign: TrinaColumnTextAlign.center),
      appGridNumberColumn(AppStrings.piecesCountColumn, _fItems,
          width: 95, format: '#'),
      appGridTextColumn(AppStrings.filterByCurrency, _fCurrency,
          width: 90, hide: true, textAlign: TrinaColumnTextAlign.center),
      appGridNumberColumn(AppStrings.total, _fTotal, width: 130,
          renderer: (ctx) {
        final v = ctx.cell.value;
        final n = v is num ? v.toDouble() : 0.0;
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
      }),
      TrinaColumn(
        title: '',
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 90,
        enableEditingMode: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableSorting: false,
        renderer: (ctx) {
          final sale = byId[ctx.row.cells[_fId]?.value];
          if (sale == null) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.edit,
                onPressed: () => _edit(sale),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 16, color: Theme.of(context).colorScheme.error),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.delete,
                onPressed: () => _delete(sale),
              ),
            ],
          );
        },
      ),
      // معرف داخلي مخفي للربط بالكيان.
      TrinaColumn(
        title: '',
        field: _fId,
        type: TrinaColumnType.text(),
        hide: true,
      ),
    ];
  }

  TrinaRow<dynamic> _row(Sale sale, String Function(String) codeFor) {
    // Show the amount in the currency the sale was actually made in.
    final foreign = sale.originalCurrencyId.isNotEmpty;
    final code = foreign
        ? (codeFor(sale.originalCurrencyId).isNotEmpty
            ? codeFor(sale.originalCurrencyId)
            : sale.currencyCode)
        : sale.currencyCode;
    final amount =
        foreign ? sale.totalAmount * sale.exchangeRate : sale.totalAmount;
    return TrinaRow(
      cells: {
        _fId: TrinaCell(value: sale.id),
        _fInvoice: TrinaCell(value: sale.invoiceNumber),
        _fDate: TrinaCell(value: AppDate.ymdHm(sale.saleDate)),
        _fItems: TrinaCell(value: sale.items.length),
        _fCurrency: TrinaCell(value: code),
        _fTotal: TrinaCell(value: amount),
      },
    );
  }
}

/// The sales filter panel. Reads the dropdown source lists itself so the parent
/// page stays lean; reports every change back up via the `on*` callbacks.
class _FilterDrawer extends ConsumerWidget {
  const _FilterDrawer({
    required this.period,
    required this.customerId,
    required this.medicineId,
    required this.currencyId,
    required this.onClear,
    required this.onPeriod,
    required this.onCustomer,
    required this.onMedicine,
    required this.onCurrency,
  });

  final ReportPeriod? period;
  final String? customerId;
  final String? medicineId;
  final String? currencyId;
  final VoidCallback? onClear;
  final ValueChanged<ReportPeriod?> onPeriod;
  final ValueChanged<String?> onCustomer;
  final ValueChanged<String?> onMedicine;
  final ValueChanged<String?> onCurrency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customers = ref.watch(customersProvider).value ?? const <Customer>[];
    final catalog = ref.watch(medicineCatalogProvider).value ?? const <Medicine>[];
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final selectedMed = catalog.where((m) => m.id == medicineId).firstOrNull;

    return FilterSideSheet(
      onClear: onClear,
      children: [
        Text(AppStrings.period, style: theme.textTheme.labelLarge),
        PeriodFilterList(period: period, onChanged: onPeriod),
        const Divider(),
        const SizedBox(height: AppSpacing.xs),
        AppDropdown<String?>(
          label: AppStrings.filterByCustomer,
          value: customerId,
          items: [
            const AppDropdownItem<String?>(value: null, label: AppStrings.all),
            for (final c in customers)
              AppDropdownItem<String?>(value: c.id, label: c.fullName),
          ],
          onChanged: onCustomer,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.filterByMedicine, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        medicineId == null
            ? MedicinePickerField(
                medicines: catalog,
                hint: AppStrings.filterByMedicine,
                onSelected: (m) => onMedicine(m.id),
              )
            : InputChip(
                label: Text(selectedMed?.displayName ?? '—',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                avatar: const Icon(Icons.medication_outlined, size: 18),
                onDeleted: () => onMedicine(null),
              ),
        const SizedBox(height: AppSpacing.md),
        AppDropdown<String?>(
          label: AppStrings.filterByCurrency,
          value: currencyId,
          items: [
            const AppDropdownItem<String?>(
                value: null, label: AppStrings.allCurrencies),
            for (final c in currencies)
              AppDropdownItem<String?>(
                  value: c.id, label: '${c.name} (${c.code})'),
          ],
          onChanged: onCurrency,
        ),
      ],
    );
  }
}

