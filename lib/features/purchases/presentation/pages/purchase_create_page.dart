import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/presentation/widgets/currency_picker_field.dart';
import 'package:saydaliati/features/suppliers/presentation/widgets/supplier_picker_field.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/network/server_capabilities.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currency_freshness.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/medicine_scan_actions.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/purchases/domain/entities/create_purchase_input.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchases_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/supplier_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/cards/invoice_total_badge.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';

/// Plain, parse-safe number string (no thousands separators) — the price/qty
/// fields are read back with `double.tryParse`, which rejects grouped values.
String _plainNum(num v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

class _PurLine {
  _PurLine({required this.medicine, required this.unitId, double unitPrice = 0}) {
    price.text = unitPrice == 0 ? '' : _plainNum(unitPrice);
    suggested = unitPrice == 0 ? null : unitPrice;
    qty.text = '1';
  }

  /// هل ما زالت القيمة هي المقترَحة (لم يلمسها المستخدم)؟
  bool get holdsSuggestion {
    final s = suggested;
    if (s == null) return price.text.trim().isEmpty;
    final current = double.tryParse(price.text.trim());
    return current != null && (current - s).abs() < 0.005;
  }

  final Medicine medicine;
  String unitId;

  /// آخر تكلفة اقترحها البرنامج لهذا السطر (بعملة الفاتورة). تُقارَن بالقيمة
  /// الحالية لمعرفة ما إذا كان المستخدم قد عدّلها يدوياً — فتغيير النسبة لا
  /// يدوس على تعديل متعمَّد.
  double? suggested;

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

  /// نسبة سعر الشراء المقترَح من سعر المبيع. الافتراضي 27% — رقم تقريبي شائع
  /// لهامش الصيدليات، والمستخدم يغيّره من تنويه أعلى الفاتورة.
  double _costPercent = _defaultCostPercent;
  static const double _defaultCostPercent = 27;

  /// التكلفة المقترَحة لوحدة بعملة الفاتورة = سعر مبيعها × النسبة.
  double _suggestedCost(MedicineUnit unit, Currency? base, Currency? selected) =>
      convertFromBase(unit.salePrice * _costPercent / 100, base, selected);

  /// تغيير النسبة يعيد تسعير الأسطر التي ما زالت تحمل القيمة المقترَحة فقط —
  /// أي سطر عدّله المستخدم يدوياً يبقى كما تركه.
  void _applyPercent(double percent) {
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == _effectiveCurrencyId(base)).firstOrNull;

    setState(() {
      _costPercent = percent;
      for (final line in _lines) {
        if (!line.holdsSuggestion) continue;
        final unit = line.medicine.units
            .where((u) => u.unitId == line.unitId)
            .firstOrNull;
        if (unit == null) continue;
        final cost = _suggestedCost(unit, base, selected);
        line.suggested = cost;
        line.price.text = cost == 0 ? '' : _plainNum(cost);
      }
    });
  }

  /// يفتح نافذة تغيير النسبة.
  Future<void> _editPercent() async {
    final value = await showDialog<double>(
      context: context,
      builder: (_) => _CostPercentDialog(initial: _costPercent),
    );
    if (value == null || !mounted) return;
    _applyPercent(value);
  }
  String? _currencyId;
  String? _supplierId; // المورّد (اختياري)
  PaymentMethod _payMethod = PaymentMethod.cash;
  String? _paymentAccountId;
  String? _lastSuggestedPaymentAccountId;
  bool _saving = false;
  bool _prefilled = false;
  bool _prefillStarted = false;

  @override
  void initState() {
    super.initState();
    // الفاتورة تُسعَّر بسعر الصرف — نُحدِّثه إن قَدُم قبل أن يبدأ الإدخال.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) CurrencyFreshness.refreshIfStale(ref);
    });
  }

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
    _paymentAccountId =
        p.paymentAccountId.isNotEmpty ? p.paymentAccountId : null;
    _lastSuggestedPaymentAccountId = null;
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

  /// يقترح صندوق العملة المختارة (الحساب المرتبط بها)، أو صندوق العملة
  /// الأساسية إن لم يوجد صندوق مخصَّص لها. لا يلمس اختياراً صريحاً للمستخدم.
  void _suggestPaymentAccountForCurrency(
      String? currencyId, List<Account> accounts, String? baseCurrencyId) {
    if (accounts.isEmpty) return;
    final untouched = _paymentAccountId == null ||
        _paymentAccountId == _lastSuggestedPaymentAccountId;
    if (!untouched) return;

    final matching = accounts.where((a) => a.currencyId == currencyId).firstOrNull;
    final fallbackCash = accounts.where((a) => a.currencyId == baseCurrencyId).firstOrNull;
    final suggested = matching ?? fallbackCash;
    if (suggested == null) return;

    _lastSuggestedPaymentAccountId = suggested.id;
    _paymentAccountId = suggested.id;
  }

  void _add(Medicine m, {bool mergeWithLast = true}) {
    // نفس المادة مباشرة بعد بعضها (آخر سطر هو نفسها) → زيادة الكمية بدل سطر
    // جديد. أما إن دخلت مادة أخرى بينهما فتُضاف كسطر مستقل (خصم مستقل مثلاً).
    if (mergeWithLast &&
        _lines.isNotEmpty &&
        _lines.last.medicine.id == m.id) {
      final last = _lines.last;
      final q = double.tryParse(last.qty.text.trim()) ?? 0;
      setState(() => last.qty.text = _plainNum(q + 1));
      return;
    }
    if (m.units.isEmpty) {
      AppSnackbar.error(context, AppStrings.noPricedUnitForProduct);
      return;
    }
    // اختيار الوحدة الافتراضية تلقائياً (وإلا الأولى) — ويمكن تغييرها من القائمة.
    final unit =
        m.units.firstWhere((u) => u.isDefault, orElse: () => m.units.first);
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == _effectiveCurrencyId(base)).firstOrNull;
    // التكلفة المقترَحة = نسبة [_costPercent] من سعر مبيع هذه الوحدة، محوَّلةً
    // لعملة الفاتورة. مجرّد اقتراح — التنويه أعلى الفاتورة يشرحه، والمستخدم
    // يغيّر النسبة أو يكتب القيمة مباشرة في خلية السعر.
    final cost = _suggestedCost(unit, base, selected);
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
    if (_payMethod != PaymentMethod.credit &&
        (_paymentAccountId == null || _paymentAccountId!.isEmpty)) {
      AppSnackbar.error(context, AppStrings.selectAccount);
      return;
    }
    if (_lines.isEmpty) {
      AppSnackbar.error(context, AppStrings.purchaseEmptyHint);
      return;
    }
    // الشراء الآجل يتطلب مورّداً إجبارياً (يُنشئ حركة ذمّة بدل دفع فوري بالخادم).
    if (_payMethod.requiresParty && (_supplierId == null || _supplierId!.isEmpty)) {
      AppSnackbar.error(context, AppStrings.creditPurchaseNeedsSupplier);
      return;
    }

    setState(() => _saving = true);
    // Store costs in the BASE currency: convert the prices entered in the
    // selected currency back to base, and record the base currency id.
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == currencyId).firstOrNull;
    double toBase(double v) => convertToBase(v, base, selected);
    // عملة الفاتورة تُحفظ الآن بدل أن تُرمى، والمبالغ تُرسَل بها إن كان
    // الخادم يحوّلها بنفسه (خادم أقدم يتجاهل العلم فنحوّل نحن كما كان).
    final isForeign = selected != null && base != null && selected.id != base.id;
    final serverConverts = isForeign &&
        ref.read(serverCapabilitiesProvider).value?.amountsInOriginalCurrency ==
            true;

    final input = CreatePurchaseInput(
      currencyId: base?.id ?? currencyId,
      originalCurrencyId: isForeign ? selected.id : null,
      amountsInOriginalCurrency: serverConverts,
      warehouseId: warehouseId,
      supplierId: _supplierId,
      purchaseDate: DateTime.now(),
      totalAmount: serverConverts ? _total : toBase(_total),
      paymentMethod: _payMethod,
      paymentAccountId: _payMethod == PaymentMethod.credit ? null : _paymentAccountId,
      lines: [
        for (final l in _lines)
          CreatePurchaseLineInput(
            medicineId: l.medicine.id,
            unitId: l.unitId,
            unitPrice: serverConverts
                ? (double.tryParse(l.price.text.trim()) ?? 0)
                : toBase(double.tryParse(l.price.text.trim()) ?? 0),
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
    final selectedCurrency = currencies
        .where((c) => c.id == _effectiveCurrencyId(base))
        .firstOrNull;
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    _suggestPaymentAccountForCurrency(_effectiveCurrencyId(base), accounts, base?.id);

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
      child: SaveShortcut(
      onSave: () => _save(warehouseId, base),
      enabled: !_saving,
      child: Scaffold(
      appBar: AppBar(
          title: Text(_isEdit ? AppStrings.editPurchase : AppStrings.newPurchase),
          actions: [
            if (!_isEdit)
              IconButton(
                tooltip: 'سجلّ المشتريات',
                icon: const Icon(Icons.history),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const PurchasesPage())),
              ),
            const TutorialHelpButton(TutorialTopic.firstPurchase),
          ]),
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
                _CostSuggestionNotice(
                  percent: _costPercent,
                  isDefault: _costPercent == _defaultCostPercent,
                  onEdit: _editPercent,
                  onReset: _costPercent == _defaultCostPercent
                      ? null
                      : () => _applyPercent(_defaultCostPercent),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CurrencyPickerField(
                        label: AppStrings.selectCurrency,
                        // عملات قابلة للاختيار فقط: الأساسية + أي عملة سعر صرفها موجب
                        // (عملة بلا سعر صرف تُخفى لأن التحويل يُرجِع المبلغ دون تحويل).
                        currencies: currencies
                            .where((c) => c.isBaseCurrency || c.exchangeRate > 0)
                            .toList(),
                        selectedId: _effectiveCurrencyId(base).isEmpty
                            ? null
                            : _effectiveCurrencyId(base),
                        onSelected: (c) => setState(() => _currencyId = c.id),
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
                    if (_payMethod != PaymentMethod.credit) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AccountPickerField(
                          label: AppStrings.selectAccount,
                          accounts: accounts,
                          selectedId: _paymentAccountId,
                          onSelected: (a) =>
                              setState(() => _paymentAccountId = a.id),
                        ),
                      ),
                    ],
                  ],
                ),
                // المورّد (اختياري) — يظهر فقط إن وُجد موردون.
                Builder(builder: (_) {
                  final suppliers =
                      ref.watch(suppliersProvider).value ?? const <Supplier>[];
                  if (suppliers.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: SupplierPickerField(
                      label: 'المورّد (اختياري)',
                      hint: '— بلا مورّد —',
                      suppliers: suppliers,
                      selectedId: _supplierId,
                      allowClear: true,
                      onCleared: () => setState(() => _supplierId = null),
                      onSelected: (s) => setState(() => _supplierId = s.id),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          // الجدول دائم الظهور: آخر صف فيه هو "صف جديد" تُختار المادة من خليته.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _linesGrid(catalog),
            ),
          ),
          _summaryBar(selectedCurrency, warehouseId, base),
        ],
      ),
      ),
    ),
    );
  }

  /// Picks a medicine from the grid cell (wakeed-style in-cell selection).
  /// [line] == null → the trailing "new row": appends a line. Otherwise the
  /// existing row's medicine is replaced (fresh unit/cost defaults).
  Future<void> _pickMedicineForLine(
      List<Medicine> catalog, _PurLine? line) async {
    final picked = await showMedicinePicker(context, catalog);
    if (picked == null || !mounted) return;
    if (line == null) {
      _add(picked);
      return;
    }
    // استبدال مادة صف موجود: دائماً سطر جديد في نفس الموضع، بلا دمج.
    final index = _lines.indexOf(line);
    if (index < 0) return;
    final before = _lines.length;
    _add(picked, mergeWithLast: false);
    if (_lines.length > before) {
      setState(() {
        final fresh = _lines.removeLast();
        _lines[index] = fresh;
        line.dispose();
      });
    }
  }

  // ─── جدول الفاتورة: غريد Trina حقيقي (نفس أسلوب فاتورة المبيعات) ──────────

  static const _fId = 'id';
  static const _fMed = 'med';
  static const _fUnit = 'unit';
  static const _fCost = 'cost';
  static const _fQty = 'qty';
  static const _fExpiry = 'expiry';
  static const _fBarcode = 'barcode';
  static const _fTotal = 'total';
  static const _fDel = 'del';
  static const _newRowId = '__new__';

  String _lineId(_PurLine l) => identityHashCode(l).toString();

  /// بصمة بنيوية للأسطر: أي تغيير يعيد بناء الشبكة بقيم محدّثة
  /// (التحرير داخل الخلية يلتزم عند الخروج منها).
  Key _gridKey() => ValueKey(Object.hashAll([
        for (final l in _lines) ...[
          identityHashCode(l),
          l.unitId,
          l.price.text,
          l.qty.text,
          l.expiry,
          l.scannedBarcode,
        ],
      ]));

  Widget _linesGrid(List<Medicine> catalog) {
    final theme = Theme.of(context);
    // عمود الباركود يظهر فقط إذا كان في الفاتورة دواء بلا باركود.
    final needsBarcode = _lines.any((l) => l.medicine.barcode.isEmpty);
    final byId = {for (final l in _lines) _lineId(l): l};

    bool isNewRow(TrinaRow<dynamic> row) => row.cells[_fId]?.value == _newRowId;
    _PurLine? lineOf(TrinaRow<dynamic> row) => byId[row.cells[_fId]?.value];

    return AppGrid(
      key: _gridKey(),
      showColumnFilter: false,
      columns: [
        TrinaColumn(
          title: AppStrings.medicineName,
          field: _fMed,
          type: TrinaColumnType.text(),
          width: 240,
          enableEditingMode: false,
          renderer: (ctx) {
            if (isNewRow(ctx.row)) {
              return Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => _pickMedicineForLine(catalog, null),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('اختر مادة…'),
                ),
              );
            }
            final l = lineOf(ctx.row);
            if (l == null) return const SizedBox.shrink();
            return InkWell(
              onTap: () => _pickMedicineForLine(catalog, l),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.medicine.displayName,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.edit_outlined, size: 13, color: theme.hintColor),
                ],
              ),
            );
          },
        ),
        TrinaColumn(
          title: AppStrings.unitLabel,
          field: _fUnit,
          type: TrinaColumnType.text(),
          width: 120,
          enableEditingMode: false,
          renderer: (ctx) {
            final l = lineOf(ctx.row);
            if (l == null) return const SizedBox.shrink();
            return PopupMenuButton<String>(
              tooltip: AppStrings.unitLabel,
              onSelected: (v) => setState(() => l.unitId = v),
              itemBuilder: (_) => [
                for (final u in l.medicine.units)
                  PopupMenuItem(value: u.unitId, child: Text(u.unitName)),
              ],
              child: Row(
                children: [
                  Expanded(
                    child: Text(ctx.cell.value?.toString() ?? '',
                        overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.arrow_drop_down, size: 16, color: theme.hintColor),
                ],
              ),
            );
          },
        ),
        TrinaColumn(
          title: AppStrings.unitCost,
          field: _fCost,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 110,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
          checkReadOnly: (row, cell) => isNewRow(row),
        ),
        TrinaColumn(
          title: AppStrings.quantity,
          field: _fQty,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 95,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
          checkReadOnly: (row, cell) => isNewRow(row),
        ),
        TrinaColumn(
          title: AppStrings.expiryDateLabel,
          field: _fExpiry,
          type: TrinaColumnType.text(),
          width: 130,
          enableEditingMode: false,
          renderer: (ctx) {
            final l = lineOf(ctx.row);
            if (l == null) return const SizedBox.shrink();
            return InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: l.expiry ?? now,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 15),
                );
                if (picked != null) setState(() => l.expiry = picked);
              },
              child: Row(
                children: [
                  Icon(Icons.event_outlined,
                      size: 14, color: theme.hintColor),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      ctx.cell.value?.toString().isNotEmpty == true
                          ? ctx.cell.value.toString()
                          : AppStrings.expirationDate,
                      overflow: TextOverflow.ellipsis,
                      style: ctx.cell.value?.toString().isNotEmpty == true
                          ? null
                          : TextStyle(
                              color: theme.hintColor, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (needsBarcode)
          TrinaColumn(
            title: 'الباركود',
            field: _fBarcode,
            type: TrinaColumnType.text(),
            width: 130,
            enableEditingMode: true,
            // يُحرَّر فقط لدواء بلا باركود.
            checkReadOnly: (row, cell) {
              if (isNewRow(row)) return true;
              final l = lineOf(row);
              return l == null || l.medicine.barcode.isNotEmpty;
            },
          ),
        appGridNumberColumn(AppStrings.total, _fTotal, width: 120,
            renderer: (ctx) {
          if (isNewRow(ctx.row)) return const SizedBox.shrink();
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.number(n),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
        TrinaColumn(
          title: '',
          field: _fDel,
          type: TrinaColumnType.text(),
          width: 50,
          enableEditingMode: false,
          enableContextMenu: false,
          enableFilterMenuItem: false,
          enableSorting: false,
          renderer: (ctx) {
            final l = lineOf(ctx.row);
            if (l == null) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.delete_outline,
                  size: 16, color: theme.colorScheme.error),
              visualDensity: VisualDensity.compact,
              tooltip: AppStrings.delete,
              onPressed: () => setState(() {
                _lines.remove(l);
                l.dispose();
              }),
            );
          },
        ),
        TrinaColumn(
            title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
      ],
      rows: [
        for (final l in _lines)
          TrinaRow(cells: {
            _fId: TrinaCell(value: _lineId(l)),
            _fMed: TrinaCell(value: l.medicine.displayName),
            _fUnit: TrinaCell(
                value: l.medicine.units
                        .where((u) => u.unitId == l.unitId)
                        .map((u) => u.unitName)
                        .firstOrNull ??
                    ''),
            _fCost: TrinaCell(
                value: double.tryParse(l.price.text.trim()) ?? ''),
            _fQty: TrinaCell(value: double.tryParse(l.qty.text.trim()) ?? ''),
            _fExpiry: TrinaCell(
                value: l.expiry != null ? _ymd(l.expiry!) : ''),
            if (needsBarcode)
              _fBarcode: TrinaCell(
                  value: l.medicine.barcode.isNotEmpty
                      ? l.medicine.barcode
                      : (l.scannedBarcode ?? '')),
            _fTotal: TrinaCell(value: l.lineTotal),
            _fDel: TrinaCell(value: ''),
          }),
        // صف الإضافة الدائم.
        TrinaRow(cells: {
          _fId: TrinaCell(value: _newRowId),
          _fMed: TrinaCell(value: ''),
          _fUnit: TrinaCell(value: ''),
          _fCost: TrinaCell(value: ''),
          _fQty: TrinaCell(value: ''),
          _fExpiry: TrinaCell(value: ''),
          if (needsBarcode) _fBarcode: TrinaCell(value: ''),
          _fTotal: TrinaCell(value: ''),
          _fDel: TrinaCell(value: ''),
        }),
      ],
      onChanged: (e) {
        final l = lineOf(e.row);
        if (l == null) return;
        setState(() {
          switch (e.column.field) {
            case _fCost:
              final v = e.value is num
                  ? (e.value as num).toDouble()
                  : double.tryParse(e.value?.toString() ?? '');
              if (v != null && v >= 0) l.price.text = _plainNum(v);
            case _fQty:
              final v = e.value is num
                  ? (e.value as num).toDouble()
                  : double.tryParse(e.value?.toString() ?? '');
              if (v != null && v > 0) l.qty.text = _plainNum(v);
            case _fBarcode:
              final s = e.value?.toString().trim() ?? '';
              l.barcodeCtrl.text = s;
              l.scannedBarcode = s.isEmpty ? null : s;
          }
        });
      },
    );
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _summaryBar(Currency? selected, String? warehouseId, Currency? base) {
    final theme = Theme.of(context);
    return Container(
      // شريط ملخص بأسلوب سطح المكتب (مطابق لفاتورة المبيعات).
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: context.semantic.border)),
      ),
      child: Row(
        children: [
          InvoiceTotalBadge(total: _total, selected: selected, base: base),
          const Spacer(),
          SizedBox(
            width: 180,
            child: AppButton.primary(
              label: _saving ? AppStrings.saving : AppStrings.save,
              icon: Icons.save_outlined,
              isLoading: _saving,
              onPressed: () => _save(warehouseId, base),
            ),
          ),
        ],
      ),
    );
  }
}


