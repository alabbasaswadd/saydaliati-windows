import 'package:flutter/material.dart';
import 'package:saydaliati/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/payment_method.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
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
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
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

/// Tab 3 — المبيعات (نقطة البيع). Reuses the debts app's clean POS layout:
/// an always-on embedded scanner on top, currency + payment selectors, a manual
/// medicine picker, readable receipt lines, and a summary bar with save.
class SalesPage extends ConsumerStatefulWidget {
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
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final List<_PosLine> _lines = [];
  String? _currencyId;
  String? _customerId;
  PaymentMethod _payMethod = PaymentMethod.cash;
  bool _isPrescription = false;
  bool _submitting = false;
  bool _prefilled = false;

  bool get _isEdit => widget.saleToEdit != null;
  bool get _isQueuedEdit => widget.queuedId != null;

  double get _total => _lines.fold(0, (s, l) => s + l.total);

  String _effectiveCurrencyId(Currency? base) => _currencyId ?? base?.id ?? '';

  Currency? _selectedCurrency(Currency? base, List<Currency> currencies) =>
      currencies.where((c) => c.id == _effectiveCurrencyId(base)).firstOrNull;

  /// True when this line's sale price (converted to base) is below the
  /// medicine's purchase cost — i.e. selling this line at a loss.
  bool _isNegativeProfit(_PosLine line) {
    if (line.medicine.purchaseCost <= 0) return false;
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected = _selectedCurrency(base, currencies);
    return convertToBase(line.unitPrice, base, selected) <
        line.medicine.purchaseCost;
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

  Widget _dismissBackground(ThemeData theme, Alignment alignment) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: alignment,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: AppRadius.brMd,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      );

  /// Re-prices every line from its base salePrice into the selected currency
  /// (called when the currency changes). Overwrites manual price edits.
  void _repriceLines(Currency? base, List<Currency> currencies) {
    final selected = _selectedCurrency(base, currencies);
    for (final l in _lines) {
      l.unitPrice = convertFromBase(l.unit.salePrice, base, selected);
    }
  }

