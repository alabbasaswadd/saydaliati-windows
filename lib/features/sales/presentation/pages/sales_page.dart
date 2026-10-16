import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/presentation/widgets/currency_picker_field.dart';
import 'package:saydaliati/features/customers/presentation/widgets/customer_picker_field.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/network/server_capabilities.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currency_freshness.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/medicine_scan_actions.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/purchases/domain/entities/create_purchase_input.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/sales/domain/entities/create_sale_input.dart';
import 'package:saydaliati/features/sales/domain/entities/medicine_batch.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/pages/pending_invoices_page.dart';
import 'package:saydaliati/features/sales/presentation/providers/sales_provider.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/cards/invoice_total_badge.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcuts_scope.dart';
import 'package:saydaliati/shared/widgets/inputs/app_toolbar_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// One receipt line held in memory (there is no cart on the backend).
class _PosLine {
  _PosLine({required this.medicine, required this.unit, required this.unitPrice});

  final Medicine medicine;
  MedicineUnit unit; // selected unit (holds the base-currency salePrice)
  double unitPrice; // in the selected currency
  double quantity = 1;

  // Available expiry batches + the chosen one (default: nearest expiry).
  List<MedicineBatch> batches = const [];
  MedicineBatch? selectedBatch;

  double get total => unitPrice * quantity;
}

/// Tab 3 — المبيعات (نقطة البيع). عند الاستخدام الرئيسي (بلا معاملات) يفتح
/// عدة فواتير في تابات أعلى الشاشة (كمتصفح) عبر [_SalesTabsHost]؛ عند تمرير
/// [saleToEdit]/[queuedId] (تعديل فاتورة من مكان آخر) يُفتح محرر فاتورة واحدة
/// كما كان، بلا تابات.
class SalesPage extends StatelessWidget {
  const SalesPage({this.saleToEdit, this.queuedId, this.queuedPayload, super.key});

  /// When set, the page edits this existing (synced) invoice instead of creating
  /// a new one (prefills its lines + customer; saves via update).
  final Sale? saleToEdit;

  /// When set, the page edits a still-queued (un-synced) offline invoice: it
  /// prefills from [queuedPayload] and, on save, updates the outbox entry
  /// [queuedId] (and reconciles the local stock cache) instead of posting.
  final String? queuedId;
  final Map<String, dynamic>? queuedPayload;

  @override
  Widget build(BuildContext context) {
    if (saleToEdit != null || queuedId != null) {
      return _SingleSaleScaffold(
        saleToEdit: saleToEdit,
        queuedId: queuedId,
        queuedPayload: queuedPayload,
      );
    }
    return const _SalesTabsHost();
  }
}

/// محرر فاتورة واحدة — نفس منطق نقطة البيع الأصلي. [standalone] يتحكم بإظهار
/// الـ Scaffold/AppBar الخاصة به: true (الافتراضي، تعديل فاتورة) يعرضها كاملة
/// كصفحة قائمة بذاتها؛ false (تاب داخل [_SalesTabsHost]) يعرض المحتوى فقط
/// لأن الـ AppBar وشريط التابات مِن الحاوية الخارجية. [onDirtyChanged] يُبلّغ
/// الحاوية إن كان في هذه الفاتورة أسطر غير محفوظة (لتحذير المستخدم عند إغلاق تابها).
class _SingleSaleScaffold extends ConsumerStatefulWidget {
  const _SingleSaleScaffold({
    this.saleToEdit,
    this.queuedId,
    this.queuedPayload,
    this.standalone = true,
    this.active = true,
    this.onDirtyChanged,
    super.key,
  });

  final Sale? saleToEdit;
  final String? queuedId;
  final Map<String, dynamic>? queuedPayload;
  final bool standalone;

  /// التاب المعروض حالياً. التابات المخفيّة تبقى حيّة داخل [IndexedStack]،
  /// فلو سجّلت كلها معالجات الاختصارات لتنازعت عليها — النشط وحده يسجّل.
  final bool active;

  final ValueChanged<bool>? onDirtyChanged;

  @override
  ConsumerState<_SingleSaleScaffold> createState() => _SingleSaleScaffoldState();
}

class _SingleSaleScaffoldState extends ConsumerState<_SingleSaleScaffold> {
  final List<_PosLine> _lines = [];

  /// ربط اختصارات الفاتورة بعمر هذا التاب (يُسجَّل وهو نشط فقط).
  late final ShortcutRegistration _shortcuts = ShortcutRegistration(ref, this);
  bool _shortcutsBound = false;

  /// مدير شبكة الأسطر — تحتاجه اختصارات «حذف السطر» و«تعديل الكمية» لمعرفة
  /// السطر المحدَّد حالياً.
  TrinaGridStateManager? _grid;

  /// السطر المحدَّد حالياً (بمعرّف [_lineId]).
  ///
  /// أي تغيير في الأسطر يبدّل بصمة [_gridKey] فتُعاد الشبكة من الصفر ويضيع
  /// تحديدها الداخلي — لذا نحتفظ بالمحدَّد هنا ونعيد ضبطه بعد كل بناء. بهذا
  /// يصير السطر المضاف محدَّداً تلقائياً فتعمل اختصارات الكمية والحذف عليه فوراً.
  String? _currentLineId;

