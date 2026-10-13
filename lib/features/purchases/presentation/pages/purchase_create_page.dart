import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/medicine_scan_actions.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/purchases/domain/entities/create_purchase_input.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/supplier_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Plain, parse-safe number string (no thousands separators) — the price/qty
/// fields are read back with `double.tryParse`, which rejects grouped values.
String _plainNum(num v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

class _PurLine {
  _PurLine({required this.medicine, required this.unitId, double unitPrice = 0}) {
    price.text = unitPrice == 0 ? '' : _plainNum(unitPrice);
    qty.text = '1';
  }

  final Medicine medicine;
  String unitId;
  DateTime? expiry;
  // باركود لدواء بلا باركود (يُرسَل مع الفاتورة ويُحدّث الدواء).
  String? scannedBarcode;
  final price = TextEditingController();
  final qty = TextEditingController();
  final barcodeCtrl = TextEditingController();

  double get lineTotal =>
      (double.tryParse(price.text.trim()) ?? 0) *
      (double.tryParse(qty.text.trim()) ?? 0);

  void dispose() {
    price.dispose();
    qty.dispose();
    barcodeCtrl.dispose();
  }
}

/// Create a purchase invoice (POS-style): pick medicines, set cost + quantity +
/// expiry per line, then save. Feeds stock on the backend.
class PurchaseCreatePage extends ConsumerStatefulWidget {
  const PurchaseCreatePage({this.purchaseToEdit, super.key});

  /// When set, the page edits this existing invoice (prefills its lines and saves
  /// via update) instead of creating a new one.
  final Purchase? purchaseToEdit;

  @override
  ConsumerState<PurchaseCreatePage> createState() => _PurchaseCreatePageState();
}

class _PurchaseCreatePageState extends ConsumerState<PurchaseCreatePage> {
  final List<_PurLine> _lines = [];
  String? _currencyId;
  String? _supplierId; // المورّد (اختياري)
  PaymentMethod _payMethod = PaymentMethod.cash;
  bool _saving = false;
  bool _prefilled = false;
  bool _prefillStarted = false;

  bool get _isEdit => widget.purchaseToEdit != null;

  /// Ensures the edited invoice's lines are loaded: the list row carries no line
  /// items, so when they're missing we fetch the FULL invoice by id first, then
  /// prefill. Guarded so it runs once.
  Future<void> _ensurePrefill(List<Medicine> catalog) async {
    if (_prefillStarted || !mounted) return;
    _prefillStarted = true;
    var purchase = widget.purchaseToEdit!;
    if (purchase.items.isEmpty) {
      final r =
          await ref.read(purchaseRepositoryProvider).getPurchase(purchase.id);
      if (!mounted) return;
      purchase = r.fold((full) => full, (_) => purchase);
    }
    if (!mounted) return;
    setState(() => _prefillFromPurchase(purchase, catalog));
  }

  /// Prefills the lines from an existing purchase (amounts are stored in the
  /// base currency, so the editor stays in base and shows them as-is).
  void _prefillFromPurchase(Purchase p, List<Medicine> catalog) {
    _prefilled = true;
    _currencyId = null; // base
    for (final it in p.items) {
      final med = catalog.where((m) => m.id == it.medicineId).firstOrNull;
      if (med == null || med.units.isEmpty) continue;
      final unitId = med.units.any((u) => u.unitId == it.unitId)
          ? it.unitId
          : med.units.first.unitId;
      final line = _PurLine(medicine: med, unitId: unitId);
      line.price.text = _plainNum(it.unitPrice);
      line.qty.text = _plainNum(it.quantity);
      line.expiry = it.expiryDate;
      _lines.add(line);
    }
  }

  @override
  void dispose() {
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  String _effectiveCurrencyId(Currency? base) => _currencyId ?? base?.id ?? '';

  double get _total => _lines.fold(0, (s, l) => s + l.lineTotal);

  void _add(Medicine m) {
    if (m.units.isEmpty) {
      AppSnackbar.error(context, AppStrings.noPricedUnitForProduct);
      return;
    }
    // اختيار الوحدة الافتراضية تلقائياً (وإلا الأولى) — ويمكن تغييرها من القائمة.
    final unit =
        m.units.firstWhere((u) => u.isDefault, orElse: () => m.units.first);
    // A5/F1: default the cost in the selected currency (converted from the base
    // catalog price). The user can still edit it.
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == _effectiveCurrencyId(base)).firstOrNull;
    // التكلفة المقترحة لهذه الوحدة = تكلفة الوحدة الأساسية × معامل التحويل،
    // ثم تحويلها لعملة الفاتورة. يمكن للمستخدم تعديلها.
    final cost = convertFromBase(
        m.purchaseCost * unit.conversionFactor, base, selected);
    setState(() =>
        _lines.add(_PurLine(medicine: m, unitId: unit.unitId, unitPrice: cost)));
  }

  Future<void> _save(String? warehouseId, Currency? base) async {
    if (_saving) return;
    final currencyId = _effectiveCurrencyId(base);
    if (warehouseId == null || warehouseId.isEmpty) {
      AppSnackbar.error(context, AppStrings.warehouseNotSet);
      return;
    }
    if (currencyId.isEmpty) {
      AppSnackbar.error(context, AppStrings.selectCurrency);
      return;
    }
    if (_lines.isEmpty) {
      AppSnackbar.error(context, AppStrings.purchaseEmptyHint);
      return;
    }

    setState(() => _saving = true);
    // Store costs in the BASE currency: convert the prices entered in the
    // selected currency back to base, and record the base currency id.
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == currencyId).firstOrNull;
    double toBase(double v) => convertToBase(v, base, selected);
    final input = CreatePurchaseInput(
      currencyId: base?.id ?? currencyId,
      warehouseId: warehouseId,
      supplierId: _supplierId,
      purchaseDate: DateTime.now(),
      totalAmount: toBase(_total),
      paymentMethod: _payMethod,
      lines: [
        for (final l in _lines)
          CreatePurchaseLineInput(
            medicineId: l.medicine.id,
            unitId: l.unitId,
            unitPrice: toBase(double.tryParse(l.price.text.trim()) ?? 0),
            quantity: double.tryParse(l.qty.text.trim()) ?? 0,
            expiryDate: l.expiry,
            scannedBarcode: l.scannedBarcode,
          ),
      ],
    );
    final repo = ref.read(purchaseRepositoryProvider);
    final result = _isEdit
        ? await repo.update(widget.purchaseToEdit!.id, input)
        : await repo.create(input);
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (_) {
        ref.invalidate(purchasesListProvider);
        ref.invalidate(dashboardProvider);
        // Mirror any scanned barcodes into the offline cache (safety net for the
        // offline-fallback case); the catalog invalidate below re-pulls the
        // authoritative server copy which already carries them.
        final medRepo = ref.read(medicineRepositoryProvider);
        for (final l in _lines) {
          final bc = l.scannedBarcode?.trim() ?? '';
          if (bc.isNotEmpty && l.medicine.barcode.isEmpty) {
            medRepo.cacheBarcodeLocally(l.medicine.id, bc);
          }
        }
        // Editing changes stock + the medicine's weighted-average cost.
        ref.invalidate(medicineCatalogProvider);
        AppSnackbar.success(context, AppStrings.purchaseSavedSuccess);
        Navigator.of(context).pop(true);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(medicineCatalogProvider).value ?? const [];
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);
    final warehouseId = ref.watch(defaultWarehouseIdProvider).value;
    final code = currencies
            .where((c) => c.id == _effectiveCurrencyId(base))
            .map((c) => c.code)
            .firstOrNull ??
        '';

    if (_isEdit && !_prefilled && catalog.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePrefill(catalog));
    }

    return BarcodeScannerListener(
      onScan: (code) => handleScannedBarcode(
        context: context,
        ref: ref,
        catalog: catalog,
        code: code,
        onFound: _add,
      ),
      child: Scaffold(
      appBar: AppBar(
          title: Text(_isEdit ? AppStrings.editPurchase : AppStrings.newPurchase),
          actions: const [TutorialHelpButton(TutorialTopic.firstPurchase)]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Column(
              children: [
                if (warehouseId == null || warehouseId.isEmpty) ...[
                  InfoCard(
                    icon: Icons.warehouse_outlined,
                    color: Theme.of(context).colorScheme.error,
                    message: AppStrings.warehouseNotSet,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppDropdown<String>(
                        label: AppStrings.selectCurrency,
                        value: _effectiveCurrencyId(base).isEmpty
                            ? null
                            : _effectiveCurrencyId(base),
                        // عملات قابلة للاختيار فقط: الأساسية + أي عملة سعر صرفها موجب
                        // (عملة بلا سعر صرف تُخفى لأن التحويل يُرجِع المبلغ دون تحويل).
                        items: [
                          for (final c in currencies.where(
                              (c) => c.isBaseCurrency || c.exchangeRate > 0))
                            AppDropdownItem(value: c.id, label: c.code),
                        ],
                        onChanged: (v) => setState(() => _currencyId = v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppDropdown<PaymentMethod>(
                        label: AppStrings.paymentMethod,
                        value: _payMethod,
                        items: [
                          for (final m in PaymentMethod.values)
                            AppDropdownItem(value: m, label: m.label),
                        ],
                        onChanged: (v) =>
                            setState(() => _payMethod = v ?? PaymentMethod.cash),
                      ),
                    ),
                  ],
                ),
                // المورّد (اختياري) — يظهر فقط إن وُجد موردون.
                Builder(builder: (_) {
                  final suppliers =
                      ref.watch(suppliersProvider).value ?? const <Supplier>[];
                  if (suppliers.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: AppDropdown<String?>(
                      label: 'المورّد (اختياري)',
                      value: _supplierId,
                      items: [
                        const AppDropdownItem<String?>(value: null, label: '— بلا مورّد —'),
                        for (final s in suppliers)
                          AppDropdownItem<String?>(value: s.id, label: s.name),
                      ],
                      onChanged: (v) => setState(() => _supplierId = v),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.md),
                MedicinePickerField(
                  medicines: catalog,
                  hint: AppStrings.selectMedicine,
                  onSelected: _add,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _lines.isEmpty
                ? const EmptyState(
                    icon: Icons.local_shipping_outlined,
                    message: AppStrings.purchaseEmptyHint,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _lines.length,
                    itemBuilder: (context, i) => _lineCard(_lines[i], code),
                  ),
          ),
          _summaryBar(code, warehouseId, base),
        ],
      ),
      ),
    );
  }

  Widget _lineCard(_PurLine line, String code) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        border: Border.all(color: context.semantic.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(line.medicine.displayName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() {
                  _lines.remove(line);
                  line.dispose();
                }),
              ),
            ],
          ),
          AppDropdown<String>(
            label: AppStrings.unitLabel,
            value: line.unitId,
            items: [
              for (final u in line.medicine.units)
                AppDropdownItem(value: u.unitId, label: u.unitName),
            ],
            onChanged: (v) => setState(() => line.unitId = v ?? line.unitId),
          ),
          Row(
            children: [
              Expanded(
                child: AppNumberField(
                    controller: line.price,
                    label: AppStrings.unitCost,
                    onChanged: (_) => setState(() {})),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppNumberField(
                    controller: line.qty,
                    label: AppStrings.quantity,
                    onChanged: (_) => setState(() {})),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppDatePicker(
            label: AppStrings.expirationDate,
            value: line.expiry,
            hint: AppStrings.expirationDate,
            onChanged: (d) => setState(() => line.expiry = d),
          ),
          // باركود: يظهر فقط إذا كان الدواء بلا باركود — يُدخَل يدوياً أو بالماسح.
          if (line.medicine.barcode.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: line.barcodeCtrl,
              label: 'باركود الدواء (اختياري)',
              hint: 'امسح بالماسح أو أدخله يدوياً',
              prefixIcon: const Icon(Icons.qr_code_2),
              onChanged: (v) => line.scannedBarcode = v.trim().isEmpty ? null : v.trim(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryBar(String code, String? warehouseId, Currency? base) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: context.semantic.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.total,
                          style: theme.textTheme.bodySmall),
                      Text(
                          Formatters.money(_total, code),
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: _saving ? AppStrings.saving : AppStrings.save,
                    isLoading: _saving,
                    onPressed: () => _save(warehouseId, base),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