  Future<void> _addMedicine(Medicine medicine) async {
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
      return;
    }
    final line = _PosLine(medicine: med, unit: unit, unitPrice: price);
    setState(() => _lines.add(line));
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
    if (_lines.isEmpty) {
      AppSnackbar.error(context, AppStrings.saleEmptyHint);
      return;
    }
    // الوصفة الطبية تتطلب عميلاً إجبارياً.
    if (_isPrescription && (_customerId == null || _customerId!.isEmpty)) {
      AppSnackbar.error(context, AppStrings.prescriptionNeedsCustomer);
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

    // تحذير الربح السالب: سعر البيع (بالأساس) أقل من كلفة الدواء.
    final belowCost = _lines
        .where((l) =>
            l.medicine.purchaseCost > 0 && toBase(l.unitPrice) < l.medicine.purchaseCost)
        .map((l) => l.medicine.displayName)
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
    final input = CreateSaleInput(
      currencyId: base?.id ?? currencyId,
      customerId: (_customerId != null && _customerId!.isNotEmpty) ? _customerId : null,
      originalCurrencyId: isForeign ? selected.id : null,
      exchangeRate: (isForeign && base.exchangeRate > 0)
          ? selected.exchangeRate / base.exchangeRate
          : 1,
      warehouseId: warehouseId,
      saleDate: DateTime.now(),
      totalAmount: toBase(_total),
      paymentMethod: _payMethod,
      isPrescription: _isPrescription,
      lines: [
        for (final l in _lines)
          CreateSaleLineInput(
            medicineId: l.medicine.id,
            unitId: l.unit.unitId,
            individual: toBase(l.unitPrice),
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
    _customerId = sale.customerId.isNotEmpty ? sale.customerId : null;
    _currencyId = null; // base
    _payMethod = sale.paymentMethod;
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
    final cust = payload['customerId'] as String?;
    _customerId = (cust != null && cust.isNotEmpty) ? cust : null;
    _currencyId = null; // amounts are stored in base
    _payMethod = PaymentMethod.fromWire((payload['paymentMethod'] as num?)?.toInt());
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
    final offline = !ref.watch(effectiveOnlineProvider);
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit || _isQueuedEdit
            ? AppStrings.editSale
            : AppStrings.newSale),
        actions: [
          const NotificationBell(),
          if (isMainPos) ...[
            // Manual online/offline toggle, right in the POS header.
            IconButton(
              tooltip: AppStrings.offlineToggleTooltip,
              icon: Icon(offline ? Icons.cloud_off : Icons.cloud_done_outlined,
                  color: offline ? Colors.orange.shade800 : null),
              onPressed: () => ref
                  .read(workModeControllerProvider.notifier)
                  .toggleOffline(
                      ref.read(workModeControllerProvider) != WorkMode.offline),
            ),
            // The "cloud" of un-synced invoices — shown ONLY when some exist.
            if (pending > 0)
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
        ],
      ),
      body: catalogAsync.when(
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
      ),
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
              // USB scanner ready indicator (replaces embedded camera).
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.07),
                  borderRadius: AppRadius.brMd,
                  border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.barcode_reader,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(AppStrings.readyToScan,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppDropdown<String>(
                      label: AppStrings.selectCurrency,
                      value: _effectiveCurrencyId(base).isEmpty
                          ? null
                          : _effectiveCurrencyId(base),
                      // عملات قابلة للاختيار فقط: الأساسية + أي عملة سعر صرفها موجب.
                      // عملة بلا سعر صرف (0) تُخفى لأن التحويل يُرجِع المبلغ دون تحويل.
                      items: [
                        for (final c in currencies.where(
                            (c) => c.isBaseCurrency || c.exchangeRate > 0))
                          AppDropdownItem(value: c.id, label: c.code),
                      ],
                      onChanged: (v) => setState(() {
                        _currencyId = v;
                        _repriceLines(base, currencies);
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppDropdown<String?>(
                      label: AppStrings.customer,
                      value: _customerId,
                      items: [
                        const AppDropdownItem<String?>(
                            value: null, label: AppStrings.noCustomer),
                        for (final c in ref.watch(customersProvider).value ??
                            const <Customer>[])
                          AppDropdownItem<String?>(value: c.id, label: c.fullName),
                      ],
                      onChanged: (v) => setState(() => _customerId = v),
                    ),
                  ),
                ],
              ),
              // وصفة طبية؟ عند التفعيل يصبح اختيار العميل إجبارياً.
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                value: _isPrescription,
                onChanged: (v) => setState(() => _isPrescription = v ?? false),
                title: const Text(AppStrings.prescriptionLabel),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Add-medicine field + a compact, unobtrusive payment-method
              // selector beside it.
              Row(
                children: [
                  Expanded(
                    child: MedicinePickerField(
                      medicines: catalog,
                      hint: AppStrings.addLine,
                      onSelected: _addMedicine,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _paymentSelector(theme),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _lines.isEmpty
              ? const EmptyState(
                  icon: Icons.qr_code_scanner,
                  message: AppStrings.saleEmptyHint,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: _lines.length,
                  itemBuilder: (context, i) {
                    final line = _lines[i];
                    return Dismissible(
                      key: ObjectKey(line),
                      direction: DismissDirection.horizontal,
                      background:
                          _dismissBackground(theme, Alignment.centerRight),
                      secondaryBackground:
                          _dismissBackground(theme, Alignment.centerLeft),
                      onDismissed: (_) => _removeWithUndo(line),
                      child: _lineTile(line, currencyCode, theme),
                    );
                  },
                ),
        ),
        _summaryBar(currencyCode, warehouseId, base, theme),
      ],
      ),
    );
  }

  Widget _lineTile(_PosLine line, String code, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: _isNegativeProfit(line)
            ? Colors.orange.withValues(alpha: 0.18)
            : null,
        borderRadius: AppRadius.brMd,
        border: Border.all(color: context.semantic.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.medicine.displayName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () => _editLineSheet(line),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '${line.unit.unitName}  •  ${Formatters.money(line.unitPrice, code)}'
                          '${line.selectedBatch?.expiryDate != null ? '  •  ${line.selectedBatch!.expiryLabel}' : ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.edit, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _qtyStepper(line),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 74,
            child: Text(
              Formatters.number(line.total),
              textAlign: TextAlign.end,
              style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: () => _removeWithUndo(line),
          ),
        ],
      ),
    );
  }