  /// آخر قيم بناء يحتاجها الحفظ/الإضافة من خارج دورة البناء (الاختصارات).
  List<Medicine> _lastCatalog = const [];
  String? _lastWarehouseId;
  Currency? _lastBase;
  DateTime _saleDate = DateTime.now();
  String? _currencyId;
  String? _customerId;
  PaymentMethod _payMethod = PaymentMethod.cash;
  String? _paymentAccountId;
  String? _lastSuggestedPaymentAccountId;
  bool _isPrescription = false;
  bool _submitting = false;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _syncShortcuts();
    // السعر يهمّ هنا أكثر من أي مكان: الفاتورة تُسعَّر به. نُحدِّثه إن قَدُم.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) CurrencyFreshness.refreshIfStale(ref);
    });
  }

  @override
  void didUpdateWidget(covariant _SingleSaleScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _syncShortcuts();
  }

  @override
  void dispose() {
    _grid?.removeListener(_onGridSelectionChanged);
    _shortcuts.dispose();
    super.dispose();
  }

  /// التاب النشط يملك اختصارات الفاتورة؛ الخامل يتخلّى عنها.
  void _syncShortcuts() {
    if (widget.active == _shortcutsBound) return;
    _shortcutsBound = widget.active;
    if (!widget.active) {
      _shortcuts.dispose();
      return;
    }
    _shortcuts.bind({
      ShortcutAction.invoiceSave: () => _submit(_lastWarehouseId, _lastBase),
      ShortcutAction.invoiceCancel: _clearInvoice,
      ShortcutAction.invoiceAddItem: () =>
          _pickMedicineForLine(_lastCatalog, null, mergeIfSame: true),
      ShortcutAction.invoiceDeleteLine: _deleteCurrentLine,
      ShortcutAction.invoiceEditQty: _editCurrentQuantity,
      ShortcutAction.invoicePickCustomer: _pickCustomerByShortcut,
      ShortcutAction.invoicePickCurrency: _pickCurrencyByShortcut,
      ShortcutAction.invoicePrescription: () =>
          setState(() => _isPrescription = !_isPrescription),
    });
  }

  // ─── إجراءات الاختصارات ─────────────────────────────────────────────────

  /// يفرّغ أسطر الفاتورة بعد تأكيد (لا يمسّ التاريخ/العملة/العميل).
  Future<void> _clearInvoice() async {
    if (_lines.isEmpty) return;
    final ok = await showConfirmationDialog(
      context,
      title: 'إلغاء الفاتورة؟',
      message: 'ستُحذف كل أسطر هذه الفاتورة.',
      confirmLabel: 'إلغاء الفاتورة',
    );
    if (!ok || !mounted) return;
    setState(_lines.clear);
  }

  /// السطر الذي تعمل عليه اختصارات السطر.
  ///
  /// الأولوية لمؤشّر الشبكة، ثم [_currentLineId] (الحالة بين إعادة بناء الشبكة
  /// وإعادة ضبط تحديدها)، وإلا **آخر سطر** — فالمؤشّر حين يكون على صف الإضافة
  /// أو لا تحديد أصلاً، المقصود عملياً هو السطر الذي أُضيف للتو.
  _PosLine? get _currentLine {
    final fromGrid = _grid?.currentRow?.cells[_fId]?.value?.toString();
    final id =
        (fromGrid != null && fromGrid != _newRowId) ? fromGrid : _currentLineId;
    final selected =
        id == null ? null : _lines.where((l) => _lineId(l) == id).firstOrNull;
    return selected ?? _lines.lastOrNull;
  }

  /// يجعل [line] هو السطر المحدَّد — يُستدعى بعد اختيار مادة فيصبح السطر
  /// الجديد جاهزاً لاختصارات الكمية والحذف بلا نقرة إضافية.
  void _selectLine(_PosLine line) => _currentLineId = _lineId(line);

  /// يربط مدير الشبكة الجديد (كل إعادة بناء تعطي مديراً جديداً) ويعيد التحديد.
  void _attachGrid(TrinaGridStateManager manager) {
    _grid?.removeListener(_onGridSelectionChanged);
    _grid = manager;
    manager.addListener(_onGridSelectionChanged);
    _restoreSelection();
  }

  /// يتابع تحديد المستخدم بالفأرة/الأسهم حتى لا يضيع عند إعادة البناء.
  void _onGridSelectionChanged() {
    final id = _grid?.currentRow?.cells[_fId]?.value?.toString();
    if (id == null || id == _newRowId) return;
    _currentLineId = id;
  }

  /// يعيد ضبط الخلية الحالية على السطر المحفوظ بعد بناء الشبكة.
  void _restoreSelection() {
    final id = _currentLineId;
    final grid = _grid;
    if (id == null || grid == null) return;

    // بعد اكتمال الإطار: الصفوف لم تُركَّب بعد أثناء onLoaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_grid, grid)) return;
      _focusQuantityCell(grid, id, startEditing: false);
    });
  }

  /// ينقل الخلية الحالية إلى خلية كمية السطر [lineId]، ويفتحها للتحرير عند
  /// [startEditing]. يعيد `false` إن لم يعد السطر موجوداً في الشبكة.
  bool _focusQuantityCell(
    TrinaGridStateManager grid,
    String lineId, {
    required bool startEditing,
  }) {
    final index = grid.refRows
        .indexWhere((r) => r.cells[_fId]?.value?.toString() == lineId);
    if (index < 0) return false;
    final cell = grid.refRows[index].cells[_fQty];
    if (cell == null) return false;

    // الشبكة قد تكون بلا تركيز (أُغلق منتقي الدواء للتو)، وبلا تركيزها لا
    // تستقبل خلية التحرير ما يُكتَب. وطلب التركيز يتأخّر إطاراً كاملاً، فيأتي
    // فتح التحرير بعده لا معه.
    if (startEditing) grid.setKeepFocus(true);
    grid.setCurrentCell(cell, index);
    if (!startEditing) return true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_grid, grid)) return;
      grid.setEditing(true);
    });
    return true;
  }

  void _deleteCurrentLine() {
    final line = _currentLine;
    if (line == null) {
      AppSnackbar.info(context, 'لا توجد أسطر في الفاتورة');
      return;
    }
    // التحديد ينتقل للسطر السابق (أو التالي) حتى يبقى الحذف المتتابع ممكناً.
    final index = _lines.indexOf(line);
    final next = index > 0
        ? _lines[index - 1]
        : (_lines.length > 1 ? _lines[index + 1] : null);
    setState(() => _lines.remove(line));
    _currentLineId = next == null ? null : _lineId(next);
  }

  /// ينقل التحرير إلى خلية الكمية في السطر المحدَّد.
  void _editCurrentQuantity() {
    final grid = _grid;
    final line = _currentLine;
    if (grid == null || line == null) {
      AppSnackbar.info(context, 'لا توجد أسطر في الفاتورة');
      return;
    }
    _focusQuantityCell(grid, _lineId(line), startEditing: true);
  }

  /// تغيير عملة الفاتورة من الاختصار — نفس قائمة حقل العملة في الشريط
  /// (الأساسية + كل عملة لها سعر صرف موجب)، ثم يُعاد تسعير الأسطر.
  Future<void> _pickCurrencyByShortcut() async {
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selectable = currencies
        .where((c) => c.isBaseCurrency || c.exchangeRate > 0)
        .toList();
    final picked = await showCurrencyPicker(context, selectable);
    if (picked == null || !mounted) return;
    setState(() {
      _currencyId = picked.id;
      _repriceLines(_lastBase, currencies);
    });
  }

  Future<void> _pickCustomerByShortcut() async {
    final customers = ref.read(customersProvider).value ?? const <Customer>[];
    final picked = await showCustomerPicker(context, customers);
    if (picked == null || !mounted) return;
    setState(() => _customerId = picked.id);
  }

  bool get _isEdit => widget.saleToEdit != null;
  bool get _isQueuedEdit => widget.queuedId != null;

  double get _total => _lines.fold(0, (s, l) => s + l.total);

  String _effectiveCurrencyId(Currency? base) => _currencyId ?? base?.id ?? '';

  Currency? _selectedCurrency(Currency? base, List<Currency> currencies) =>
      currencies.where((c) => c.id == _effectiveCurrencyId(base)).firstOrNull;

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

  /// كلفة **وحدة السطر** بالعملة الأساسية.
  ///
  /// `Medicine.purchaseCost` كلفة الوحدة **الأساسية** (الحبة مثلاً)، وسعر
  /// السطر سعر الوحدة المختارة (علبة = 20 حبة). فمقارنتهما مباشرةً تقارن
  /// سعر علبة بكلفة حبة — وكان ذلك يُسكِت التنويه عن خسارة حقيقية: علبة
  /// بـ6 وكلفة حبّتها 2 خسارةٌ قدرها 34، والفحص القديم يراها ربحاً.
  double _unitCostInBase(_PosLine line) {
    final factor =
        line.unit.conversionFactor > 0 ? line.unit.conversionFactor : 1;
    return line.medicine.purchaseCost * factor;
  }

  /// هل سعر هذا السطر أقل من كلفته؟
  ///
  /// الهامش يمنع تنويهاً عن فروق التدوير (سعر 20.00 وكلفة 20.0001).
  bool _isNegativeProfit(_PosLine line) {
    if (line.medicine.purchaseCost <= 0) return false;
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected = _selectedCurrency(base, currencies);
    return convertToBase(line.unitPrice, base, selected) <
        _unitCostInBase(line) - 0.005;
  }

  /// Removes a line and shows a 2-second SnackBar with an undo action that
  /// restores it to its original position.
  void _removeWithUndo(_PosLine line) {
    final index = _lines.indexOf(line);
    if (index < 0) return;
    setState(() => _lines.removeAt(index));
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(
      content: const Text(AppStrings.lineDeleted),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: AppStrings.undo,
        onPressed: () =>
            setState(() => _lines.insert(index.clamp(0, _lines.length), line)),
      ),
    ));
  }

  /// Re-prices every line from its base salePrice into the selected currency
  /// (called when the currency changes). Overwrites manual price edits.
  void _repriceLines(Currency? base, List<Currency> currencies) {
    final selected = _selectedCurrency(base, currencies);
    for (final l in _lines) {
      l.unitPrice = convertFromBase(l.unit.salePrice, base, selected);
    }
  }

  Future<void> _addMedicine(Medicine medicine,
      {bool mergeWithLast = true}) async {
    // نفس المادة مباشرة بعد بعضها (آخر سطر هو نفسها) → زيادة الكمية بدل سطر
    // جديد. أما إن دخلت مادة أخرى بينهما فتُضاف كسطر مستقل (خصم مستقل مثلاً).
    if (mergeWithLast &&
        _lines.isNotEmpty &&
        _lines.last.medicine.id == medicine.id) {
      setState(() => _lines.last.quantity += 1);
      _selectLine(_lines.last);
      return;
    }
    if (medicine.units.isEmpty) {
      AppSnackbar.error(context, AppStrings.noPricedUnitForProduct);
      return;
    }
    var med = medicine;
    // اختيار الوحدة الافتراضية تلقائياً (وإلا الأولى).
    var unit = med.units.firstWhere((u) => u.isDefault,
        orElse: () => med.units.first);
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];

    // سعر البيع صفر → نافذة مدمجة لتحديد السعر باسم العملة الصريح. النافذة تبقى في
    // حالة تحميل حتى يُحفظ السعر على السيرفر ومحلياً (updatePrices + refreshOne)
    // ثم تُغلق؛ بعدها نقرأ النسخة المحدّثة من الكاش.
    if (unit.salePrice <= 0) {
      final currencyName = () {
        final n = base?.name ?? '';
        if (n.isNotEmpty) return n;
        final c = base?.code ?? '';
        return c.isNotEmpty ? c : 'العملة الأساسية';
      }();
      final unitId = unit.unitId;
      final saved = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SetPriceDialog(
          medicineName: med.displayName,
          currencyName: currencyName,
          onSubmit: (price) async {
            final res = await ref
                .read(medicineRepositoryProvider)
                .updatePrices(med.id, {unitId: price});
            var ok = false;
            res.fold((_) => ok = true, (_) {});
            if (!ok) return false;
            // حدّث هذا الدواء وحده (سيرفر → كاش → ذاكرة) بدل جلب كل الأدوية.
            await ref.read(medicineCatalogProvider.notifier).refreshOne(med.id);
            return true;
          },
        ),
      );
      if (!mounted || saved != true) return;
      final list = ref.read(medicineCatalogProvider).asData?.value ?? const <Medicine>[];
      med = list.firstWhere((m) => m.id == med.id, orElse: () => med);
      unit = med.units.firstWhere((u) => u.unitId == unitId,
          orElse: () => med.units.isNotEmpty ? med.units.first : unit);
    }

    // A5/F1: convert the base-currency price into the selected sale currency.
    final price = convertFromBase(unit.salePrice, base, _selectedCurrency(base, currencies));
    final existing = _lines
        .where((l) => l.medicine.id == med.id && l.unit.unitId == unit.unitId)
        .firstOrNull;
    if (existing != null) {
      setState(() => existing.quantity += 1);
      _selectLine(existing);
      return;
    }
    final line = _PosLine(medicine: med, unit: unit, unitPrice: price);
    setState(() => _lines.add(line));
    // السطر المضاف يصير المحدَّد فوراً — فاختصار تعديل الكمية يعمل عليه مباشرة.
    _selectLine(line);
    _loadBatches(line); // fetch expiry batches; default to nearest
  }

  /// Loads available batches for a line and defaults to the nearest expiry.
  Future<void> _loadBatches(_PosLine line) async {
    final warehouseId = ref.read(defaultWarehouseIdProvider).value;
    if (warehouseId == null || warehouseId.isEmpty) return;
    try {
      final batches = await ref
          .read(batchRepositoryProvider)
          .forMedicine(line.medicine.id, warehouseId);
      if (!mounted) return;
      setState(() {
        line.batches = batches;
        line.selectedBatch = batches.isNotEmpty ? batches.first : null;
      });
    } catch (_) {
      // Batch selection is optional; ignore load failures (FEFO applies).
    }
  }

  /// Handles a scanned code: look up the medicine and add it to the cart,
  /// or offer to add it if not found.
  Future<void> _handleCode(List<Medicine> catalog, String code) async {
    if (!mounted) return;
    await handleScannedBarcode(
      context: context,
      ref: ref,
      catalog: catalog,
      code: code,
      onFound: _addMedicine,
    );
  }

  Future<void> _submit(String? warehouseId, Currency? base) async {
    if (_submitting) return;
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
      AppSnackbar.error(context, AppStrings.saleEmptyHint);
      return;
    }
    // الوصفة الطبية تتطلب عميلاً إجبارياً.
    if (_isPrescription && (_customerId == null || _customerId!.isEmpty)) {
      AppSnackbar.error(context, AppStrings.prescriptionNeedsCustomer);
      return;
    }
    // البيع الآجل يتطلب عميلاً إجبارياً (يُنشئ حركة ذمّة بدل قبض فوري بالخادم).
    if (_payMethod.requiresParty && (_customerId == null || _customerId!.isEmpty)) {
      AppSnackbar.error(context, AppStrings.creditSaleNeedsCustomer);
      return;
    }

    // Everything is stored in the BASE currency; convert the prices the user
    // entered in the selected currency back to base, and record the base id.
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected = _selectedCurrency(base, currencies);
    double toBase(double v) => convertToBase(v, base, selected);

    // تحذير/منع البيع في السالب حسب الإعداد العام (معلومات الدفعات المحمّلة فقط).
    final negativeMeds = _negativeStockMedicines();
    if (negativeMeds.isNotEmpty) {
      final allowNegative = await ref.read(allowNegativeSaleProvider.future);
      if (!mounted) return;
      if (!allowNegative) {
        // بدل رفض البيع فقط: اعرض نافذة سريعة لإضافة مخزون (فاتورة شراء) للدواء الناقص.
        final short = _shortLines();
        if (short.isNotEmpty) {
          await _promptAddStock(short.first, warehouseId, base);
        } else {
          AppSnackbar.error(context,
              '${AppStrings.insufficientStockBody} ${negativeMeds.join('، ')}');
        }
        return;
      }
      final ok = await showConfirmationDialog(
        context,
        title: AppStrings.negativeStockTitle,
        message: '${AppStrings.negativeStockBody}\n${negativeMeds.join('، ')}',
        confirmLabel: AppStrings.continueLabel,
      );
      if (!ok || !mounted) return;
    }

    // تحذير الربح السالب: سعر البيع (بالأساس) أقل من كلفة **وحدة السطر**.
    //
    // تُذكَر الأرقام في الرسالة لا الأسماء وحدها: الكلفة هي **متوسّط كل
    // المشتريات** لهذا الدواء لكل وحدة أساسية، لا كلفة الدفعة المعروضة في
    // الشاشة — فشراءٌ قديم غالٍ يرفع المتوسّط فوق سعر اليوم. ورؤية الرقمين
    // تجعل التنويه قابلاً للمراجعة بدل أن يبدو خطأً.
    final belowCost = _lines
        .where((l) =>
            l.medicine.purchaseCost > 0 &&
            toBase(l.unitPrice) < _unitCostInBase(l) - 0.005)
        .map((l) => '${l.medicine.displayName} '
            '(${Formatters.number(toBase(l.unitPrice))} < '
            '${Formatters.number(_unitCostInBase(l))})')
        .toList();
    if (belowCost.isNotEmpty) {
      final ok = await showConfirmationDialog(
        context,
        title: AppStrings.negativeProfitTitle,
        message: '${AppStrings.negativeProfitBody}\n${belowCost.join('، ')}',
        confirmLabel: AppStrings.continueLabel,
      );
      if (!ok || !mounted) return;
    }

    setState(() => _submitting = true);
    FocusScope.of(context).unfocus();
    // Record the original transaction currency + its rate snapshot (for audit)
    // when it differs from the base; amounts are stored in the base currency.
    final isForeign = selected != null && base != null && selected.id != base.id;
    // لا نرسل بالعملة الأصلية إلا إلى خادم يفهمها: خادم أقدم يتجاهل العلم
    // فيأخذ 100 دولار على أنها 100 ليرة.
    final serverConverts =
        isForeign && ref.read(serverCapabilitiesProvider).value
                ?.amountsInOriginalCurrency == true;
    final input = CreateSaleInput(
      currencyId: base?.id ?? currencyId,
      customerId: (_customerId != null && _customerId!.isNotEmpty) ? _customerId : null,
      originalCurrencyId: isForeign ? selected.id : null,
      // السعر يُشتقّ على الخادم ويُتجاهَل ما يُرسَل هنا — نُبقيه للتوافق مع
      // الخوادم الأقدم فقط.
      exchangeRate: (isForeign && base.exchangeRate > 0)
          ? selected.exchangeRate / base.exchangeRate
          : 1,
      // المبالغ تُرسَل بعملة الفاتورة كما كتبها المستخدم؛ الخادم يحوّلها
      // بسعره، فلا يختلف الرقم المُرحَّل باختلاف الجهاز الذي أصدر الفاتورة.
      amountsInOriginalCurrency: serverConverts,
      warehouseId: warehouseId,
      saleDate: _saleDate,
      totalAmount: serverConverts ? _total : toBase(_total),
      paymentMethod: _payMethod,
      paymentAccountId: _payMethod == PaymentMethod.credit ? null : _paymentAccountId,
      isPrescription: _isPrescription,
      lines: [
        for (final l in _lines)
          CreateSaleLineInput(
            medicineId: l.medicine.id,
            unitId: l.unit.unitId,
            individual: serverConverts ? l.unitPrice : toBase(l.unitPrice),
            quantity: l.quantity,
            stockId: l.selectedBatch?.stockId,
          ),
      ],
    );
    final repo = ref.read(saleRepositoryProvider);
    // Editing a still-queued (un-synced) invoice: update the outbox entry and
    // reconcile the local stock cache — never hits the network.
    if (_isQueuedEdit) {
      final r = await repo.updateQueuedSale(widget.queuedId!, input);
      if (!mounted) return;
      setState(() => _submitting = false);
      r.fold(
        (_) {
          AppSnackbar.success(context, AppStrings.saleSavedSuccess);
          Navigator.of(context).pop();
        },
        (failure) => showFailureSnackbar(context, failure),
      );
      return;
    }
    // Edit updates in place (keeps the invoice number); the backend reverses the
    // old stock/items and re-applies, recapturing cost.
    final result = _isEdit
        ? await repo.updateSale(widget.saleToEdit!.id, input)
        : await repo.createSale(input);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (_) {
        AppSnackbar.success(context, AppStrings.saleSavedSuccess);
        ref.invalidate(salesListProvider);
        ref.invalidate(dashboardProvider);
        if (_isEdit) {
          Navigator.of(context).pop();
          return;
        }
        setState(() {
          _lines.clear();
          _saleDate = DateTime.now();
          _payMethod = PaymentMethod.cash;
          _customerId = null;
          _isPrescription = false;
        });
      },
      (failure) {
        if (!mounted) return;
        // رفض السيرفر بسبب نقص المخزون (لم تُحمّل الدفعات محلياً فيمرّ الفحص المحلي)
        // → افتح نافذة إضافة المخزون للدواء المذكور، كما في الفحص المسبق.
        final msg = failure.displayMessage;
        if (msg.contains('المخزون غير كاف')) {
          final line = _lineFromStockMessage(msg);
          if (line != null) {
            _promptAddStock(line, warehouseId, base);
            return;
          }
        }
        showFailureSnackbar(context, failure);
      },
    );
  }

  /// Picks the cart line the server's insufficient-stock message refers to. The
  /// backend message ends with the medicine name (`…للدواء <name>`); match it to
  /// a line, else fall back to the only line (or null to just show the error).
  _PosLine? _lineFromStockMessage(String msg) {
    const marker = 'للدواء ';
    final idx = msg.indexOf(marker);
    if (idx >= 0) {
      final name = msg.substring(idx + marker.length).trim();
      final match =
          _lines.where((l) => l.medicine.displayName.trim() == name).firstOrNull;
      if (match != null) return match;
    }
    return _lines.length == 1 ? _lines.first : null;
  }

  /// Medicine display-names whose requested quantity exceeds the known available
  /// stock (summed from loaded batches). Lines whose batches are not loaded (e.g.
  /// while editing) are skipped — the backend remains the authority.
  List<String> _negativeStockMedicines() {
    final required = <String, double>{};
    final names = <String, String>{};
    for (final l in _lines) {
      required[l.medicine.id] = (required[l.medicine.id] ?? 0) + l.quantity;
      names[l.medicine.id] = l.medicine.displayName;
    }
    final result = <String>[];
    for (final entry in required.entries) {
      double? available;
      for (final l in _lines) {
        if (l.medicine.id == entry.key && l.batches.isNotEmpty) {
          available =
              l.batches.fold<double>(0, (s, b) => s + b.quantityAvailable);
          break;
        }
      }
      if (available != null && entry.value > available) {
        result.add(names[entry.key]!);
      }
    }
    return result;
  }

  /// The first POS line per medicine whose loaded batches can't cover the cart —
  /// used to offer a quick stock top-up.
  List<_PosLine> _shortLines() {
    final required = <String, double>{};
    for (final l in _lines) {
      required[l.medicine.id] = (required[l.medicine.id] ?? 0) + l.quantity;
    }
    final short = <_PosLine>[];
    final seen = <String>{};
    for (final entry in required.entries) {
      double? available;
      _PosLine? first;
      for (final l in _lines) {
        if (l.medicine.id == entry.key && l.batches.isNotEmpty) {
          available = l.batches.fold<double>(0, (s, b) => s + b.quantityAvailable);
          first = l;
          break;
        }
      }
      if (available != null &&
          entry.value > available &&
          first != null &&
          seen.add(entry.key)) {
        short.add(first);
      }
    }
    return short;
  }

  /// Quick stock top-up: collect quantity + cost (= purchase price) + expiry in a
  /// popup, post a one-line PURCHASE invoice (feeds stock), then refresh this
  /// medicine's batches + cached cost — no full re-pull.
  Future<void> _promptAddStock(
      _PosLine line, String warehouseId, Currency? base) async {
    // المتوفّر حالياً في المستودع لهذا الدواء (مجموع الدفعات المحمّلة).
    final available =
        line.batches.fold<double>(0, (s, b) => s + b.quantityAvailable);
    final entry = await showDialog<_StockEntry>(
      context: context,
      builder: (_) => _AddStockDialog(
        medicineName: line.medicine.displayName,
        unitName: line.unit.unitName,
        available: available,
      ),
    );
    if (entry == null || !mounted) return;

    final input = CreatePurchaseInput(
      currencyId: base?.id ?? '',
      warehouseId: warehouseId,
      purchaseDate: DateTime.now(),
      totalAmount: entry.cost * entry.qty,
      paymentMethod: PaymentMethod.cash,
      note: 'إضافة مخزون سريعة من شاشة البيع',
      lines: [
        CreatePurchaseLineInput(
          medicineId: line.medicine.id,
          unitId: line.unit.unitId,
          unitPrice: entry.cost,
          quantity: entry.qty,
          expiryDate: entry.expiry,
        ),
      ],
    );

    final res = await ref.read(purchaseRepositoryProvider).create(input);
    if (!mounted) return;
    res.fold(
      (_) {
        // refresh the affected lines' batches + the medicine's cached cost
        for (final l in _lines.where((x) => x.medicine.id == line.medicine.id)) {
          _loadBatches(l);
        }
        ref.read(medicineCatalogProvider.notifier).refreshOne(line.medicine.id);
        AppSnackbar.success(
            context, 'تمت إضافة المخزون — أعد الضغط على «حفظ» لإتمام البيع');
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  /// Prefills the POS from an existing sale when editing (matches medicines from
  /// the catalog by id). Amounts are stored in base → edit in the base currency.
  void _prefillFromSale(Sale sale, List<Medicine> catalog) {
    _prefilled = true;
    _saleDate = sale.saleDate;
    _customerId = sale.customerId.isNotEmpty ? sale.customerId : null;
    _currencyId = null; // base
    _payMethod = sale.paymentMethod;
    _paymentAccountId =
        sale.paymentAccountId.isNotEmpty ? sale.paymentAccountId : null;
    _lastSuggestedPaymentAccountId = null;
    _isPrescription = sale.isPrescription;
    _lines.clear();
    for (final line in sale.items) {
      final med = catalog.where((m) => m.id == line.medicineId).firstOrNull;
      if (med == null || med.units.isEmpty) continue;
      final unit =
          med.units.where((u) => u.unitId == line.unitId).firstOrNull ??
              med.units.first;
      _lines.add(_PosLine(medicine: med, unit: unit, unitPrice: line.individual)
        ..quantity = line.quantity);
    }
  }

  /// Prefills the POS from a still-queued offline invoice's request body.
  void _prefillFromPayload(Map<String, dynamic> payload, List<Medicine> catalog) {
    _prefilled = true;
    _saleDate =
        DateTime.tryParse('${payload['saleDate'] ?? ''}') ?? DateTime.now();
    final cust = payload['customerId'] as String?;
    _customerId = (cust != null && cust.isNotEmpty) ? cust : null;
    _currencyId = null; // amounts are stored in base
    _payMethod = PaymentMethod.fromWire((payload['paymentMethod'] as num?)?.toInt());
    final payAccId = payload['paymentAccountId'] as String?;
    _paymentAccountId = (payAccId != null && payAccId.isNotEmpty) ? payAccId : null;
    _lastSuggestedPaymentAccountId = null;
    _isPrescription = payload['isPrescription'] == true;
    _lines.clear();
    for (final raw in (payload['items'] as List?) ?? const []) {
      if (raw is! Map) continue;
      final medId = (raw['medicineId'] ?? '').toString();
      final med = catalog.where((m) => m.id == medId).firstOrNull;
      if (med == null || med.units.isEmpty) continue;
      final unitId = (raw['unitId'] ?? '').toString();
      final unit =
          med.units.where((u) => u.unitId == unitId).firstOrNull ?? med.units.first;
      final line = _PosLine(
        medicine: med,
        unit: unit,
        unitPrice: ((raw['individual'] ?? 0) as num).toDouble(),
      )..quantity = ((raw['quantity'] ?? 1) as num).toDouble();
      final stockId = (raw['stockId'] ?? '').toString();
      if (stockId.isNotEmpty) {
        // Preserve the pinned batch so the edit re-emits the same stockId.
        line.selectedBatch = MedicineBatch(
          stockId: stockId,
          quantityAvailable: line.quantity,
        );
        line.batches = [line.selectedBatch!];
      }
      _lines.add(line);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(medicineCatalogProvider);
    final currenciesAsync = ref.watch(currenciesProvider);
    final warehouseAsync = ref.watch(defaultWarehouseIdProvider);
    final base = ref.watch(baseCurrencyProvider);

    final isMainPos = !_isEdit && !_isQueuedEdit;
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;

    // يبلّغ حاوية التابات (إن وُجدت) إن كانت هذه الفاتورة تحمل أسطراً غير
    // محفوظة — بعد انتهاء هذا البناء، حتى لا يُستدعى setState في الأب أثناءه.
    final onDirty = widget.onDirtyChanged;
    if (onDirty != null) {
      final hasLines = _lines.isNotEmpty;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) onDirty(hasLines);
      });
    }

    final body = catalogAsync.when(
      loading: () => const LoadingState(message: AppStrings.loading),
      error: (e, _) => ErrorState.fromError(
        e,
        onRetry: () => ref.invalidate(medicineCatalogProvider),
      ),
      data: (catalog) {
        final currencies = currenciesAsync.value ?? const <Currency>[];
        final warehouseId = warehouseAsync.value;
        if (_isEdit && !_prefilled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _prefilled) return;
              setState(() => _prefillFromSale(widget.saleToEdit!, catalog));
            });
          } else if (_isQueuedEdit && !_prefilled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _prefilled) return;
              setState(() => _prefillFromPayload(widget.queuedPayload!, catalog));
            });
          }
          return _buildPos(catalog, currencies, warehouseId, base);
        },
      );

    if (!widget.standalone) return body;

    return Scaffold(
      // عنوان الشاشة يظهر فقط عند تعديل فاتورة قائمة (سياق يحتاج توضيحاً)؛
      // فاتورة البيع الجديدة بلا عنوان — الشريط العلوي يُعرِّف نفسه بحقوله.
      // الإشعارات انتقلت لشريط العنوان العلوي، وتبديل الأوفلاين للقائمة
      // الجانبية، فلم يبقَ هنا إلا الفواتير غير المرحّلة عند وجودها.
      appBar: AppBar(
        title: Text(_isEdit || _isQueuedEdit ? AppStrings.editSale : ''),
        actions: [
          if (isMainPos && pending > 0)
            // The "cloud" of un-synced invoices — shown ONLY when some exist.
            IconButton(
              tooltip: AppStrings.pendingInvoices,
              icon: Badge(
                label: Text('$pending'),
                child: const Icon(Icons.cloud_queue),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const PendingInvoicesPage()),
              ),
            ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildPos(
    List<Medicine> catalog,
    List<Currency> currencies,
    String? warehouseId,
    Currency? base,
  ) {
    final theme = Theme.of(context);
    final currencyCode = currencies
            .where((c) => c.id == _effectiveCurrencyId(base))
            .map((c) => c.code)
            .firstOrNull ??
        '';
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    _suggestPaymentAccountForCurrency(_effectiveCurrencyId(base), accounts, base?.id);

    // اختصارات الفاتورة تُستدعى من خارج دورة البناء، فتحتاج آخر قيم معروفة.
    _lastCatalog = catalog;
    _lastWarehouseId = warehouseId;
    _lastBase = base;

    return BarcodeScannerListener(
      onScan: (code) {
        FocusManager.instance.primaryFocus?.unfocus();
        _handleCode(catalog, code);
      },
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          child: Column(
            children: [
              if (warehouseId == null || warehouseId.isEmpty) ...[
                InfoCard(
                  icon: Icons.warehouse_outlined,
                  color: theme.colorScheme.error,
                  message: AppStrings.warehouseNotSet,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              // شريط أدوات مدمج بدل القوائم الكبيرة: التاريخ، العملة، العميل،
              // وصفة طبية، وطريقة الدفع — إضافة الدواء صارت من خلية الجدول
              // نفسها. الإجمالي ظاهر دوماً في نهاية هذا الشريط (لا في الأسفل
              // فقط) حتى يبقى مرئياً حتى مع طول الجدول.
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _dateField(),
                        SizedBox(
                          width: 170,
                          child: CurrencyPickerField(
                            compact: true,
                            label: AppStrings.currencyLabel,
                            // عملات قابلة للاختيار فقط: الأساسية + أي عملة سعر
                            // صرفها موجب (عملة بلا سعر صرف تُخفى لأن التحويل
                            // لا يعمل معها).
                            currencies: currencies
                                .where((c) => c.isBaseCurrency || c.exchangeRate > 0)
                                .toList(),
                            selectedId: _effectiveCurrencyId(base).isEmpty
                                ? null
                                : _effectiveCurrencyId(base),
                            onSelected: (c) => setState(() {
                              _currencyId = c.id;
                              _repriceLines(base, currencies);
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: CustomerPickerField(
                            compact: true,
                            label: AppStrings.customer,
                            hint: AppStrings.noCustomer,
                            customers: ref.watch(customersProvider).value ??
                                const <Customer>[],
                            selectedId: _customerId,
                            allowClear: true,
                            onCleared: () => setState(() => _customerId = null),
                            onSelected: (c) => setState(() => _customerId = c.id),
                          ),
                        ),
                        _paymentMethodField(),
                        if (_payMethod != PaymentMethod.credit)
                          SizedBox(
                            width: 220,
                            child: AccountPickerField(
                              compact: true,
                              label: AppStrings.accountLabel,
                              accounts: accounts,
                              selectedId: _paymentAccountId,
                              onSelected: (a) =>
                                  setState(() => _paymentAccountId = a.id),
                            ),
                          ),
                        // وصفة طبية؟ عند التفعيل يصبح اختيار العميل إجبارياً.
                        _prescriptionToggle(theme),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  InvoiceTotalBadge(
                    total: _total,
                    selected: _selectedCurrency(base, currencies),
                    base: base,
                  ),
                ],
              ),
            ],
          ),
        ),
        // فاصل حقيقي بين الشريط العلوي وبنود الفاتورة — خطّ بلون الحدود
        // المحايد نفسه لا لون الـ divider الباهت، فيُقرأ الشريطان كمنطقتين.
        Container(height: 1, color: toolbarFieldBorderColor(context)),
        // الجدول دائم الظهور ويملأ المساحة كاملة: آخر صف فيه هو "صف جديد"
        // تُختار المادة من خليته.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
            child: _linesGrid(catalog),
          ),
        ),
        _summaryBar(currencyCode, warehouseId, base, theme),
      ],
      ),
    );
  }

  /// اختيار المادة من خلية الجدول مباشرة (أسلوب وكيد).
  /// [line] == null → إضافة سطر جديد.
  ///
  /// [mergeIfSame] يفرّق بين مدخلين:
  ///
  /// * **زرّ/اختصار «إضافة مادة»** (`true`): اختيار المادة نفسها مرّتين يزيد
  ///   كمية آخر سطر — سلوك نقطة البيع المعتاد للتكرار السريع.
  /// * **خليّة الصفّ الجاهز** (`false`): تُضاف **سطراً مستقلاً** دائماً وإن
  ///   كانت نفس المادة، لأن المستخدم قصد سطراً ثانياً لها — وقد يختلف سعره
  ///   أو كلفته أو دفعته عن الأول، ودمجُه يُفقد ذلك بلا رجعة.
  /// وغير ذلك: تُستبدل مادة الصف الموجود بسطر جديد في موضعه (بنقل الكمية).
  Future<void> _pickMedicineForLine(
      List<Medicine> catalog, _PosLine? line,
      {bool mergeIfSame = false}) async {
    final picked = await showMedicinePicker(context, catalog);
    if (picked == null || !mounted) return;
    if (line == null) {
      await _addMedicine(picked, mergeWithLast: mergeIfSame);
      return;
    }
    // استبدال مادة صف موجود: دائماً سطر جديد في نفس الموضع، بلا دمج.
    final index = _lines.indexOf(line);
    if (index < 0) return;
    final before = _lines.length;
    await _addMedicine(picked, mergeWithLast: false);
    if (!mounted) return;
    // _addMedicine يضيف في النهاية عند النجاح — ننقل السطر الجديد إلى موضعه.
    if (_lines.length > before) {
      setState(() {
        final fresh = _lines.removeLast()..quantity = line.quantity;
        _lines[index] = fresh;
        _selectLine(fresh);
      });
    }
  }

  // ─── جدول الفاتورة: غريد Trina حقيقي (خلايا كخلايا التقارير) ──────────────

  static const _fId = 'id';
  static const _fMed = 'med';
  static const _fUnit = 'unit';
  static const _fPrice = 'price';
  static const _fQty = 'qty';
  static const _fBatch = 'batch';
  static const _fTotal = 'total';
  static const _fDel = 'del';
  static const _newRowId = '__new__';

  String _lineId(_PosLine l) => identityHashCode(l).toString();

  /// بصمة بنيوية للأسطر: أي تغيير (إضافة/حذف/وحدة/سعر/كمية/دفعة/عملة) يعيد
  /// بناء الشبكة بقيم محدثة. التحرير داخل الخلية يلتزم عند الخروج منها ثم
  /// يُعاد البناء — آمن لأن قوائم نقطة البيع قصيرة.
  Key _gridKey(Currency? base) => ValueKey(Object.hashAll([
        _effectiveCurrencyId(base),
        for (final l in _lines) ...[
          identityHashCode(l),
          l.unit.unitId,
          l.unitPrice,
          l.quantity,
          l.selectedBatch?.stockId,
          l.batches.length,
        ],
      ]));

  Widget _linesGrid(List<Medicine> catalog) {
    final theme = Theme.of(context);
    final warning = context.semantic.warning;
    final base = ref.watch(baseCurrencyProvider);
    final byId = {for (final l in _lines) _lineId(l): l};

    bool isNewRow(TrinaRow<dynamic> row) =>
        row.cells[_fId]?.value == _newRowId;
    _PosLine? lineOf(TrinaRow<dynamic> row) => byId[row.cells[_fId]?.value];

    return AppGrid(
      key: _gridKey(base),
      columns: [
        // الدواء: اسم + قلم للتبديل؛ وفي صف الإضافة زر «اختر مادة…».
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
                  Icon(Icons.edit_outlined,
                      size: 13, color: theme.hintColor),
                ],
              ),
            );
          },
        ),
        // الوحدة: قائمة داخل الخلية (خيارات لكل صف على حدة).
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
              onSelected: (v) => _changeUnit(l, v),
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
                  Icon(Icons.arrow_drop_down,
                      size: 16, color: theme.hintColor),
                ],
              ),
            );
          },
        ),
        // السعر والكمية: خلايا أرقام تُحرَّر في مكانها (كخلايا التقارير).
        TrinaColumn(
          title: AppStrings.price,
          field: _fPrice,
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
        // دفعة الصلاحية: قائمة داخل الخلية.
        TrinaColumn(
          title: AppStrings.expiryDateLabel,
          field: _fBatch,
          type: TrinaColumnType.text(),
          width: 170,
          enableEditingMode: false,
          renderer: (ctx) {
            final l = lineOf(ctx.row);
            if (l == null) return const SizedBox.shrink();
            if (l.batches.isEmpty) {
              return Text('—',
                  style: TextStyle(color: theme.hintColor));
            }
            return PopupMenuButton<String>(
              tooltip: AppStrings.expiryDateLabel,
              onSelected: (v) => setState(() => l.selectedBatch =
                  l.batches.where((b) => b.stockId == v).firstOrNull),
              itemBuilder: (_) => [
                for (final b in l.batches)
                  PopupMenuItem(
                    value: b.stockId,
                    child: Text(
                        '${b.expiryLabel} (${Formatters.qty(b.quantityAvailable)})'),
                  ),
              ],
              child: Row(
                children: [
                  Expanded(
                    child: Text(ctx.cell.value?.toString() ?? '',
                        overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.arrow_drop_down,
                      size: 16, color: theme.hintColor),
                ],
              ),
            );
          },
        ),
        appGridNumberColumn(AppStrings.total, _fTotal, width: 120,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          if (isNewRow(ctx.row)) return const SizedBox.shrink();
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
              onPressed: () => _removeWithUndo(l),
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
            _fUnit: TrinaCell(value: l.unit.unitName),
            _fPrice: TrinaCell(value: l.unitPrice),
            _fQty: TrinaCell(value: l.quantity),
            _fBatch: TrinaCell(
                value: l.selectedBatch != null
                    ? '${l.selectedBatch!.expiryLabel} (${Formatters.qty(l.selectedBatch!.quantityAvailable)})'
                    : ''),
            _fTotal: TrinaCell(value: l.total),
            _fDel: TrinaCell(value: ''),
          }),
        // صف الإضافة الدائم.
        TrinaRow(cells: {
          _fId: TrinaCell(value: _newRowId),
          _fMed: TrinaCell(value: ''),
          _fUnit: TrinaCell(value: ''),
          _fPrice: TrinaCell(value: ''),
          _fQty: TrinaCell(value: ''),
          _fBatch: TrinaCell(value: ''),
          _fTotal: TrinaCell(value: ''),
          _fDel: TrinaCell(value: ''),
        }),
      ],
      showColumnFilter: false,
      // يُحتفَظ بالمدير لاختصارَي «حذف السطر» و«تعديل الكمية» (يحتاجان الصف
      // المحدَّد حالياً).
      onLoaded: _attachGrid,
      onChanged: (e) {
        final l = lineOf(e.row);
        if (l == null) return;
        final v = e.value is num
            ? (e.value as num).toDouble()
            : double.tryParse(e.value?.toString() ?? '');
        setState(() {
          if (e.column.field == _fPrice && v != null && v >= 0) {
            l.unitPrice = v;
          } else if (e.column.field == _fQty && v != null && v > 0) {
            l.quantity = v;
          }
          // قيمة غير صالحة → البصمة تعيد البناء بالقيمة القديمة.
        });
      },
      // بيع بخسارة → تظليل تحذيري لكامل السطر.
      rowColorCallback: (ctx) {
        final l = lineOf(ctx.row);
        if (l != null && _isNegativeProfit(l)) {
          return warning.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      },
    );
  }

  /// Switching the unit re-prices the line from that unit's base salePrice
  /// into the selected currency (same behavior as the old editor sheet).
  void _changeUnit(_PosLine line, String? unitId) {
    final u = line.medicine.units.where((x) => x.unitId == unitId).firstOrNull;
    if (u == null) return;
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    setState(() {
      line.unit = u;
      line.unitPrice =
          convertFromBase(u.salePrice, base, _selectedCurrency(base, currencies));
    });
  }

  /// طريقة الدفع — نفس غلاف حقول الشريط [AppToolbarField]، والنقر يفتح قائمة
  /// الطرق. التفاعل من [PopupMenuButton] الخارجي فلا يأخذ الحقل نقرة خاصة به.
  Widget _paymentMethodField() {
    return PopupMenuButton<PaymentMethod>(
      tooltip: AppStrings.paymentMethod,
      onSelected: (m) => setState(() => _payMethod = m),
      itemBuilder: (_) => [
        for (final m in PaymentMethod.values)
          PopupMenuItem(value: m, child: Text(m.label)),
      ],
      child: AppToolbarField(
        width: 150,
        icon: Icons.account_balance_wallet_outlined,
        label: AppStrings.paymentMethod,
        value: _payMethod.label,
        trailing: toolbarTrailingIcon(context, Icons.arrow_drop_down),
      ),
    );
  }

  /// تاريخ الفاتورة — نفس غلاف حقول الشريط، يفتح منتقي تاريخ عند الضغط.
  /// الافتراضي تاريخ اليوم (قيمة [_saleDate] الابتدائية).
  Widget _dateField() {
    return AppToolbarField(
      width: 140,
      icon: Icons.calendar_today_outlined,
      label: AppStrings.dateLabel,
      value: AppDate.ymd(_saleDate),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _saleDate,
          firstDate: DateTime(_saleDate.year - 5),
          lastDate: DateTime(_saleDate.year + 5),
        );
        if (picked != null) setState(() => _saleDate = picked);
      },
    );
  }

  /// مفتاح «وصفة طبية» — زرّ حالة لا حقل، لكنه مبنيّ يدوياً بنفس مقاسات حقول
  /// الشريط (الارتفاع والزاوية والحدّ ولون النص) لأن `FilterChip` يفرض زاوية
  /// ثيم الشرائح وحشوتها فيخرج أكثر استدارة من جيرانه على السطر نفسه.
  Widget _prescriptionToggle(ThemeData theme) {
    return _PrescriptionToggle(
      selected: _isPrescription,
      onChanged: (v) => setState(() => _isPrescription = v),
    );
  }

  Widget _summaryBar(
    String code,
    String? warehouseId,
    Currency? base,
    ThemeData theme,
  ) {
    // شريط حفظ بأسلوب سطح المكتب: زر حفظ مدمج بحجم محتواه في نهاية السطر (لا
    // زر ممتد بعرض الشاشة كالموبايل). الإجمالي صار ظاهراً بشريط الأدوات
    // أعلى الجدول بدل هنا.
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: context.semantic.border)),
      ),
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: 180,
            child: AppButton.primary(
              label: _submitting ? AppStrings.saving : AppStrings.save,
              icon: Icons.save_outlined,
              isLoading: _submitting,
              backgroundColor: context.semantic.success,
              onPressed: () => _submit(warehouseId, base),
            ),
          ),
        ],
      ),
    );
  }
}

