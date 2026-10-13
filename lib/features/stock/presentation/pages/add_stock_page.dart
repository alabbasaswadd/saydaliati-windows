import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/settings/settings_providers.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';
import 'package:saydaliati/features/stock/stock_providers.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/cards/app_cards.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/forms/form_widgets.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// Receive stock (create) or edit an existing stock batch. On receive, if the
/// chosen medicine has no barcode a plain barcode field is shown (type or scan)
/// and the code is saved onto the medicine. On edit, the medicine is fixed and
/// quantity / purchase price / expiry are updated.
class AddStockPage extends ConsumerStatefulWidget {
  const AddStockPage({this.stockToEdit, super.key});

  final Stock? stockToEdit;

  @override
  ConsumerState<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends ConsumerState<AddStockPage> {
  Medicine? _medicine;
  final _qty = TextEditingController();
  final _purchase = TextEditingController();
  final _barcode = TextEditingController();
  DateTime? _expiry;
  bool _saving = false;

  bool get _isEdit => widget.stockToEdit != null;

  @override
  void initState() {
    super.initState();
    final s = widget.stockToEdit;
    if (s != null) {
      _qty.text = _plain(s.quantityAvailable);
      _purchase.text = _plain(s.purchasePrice);
      _expiry = s.expiryDate;
    }
  }

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _qty.dispose();
    _purchase.dispose();
    _barcode.dispose();
    super.dispose();
  }

  bool get _medicineNeedsBarcode =>
      _medicine != null && _medicine!.barcode.trim().isEmpty;

  void _selectMedicine(Medicine? m) {
    setState(() {
      _medicine = m;
      _barcode.clear();
    });
  }

  Future<void> _save(String? warehouseId) async {
    final qty = double.tryParse(_qty.text.trim()) ?? 0;
    if (qty <= 0) {
      AppSnackbar.error(context, AppStrings.quantity);
      return;
    }

    // ===== Edit an existing batch =====
    if (_isEdit) {
      final s = widget.stockToEdit!;
      setState(() => _saving = true);
      final r = await ref.read(stockRepositoryProvider).update(
            s.id,
            UpdateStockInput(
              medicineId: s.medicineId,
              quantityAvailable: qty,
              purchasePrice: double.tryParse(_purchase.text.trim()) ?? 0,
              sellingPrice: s.sellingPrice,
              expiryDate: _expiry,
            ),
          );
      if (!mounted) return;
      setState(() => _saving = false);
      r.fold(
        (_) {
          ref.invalidate(stockListProvider);
          AppSnackbar.success(context, AppStrings.stockSavedSuccess);
          Navigator.of(context).pop();
        },
        (failure) => showFailureSnackbar(context, failure),
      );
      return;
    }

    // ===== Receive new stock =====
    if (_medicine == null) {
      AppSnackbar.error(context, AppStrings.selectMedicine);
      return;
    }
    if (warehouseId == null || warehouseId.isEmpty) {
      AppSnackbar.error(context, AppStrings.warehouseNotSet);
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(stockRepositoryProvider).create(
          CreateStockInput(
            medicineId: _medicine!.id,
            warehouseId: warehouseId,
            quantityAvailable: qty,
            purchasePrice: double.tryParse(_purchase.text.trim()) ?? 0,
            expiryDate: _expiry,
          ),
        );
    if (!mounted) return;
    final created = result.fold((_) => true, (f) {
      showFailureSnackbar(context, f);
      return false;
    });
    if (!created) {
      setState(() => _saving = false);
      return;
    }

    // Assign the entered/scanned barcode to the medicine (only if it had none).
    final code = _barcode.text.trim();
    if (code.isNotEmpty && _medicine!.barcode.trim().isEmpty) {
      final r =
          await ref.read(medicineRepositoryProvider).assignBarcode(_medicine!.id, code);
      if (!mounted) return;
      r.fold(
        (updated) => ref.read(medicineCatalogProvider.notifier).upsert(updated),
        (f) => AppSnackbar.error(
            context, 'تم حفظ المخزون، لكن تعذّر حفظ الباركود: ${_msg(f)}'),
      );
    }

    ref.invalidate(stockListProvider);
    if (!mounted) return;
    AppSnackbar.success(context, AppStrings.stockSavedSuccess);
    Navigator.of(context).pop();
  }

  String _msg(Object f) {
    final s = f.toString();
    return s.length > 80 ? s.substring(0, 80) : s;
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(medicineCatalogProvider).value ?? const [];
    final warehouseId = ref.watch(defaultWarehouseIdProvider).value;
    final title = _isEdit ? 'تعديل المخزون' : AppStrings.receiveStock;

    return BarcodeScannerListener(
      onScan: (code) {
        if (mounted && _medicineNeedsBarcode) {
          setState(() => _barcode.text = code);
        }
      },
      child: Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (!_isEdit && (warehouseId == null || warehouseId.isEmpty)) ...[
            InfoCard(
              icon: Icons.warehouse_outlined,
              color: Theme.of(context).colorScheme.error,
              message: AppStrings.warehouseNotSet,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          AppFormSection(
            title: title,
            children: [
              if (_isEdit)
                // Medicine is fixed when editing a batch.
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication_outlined),
                  title: Text(widget.stockToEdit!.medicineName),
                )
              else if (_medicine != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication_outlined),
                  title: Text(_medicine!.displayName),
                  trailing: TextButton(
                    onPressed: () => _selectMedicine(null),
                    child: const Text(AppStrings.edit),
                  ),
                )
              else
                MedicinePickerField(
                  medicines: catalog,
                  hint: AppStrings.selectMedicine,
                  onSelected: _selectMedicine,
                ),

              // باركود الدواء: حقل واضح يظهر فقط عند الاستلام إن لم يكن للدواء باركود.
              if (!_isEdit && _medicineNeedsBarcode)
                AppTextField(
                  controller: _barcode,
                  label: 'باركود الدواء (اختياري)',
                  hint: 'امسح بالماسح أو أدخله يدوياً',
                  prefixIcon: const Icon(Icons.qr_code_2),
                ),

              AppNumberField(controller: _qty, label: AppStrings.quantity, isRequired: true),
              AppNumberField(controller: _purchase, label: AppStrings.purchasePrice),
              AppDatePicker(
                label: AppStrings.expirationDate,
                value: _expiry,
                hint: AppStrings.expirationDate,
                onChanged: (d) => setState(() => _expiry = d),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            label: _saving ? AppStrings.saving : AppStrings.save,
            isLoading: _saving,
            onPressed: () => _save(warehouseId),
          ),
        ],
      ),
      ),
    );
  }
}