  Widget _qtyStepper(_PosLine line) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepBtn(Icons.remove, () {
            if (line.quantity > 1) {
              setState(() => line.quantity -= 1);
            } else {
              // Decrementing below 1 removes the line — undoably, so a stray tap
              // can't silently lose it (delete via ✕/swipe stays undoable too).
              _removeWithUndo(line);
            }
          }),
          InkWell(
            onTap: () => _editQuantity(line),
            child: SizedBox(
              width: 44,
              child: Text(Formatters.qty(line.quantity),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          _stepBtn(Icons.add, () => setState(() => line.quantity += 1)),
        ],
      );

  Widget _stepBtn(IconData icon, VoidCallback onTap) => InkResponse(
        onTap: onTap,
        radius: 20,
        child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      );

  Future<void> _editQuantity(_PosLine line) async {
    final v = await _promptNumber(AppStrings.quantity, line.quantity);
    if (v == null) return;
    if (v > 0) {
      setState(() => line.quantity = v);
    } else {
      // Typing 0 means "remove" — do it undoably instead of a silent drop.
      _removeWithUndo(line);
    }
  }

  /// Redesigned line editor: a compact bottom sheet to change the unit, price
  /// and expiry batch in one place. The sheet owns its text controller so
  /// cancelling never races a disposed controller.
  Future<void> _editLineSheet(_PosLine line) async {
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selectedCurrency = _selectedCurrency(base, currencies);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _LineEditorSheet(
        line: line,
        base: base,
        selectedCurrency: selectedCurrency,
        onApply: (unit, price, batch) {
          setState(() {
            line.unit = unit;
            if (price != null && price >= 0) line.unitPrice = price;
            line.selectedBatch = batch;
          });
        },
      ),
    );
  }

  Future<double?> _promptNumber(String title, double initial) {
    // Self-contained dialog owns its controller (disposed in its own dispose),
    // so cancelling after typing can never touch a disposed controller.
    return showDialog<double>(
      context: context,
      builder: (_) => _NumberPromptDialog(title: title, initial: initial),
    );
  }