/// حاوية تابات فواتير المبيعات — تسمح بفتح أكثر من فاتورة بالتزامن (كتابات
/// المتصفح): كل تاب [_SingleSaleScaffold] مستقل بالكامل (أسطره/عملته/عميله)
/// ومُبقى حيّاً داخل [IndexedStack] عند التبديل بينها فلا تُفقد حالته. شريط
/// التابات + الـ AppBar (الإشعارات، حالة الاتصال، الفواتير المعلّقة) من هنا
/// فقط — التابات نفسها تعرض محتواها بلا Scaffold مكرَّر.
class _SalesTabsHost extends ConsumerStatefulWidget {
  const _SalesTabsHost();

  @override
  ConsumerState<_SalesTabsHost> createState() => _SalesTabsHostState();
}

class _SalesTabsHostState extends ConsumerState<_SalesTabsHost> {
  final List<int> _tabIds = [1];
  int _nextId = 2;
  int _activeIndex = 0;
  final Map<int, bool> _dirty = {};

  /// «فاتورة جديدة» تخصّ الحاوية لا تاباً بعينه، فتُسجَّل هنا.
  late final ShortcutRegistration _shortcuts = ShortcutRegistration(ref, this);

  @override
  void initState() {
    super.initState();
    _shortcuts.bind({ShortcutAction.invoiceNewTab: _addTab});
  }