/// تنويه أعلى فاتورة الشراء: يشرح أن سعر الشراء مقترَح تلقائياً من سعر المبيع،
/// ويتيح تغيير النسبة أو إعادتها لافتراضيّها. القيمة نفسها تبقى قابلة للتعديل
/// مباشرةً في خلية السعر داخل الجدول.
class _CostSuggestionNotice extends StatelessWidget {
  const _CostSuggestionNotice({
    required this.percent,
    required this.isDefault,
    required this.onEdit,
    required this.onReset,
  });

  final double percent;
  final bool isDefault;
  final VoidCallback onEdit;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = context.semantic.info;
    final shown = percent == percent.roundToDouble()
        ? percent.toInt().toString()
        : percent.toString();

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: AppRadius.brSm,
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_outlined,
              size: AppSizes.iconSm, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                const TextSpan(text: 'سعر الشراء مقترَح تلقائياً = '),
                TextSpan(
                  text: '$shown٪',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: accent),
                ),
                const TextSpan(
                  text: ' من سعر المبيع — غيّر النسبة، أو اكتب السعر مباشرةً '
                      'في عمود «سعر التكلفة».',
                ),
              ]),
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (onReset != null)
            IconButton(
              icon: const Icon(Icons.restart_alt, size: AppSizes.iconXs),
              tooltip: 'إرجاع النسبة الافتراضية',
              visualDensity: VisualDensity.compact,
              onPressed: onReset,
            ),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.percent, size: AppSizes.iconXs),
            label: const Text('تغيير النسبة'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              foregroundColor: accent,
              side: BorderSide(color: accent.withValues(alpha: 0.45)),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.brXs),
              textStyle: theme.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// نافذة تغيير نسبة سعر الشراء من سعر المبيع.
class _CostPercentDialog extends StatefulWidget {
  const _CostPercentDialog({required this.initial});

  final double initial;

  @override
  State<_CostPercentDialog> createState() => _CostPercentDialogState();
}

class _CostPercentDialogState extends State<_CostPercentDialog> {
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.initial == widget.initial.roundToDouble()
        ? widget.initial.toInt().toString()
        : widget.initial.toString(),
  );
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_ctrl.text.trim().replaceAll('٪', ''));
    if (value == null || value <= 0 || value > 100) {
      setState(() => _error = 'أدخل نسبة بين 1 و 100');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('نسبة سعر الشراء'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'سعر الشراء المقترَح = النسبة × سعر المبيع. تُطبَّق على الأسطر التي '
            'لم تعدّل سعرها يدوياً، وعلى ما تضيفه بعدها.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'النسبة ٪',
              suffixText: '٪',
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(onPressed: _submit, child: const Text(AppStrings.save)),
      ],
    );
  }
}