  /// Compact, unobtrusive payment-method selector (icon + short label) that
  /// opens a menu — sits beside the add field instead of a prominent dropdown.
  Widget _paymentSelector(ThemeData theme) {
    return PopupMenuButton<PaymentMethod>(
      tooltip: AppStrings.paymentMethod,
      onSelected: (m) => setState(() => _payMethod = m),
      itemBuilder: (_) => [
        for (final m in PaymentMethod.values)
          PopupMenuItem(value: m, child: Text(m.label)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: context.semantic.border),
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.payments_outlined, size: 18, color: theme.hintColor),
            const SizedBox(width: 4),
            Text(_payMethod.label, style: theme.textTheme.bodySmall),
            Icon(Icons.arrow_drop_down, size: 18, color: theme.hintColor),
          ],
        ),
      ),
    );
  }

  Widget _summaryBar(
    String code,
    String? warehouseId,
    Currency? base,
    ThemeData theme,
  ) {
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
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: _submitting ? AppStrings.saving : AppStrings.save,
                    isLoading: _submitting,
                    backgroundColor: context.semantic.success,
                    onPressed: () => _submit(warehouseId, base),
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

/// Bottom-sheet editor for a receipt line (unit, price, expiry batch). Owns its
/// price controller and local selections; applies them via [onApply] on save.
class _LineEditorSheet extends StatefulWidget {
  const _LineEditorSheet({
    required this.line,
    required this.base,
    required this.selectedCurrency,
    required this.onApply,
  });

  final _PosLine line;
  final Currency? base;
  final Currency? selectedCurrency;
  final void Function(MedicineUnit unit, double? price, MedicineBatch? batch)
      onApply;

  @override
  State<_LineEditorSheet> createState() => _LineEditorSheetState();
}

class _LineEditorSheetState extends State<_LineEditorSheet> {
  late MedicineUnit _unit = widget.line.unit;
  late MedicineBatch? _batch = widget.line.selectedBatch;
  late final TextEditingController _priceCtrl =
      TextEditingController(text: Formatters.qty(widget.line.unitPrice));

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onApply(_unit, double.tryParse(_priceCtrl.text.trim()), _batch);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = widget.line;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(line.medicine.displayName,
              style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          AppDropdown<String>(
            label: AppStrings.unitLabel,
            value: _unit.unitId,
            items: [
              for (final u in line.medicine.units)
                AppDropdownItem(value: u.unitId, label: u.unitName),
            ],
            onChanged: (v) {
              final u =
                  line.medicine.units.where((x) => x.unitId == v).firstOrNull;
              if (u == null) return;
              setState(() {
                _unit = u;
                _priceCtrl.text = Formatters.qty(convertFromBase(
                    u.salePrice, widget.base, widget.selectedCurrency));
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppNumberField(
              controller: _priceCtrl,
              label: AppStrings.price,
              onChanged: (_) => setState(() {})),
          if (line.batches.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            AppDropdown<String>(
              label: AppStrings.expiryDateLabel,
              value: _batch?.stockId,
              items: [
                for (final b in line.batches)
                  AppDropdownItem(
                    value: b.stockId,
                    label:
                        '${b.expiryLabel}  (${Formatters.qty(b.quantityAvailable)})',
                  ),
              ],
              onChanged: (v) => setState(() =>
                  _batch = line.batches.where((b) => b.stockId == v).firstOrNull),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.text(
                  label: AppStrings.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton.primary(label: AppStrings.save, onPressed: _save),
              ),
            ],
          ),
        ],
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
    return AlertDialog(
      title: const Text('تحديد سعر المبيع'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
      actions: [
        AppButton.text(
          label: AppStrings.cancel,
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton.primary(
          label: AppStrings.save,
          fullWidth: false,
          isLoading: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}

class _NumberPromptDialog extends StatefulWidget {
  const _NumberPromptDialog({required this.title, required this.initial});

  final String title;
  final double initial;

  @override
  State<_NumberPromptDialog> createState() => _NumberPromptDialogState();
}

class _NumberPromptDialogState extends State<_NumberPromptDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: Formatters.qty(widget.initial))
        ..selection = TextSelection(
            baseOffset: 0,
            extentOffset: Formatters.qty(widget.initial).length);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => Navigator.of(context).pop(double.tryParse(_controller.text.trim()));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: AppNumberField(controller: _controller),

      actions: [
        AppButton.text(
          label: AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(
          label: AppStrings.save,
          fullWidth: false,
          onPressed: _save,
        ),
      ],
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
    return AlertDialog(
      title: const Text('إضافة مخزون'),
      // Scrollable so the fields + warning + date picker never overflow on small
      // screens or when the keyboard is open.
      content: SizedBox(
        width: double.maxFinite,
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
      actions: [
        AppButton.text(
            label: AppStrings.cancel, onPressed: () => Navigator.of(context).pop()),
        AppButton.primary(label: AppStrings.save, fullWidth: false, onPressed: _save),
      ],
    );
  }
}