  @override
  void dispose() {
    _shortcuts.dispose();
    super.dispose();
  }

  void _addTab() {
    setState(() {
      _dirty[_nextId] = false;
      _tabIds.add(_nextId);
      _nextId++;
      _activeIndex = _tabIds.length - 1;
    });
  }

  /// إغلاق تاب — بتأكيد أولاً إن كانت فاتورته تحمل أسطراً غير محفوظة. آخر تاب
  /// متبقٍ لا يُغلَق (يبقى دوماً تاب واحد على الأقل مفتوحاً).
  Future<void> _closeTab(int index) async {
    if (_tabIds.length <= 1) return;
    final id = _tabIds[index];
    if (_dirty[id] == true) {
      final ok = await showConfirmationDialog(
        context,
        title: 'إغلاق الفاتورة؟',
        message: 'هذه الفاتورة تحتوي أسطراً غير محفوظة، وستُفقد عند الإغلاق.',
        confirmLabel: 'إغلاق',
      );
      if (!ok || !mounted) return;
    }
    setState(() {
      _tabIds.removeAt(index);
      _dirty.remove(id);
      if (_activeIndex >= _tabIds.length) {
        _activeIndex = _tabIds.length - 1;
      } else if (_activeIndex > index) {
        _activeIndex--;
      }
    });
  }

