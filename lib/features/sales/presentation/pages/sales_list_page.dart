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
import 'package:saydaliati/shared/widgets/buttons/app_refresh_button.dart';
import 'package:saydaliati/shared/widgets/cards/invoice_card.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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

  /// إظهار أرباح الفواتير على البطاقات. مخفيّة افتراضياً: رقم حسّاس لا يُعرض
  /// أمام زبون واقف عند الكاشير إلا بطلب صريح.
  bool _showProfit = false;

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

    final customers = ref.watch(customersProvider).value ?? const <Customer>[];
    String customerName(String id) => id.isEmpty
        ? ''
        : customers.where((c) => c.id == id).map((c) => c.fullName).firstOrNull ??
            '';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.salesList),
        actions: [
          // يُحدَّث المزوّد المُعامَل بالفلاتر الحالية نفسها، لا المزوّد
          // العامّ: تحديث العامّ لا يمسّ النسخة المعروضة فلا يتغيّر شيء.
          AppRefreshButton(onRefresh: () => ref.refresh(provider.future)),
          IconButton(
            tooltip: _showProfit ? 'إخفاء الأرباح' : 'إظهار الأرباح',
            onPressed: () => setState(() => _showProfit = !_showProfit),
            icon: Icon(_showProfit
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          ),
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
      // بطاقات بدل الغريد: كل فاتورة بطاقة تُقرأ بلمحة (الرقم، التاريخ،
      // أصنافها، مبلغها) وفيها زرّا التعديل والحذف صريحين.
      body: async.when(
        loading: () => const LoadingState(message: AppStrings.loading),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(provider)),
        data: (sales) {
          if (sales.isEmpty) {
            return const EmptyState(
              message: AppStrings.noSales,
              icon: Icons.receipt_long_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(provider),
            child: InvoiceCardsGrid(
              children: [
                for (final sale in sales) _card(sale, codeFor, customerName),
              ],
            ),
          );
        },
      ),
    );
  }

  /// مبلغ الفاتورة بعملتها الأصلية (لا بعملة الأساس) ورمزها.
  (double, String) _amountOf(Sale sale, String Function(String) codeFor) {
    final foreign = sale.originalCurrencyId.isNotEmpty;
    if (!foreign) return (sale.totalAmount, sale.currencyCode);
    final code = codeFor(sale.originalCurrencyId);
    return (
      sale.totalAmount * sale.exchangeRate,
      code.isNotEmpty ? code : sale.currencyCode,
    );
  }

  /// ربح الفاتورة = إجماليها ناقص كلفة أسطرها، معروضاً بعملة الفاتورة نفسها
  /// (التكلفة مخزَّنة بعملة الأساس كالإجمالي، فيُطبَّق سعر الصرف على الفرق).
  double _profitOf(Sale sale) {
    final cost = sale.items
        .fold<double>(0, (sum, l) => sum + l.unitCost * l.quantity);
    final profitBase = sale.totalAmount - cost;
    return sale.originalCurrencyId.isEmpty
        ? profitBase
        : profitBase * sale.exchangeRate;
  }

  Widget _card(
    Sale sale,
    String Function(String) codeFor,
    String Function(String) customerName,
  ) {
    final (amount, code) = _amountOf(sale, codeFor);
    return InvoiceCard(
      icon: Icons.point_of_sale_outlined,
      invoiceNumber: sale.invoiceNumber,
      dateLabel: AppDate.ymdHm(sale.saleDate),
      itemsCount: sale.items.length,
      itemsPreview: _preview(sale.items.map((e) => e.medicineName)),
      amount: amount,
      currencyCode: code,
      partyLabel: customerName(sale.customerId),
      badge: sale.isPrescription ? AppStrings.prescriptionLabel : null,
      profit: _showProfit ? _profitOf(sale) : null,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => SaleDetailPage(sale: sale)),
      ),
      onEdit: () => _edit(sale),
      onDelete: () => _delete(sale),
    );
  }

  /// أول صنفين وعدد الباقي — يكفي للتعرّف على الفاتورة بلا فتحها.
  static String _preview(Iterable<String> names) {
    final list = names.where((n) => n.isNotEmpty).toList();
    if (list.isEmpty) return '';
    final shown = list.take(2).join('، ');
    final extra = list.length - 2;
    return extra > 0 ? '$shown +$extra' : shown;
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

