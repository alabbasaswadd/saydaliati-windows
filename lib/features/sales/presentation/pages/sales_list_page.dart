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
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';

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
      body: AsyncListView<Sale>(
        value: async,
        emptyMessage: AppStrings.noSales,
        onRefresh: () => ref.refresh(provider.future),
        itemBuilder: (context, sale) {
          // Show the amount in the currency the sale was actually made in.
          final foreign = sale.originalCurrencyId.isNotEmpty;
          final code = foreign
              ? (codeFor(sale.originalCurrencyId).isNotEmpty
                  ? codeFor(sale.originalCurrencyId)
                  : sale.currencyCode)
              : sale.currencyCode;
          final amount =
              foreign ? sale.totalAmount * sale.exchangeRate : sale.totalAmount;
          return _SaleTile(
            sale: sale,
            amount: amount,
            code: code,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => SaleDetailPage(sale: sale)),
            ),
            onEdit: () => _edit(sale),
            onDelete: () => _delete(sale),
          );
        },
      ),
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

class _SaleTile extends StatelessWidget {
  const _SaleTile({
    required this.sale,
    required this.amount,
    required this.code,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Sale sale;
  final double amount;
  final String code;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
      title: Row(
        children: [
          Expanded(
            child: Text('${AppStrings.invoiceLabel} #${sale.invoiceNumber}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Text(Formatters.money(amount, code),
              style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700)),
        ],
      ),
      subtitle: Text(
          '${AppDate.ymdHm(sale.saleDate)}  •  ${sale.items.length} صنف',
          style: theme.textTheme.bodySmall),
      trailing: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'edit') onEdit();
          if (v == 'delete') onDelete();
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text(AppStrings.edit)),
          PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
        ],
      ),
      onTap: onTap,
    );
  }
}