  void _setDirty(int id, bool value) {
    if (_dirty[id] == value) return;
    setState(() => _dirty[id] = value);
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;

    return Scaffold(
      // بلا عنوان «فاتورة بيع» وبلا أيقونات: شريط التطبيق مطويّ الارتفاع
      // (toolbarHeight: 0) فلا يبقى شريط أبيض فارغ فوق التابات — التابات هي
      // أعلى الشاشة مباشرة. زر الفواتير غير المرحّلة انتقل داخل شريط التابات.
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: _tabStrip(context, pending),
        ),
      ),
      body: IndexedStack(
        index: _activeIndex,
        children: [
          for (final id in _tabIds)
            _SingleSaleScaffold(
              key: ValueKey(id),
              standalone: false,
              active: _tabIds[_activeIndex] == id,
              onDirtyChanged: (v) => _setDirty(id, v),
            ),
        ],
      ),
    );
  }

  /// شريط التابات بأسلوب سطح المكتب: تابات قابلة للسحب أفقياً + زر «+» لفاتورة
  /// جديدة في نهاية الشريط.
  Widget _tabStrip(BuildContext context, int pending) {
    final theme = Theme.of(context);
    return Container(
      height: 42,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < _tabIds.length; i++) _tabChip(theme, i),
              ],
            ),
          ),
          IconButton(
            tooltip: 'فاتورة جديدة',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 20),
            onPressed: _addTab,
          ),
          if (pending > 0)
            IconButton(
              tooltip: AppStrings.pendingInvoices,
              visualDensity: VisualDensity.compact,
              icon: Badge(
                label: Text('$pending'),
                child: const Icon(Icons.cloud_queue, size: 20),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const PendingInvoicesPage()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabChip(ThemeData theme, int index) {
    final id = _tabIds[index];
    final selected = index == _activeIndex;
    final dirty = _dirty[id] == true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: Material(
        color: selected
            ? theme.colorScheme.surface
            : Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: InkWell(
          onTap: () => setState(() => _activeIndex = index),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Container(
            constraints: const BoxConstraints(minWidth: 92, maxWidth: 180),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary.withValues(alpha: 0.35)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dirty) ...[
                  Icon(Icons.circle, size: 6, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    'فاتورة ${index + 1}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? theme.colorScheme.primary : null,
                    ),
                  ),
                ),
                if (_tabIds.length > 1) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _closeTab(index),
                    borderRadius: BorderRadius.circular(999),
                    child: Icon(Icons.close, size: 14, color: theme.hintColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A small numeric prompt dialog that owns its controller — returns the parsed
/// value on save, or null on cancel/dismiss (no mutation on cancel).
/// Compact "set sale price" popup for a zero-priced medicine. Shows the price
/// field with the currency named explicitly, and keeps a loading state visible
/// while the price is saved (server + local cache) — it only closes once done.
class _SetPriceDialog extends StatefulWidget {
  const _SetPriceDialog({
    required this.medicineName,
    required this.currencyName,
    required this.onSubmit,
  });

  final String medicineName;
  final String currencyName;

  /// Saves the price (server + local). Returns true on success (dialog closes),
  /// false to keep the dialog open so the user can retry.
  final Future<bool> Function(double price) onSubmit;

  @override
  State<_SetPriceDialog> createState() => _SetPriceDialogState();
}

class _SetPriceDialogState extends State<_SetPriceDialog> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final v = double.tryParse(_controller.text.trim()) ?? 0;
    if (v <= 0) {
      AppSnackbar.error(context, 'أدخل سعراً صحيحاً');
      return;
    }
    setState(() => _saving = true);
    final ok = await widget.onSubmit(v);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _saving = false);
      AppSnackbar.error(context, 'تعذّر حفظ السعر، حاول مجدداً');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.price_change_outlined,
                      color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('تحديد سعر المبيع',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      tooltip: AppStrings.close,
                      icon: const Icon(Icons.close),
                      onPressed: _saving ? null : () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(widget.medicineName,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.md),
              AppNumberField(
                controller: _controller,
                label: 'سعر المبيع (${widget.currencyName})',
                enabled: !_saving,
              ),
              if (_saving) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text('جارٍ حفظ السعر وتحديث الدواء…',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(false),
                      child: const Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(AppStrings.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Result of the quick add-stock popup.
class _StockEntry {
  const _StockEntry(this.qty, this.cost, this.expiry);
  final double qty;
  final double cost;
  final DateTime expiry;
}

/// Quick "add stock" popup shown when a sale is blocked by insufficient stock.
/// Collects quantity + cost (= purchase price) + expiry; the caller posts a
/// one-line purchase invoice that feeds stock.
class _AddStockDialog extends StatefulWidget {
  const _AddStockDialog({
    required this.medicineName,
    required this.unitName,
    this.available = 0,
  });

  final String medicineName;
  final String unitName;

  /// Quantity currently on hand in the pharmacy's warehouse for this medicine
  /// (summed from the loaded batches) — shown as a notice at the top.
  final double available;

  @override
  State<_AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<_AddStockDialog> {
  final _qty = TextEditingController(text: '1');
  final _cost = TextEditingController();
  DateTime? _expiry;

  @override
  void dispose() {
    _qty.dispose();
    _cost.dispose();
    super.dispose();
  }

  void _save() {
    final q = double.tryParse(_qty.text.trim()) ?? 0;
    final c = double.tryParse(_cost.text.trim()) ?? 0;
    if (q <= 0) {
      AppSnackbar.error(context, 'أدخل كمية صحيحة');
      return;
    }
    if (_expiry == null) {
      AppSnackbar.error(context, 'حدّد تاريخ الصلاحية');
      return;
    }
    Navigator.of(context).pop(_StockEntry(q, c, _expiry!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warehouse_outlined,
                      color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('إضافة مخزون',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      tooltip: AppStrings.close,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Scrollable so the fields + warning + date picker never overflow.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                ),
                child: SingleChildScrollView(
                  child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.medicineName,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.sm),
          // تنويه: لا توجد كمية كافية في المستودع + المتوفّر فعلياً في الصيدلية.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: AppRadius.brSm,
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 18, color: Colors.orange.shade800),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('لا توجد كمية كافية في المستودع لهذا الدواء',
                          style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900)),
                      Text(
                        'المتوفّر حالياً في صيدليتك: ${Formatters.qty(widget.available)} ${widget.unitName}',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppNumberField(controller: _qty, label: 'الكمية (${widget.unitName})'),
          const SizedBox(height: AppSpacing.sm),
          AppNumberField(controller: _cost, label: 'سعر الكلفة (سعر الشراء)'),
          const SizedBox(height: 4),
          Text('سعر الكلفة = سعر الشراء بالعملة الأساسية',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
          const SizedBox(height: AppSpacing.sm),
          AppDatePicker(
            label: 'تاريخ الصلاحية',
            value: _expiry,
            isRequired: true,
            firstDate: DateTime.now(),
            onChanged: (d) => setState(() => _expiry = d),
          ),
        ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 96,
                    height: 32,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      onPressed: _save,
                      child: const Text(AppStrings.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// مفتاح «وصفة طبية» بمقاسات [AppToolbarField] نفسها: الحالة المحدَّدة أخضر
/// هادئ (حدّ + تعبئة 8%)، والتمرير يُلمّح بالحدّ كبقية عناصر الشريط.
class _PrescriptionToggle extends StatefulWidget {
  const _PrescriptionToggle({required this.selected, required this.onChanged});

  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  State<_PrescriptionToggle> createState() => _PrescriptionToggleState();
}

class _PrescriptionToggleState extends State<_PrescriptionToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final selected = widget.selected;

    final borderColor = selected
        ? primary.withValues(alpha: 0.55)
        : _hovered
            ? primary.withValues(alpha: 0.45)
            : toolbarFieldBorderColor(context);
    final contentColor = selected
        ? primary
        : _hovered
            ? primary
            : context.semantic.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onChanged(!selected),
        child: Container(
          height: AppSizes.toolbarFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: toolbarFieldRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.description_outlined,
                  size: AppSizes.iconXs, color: contentColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppStrings.prescriptionLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.25,
                  color: selected ? primary : toolbarFieldTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
