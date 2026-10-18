import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/enums/dosage_form.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/categories/category_providers.dart';
import 'package:saydaliati/features/manufacturers/manufacturer_providers.dart';
import 'package:saydaliati/features/medicine_units/domain/entities/unit.dart';
import 'package:saydaliati/features/medicine_units/unit_providers.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine_input.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/onboarding/onboarding_coach.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/forms/form_widgets.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Add/edit a medicine, including its priced units. Exactly one unit is the
/// base unit (conversion factor 1); the others convert to it. The purchase cost
/// is computed by the backend from purchase invoices and shown read-only here.
class MedicineFormPage extends ConsumerStatefulWidget {
  const MedicineFormPage({this.existing, this.initialBarcode = '', super.key});

  final Medicine? existing;

  /// Prefills the barcode for a brand-new medicine (e.g. opened after scanning
  /// an unknown code).
  final String initialBarcode;

  bool get isEdit => existing != null;

  @override
  ConsumerState<MedicineFormPage> createState() => _MedicineFormPageState();
}

/// One editable unit row: which unit, its sale price, and how many base units
/// it contains (the base row is always 1 and hides the factor field).
class _UnitRow {
  _UnitRow({this.unitId, String sale = '', String factor = '1'}) {
    this.sale.text = sale;
    this.factor.text = factor;
  }

  String? unitId;
  final sale = TextEditingController();
  final factor = TextEditingController();

  void dispose() {
    sale.dispose();
    factor.dispose();
  }
}

class _MedicineFormPageState extends ConsumerState<MedicineFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _brand = TextEditingController(text: widget.existing?.brandName ?? '');
  late final _generic = TextEditingController(text: widget.existing?.genericName ?? '');
  late final _foreign = TextEditingController(text: widget.existing?.foreignName ?? '');
  late final _barcode = TextEditingController(
      text: widget.existing?.barcode ?? widget.initialBarcode);
  final _description = TextEditingController();
  String? _categoryId;
  String? _manufacturerId;
  late DosageForm _dosageForm = widget.existing?.dosageForm ?? DosageForm.tablet;
  final List<_UnitRow> _unitRows = [];
  int _baseIndex = 0;
  int _defaultIndex = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryId = (widget.existing?.categoryId.isNotEmpty ?? false)
        ? widget.existing!.categoryId
        : null;
    _manufacturerId = widget.existing?.manufacturerId;

    final units = widget.existing?.units ?? const [];
    if (units.isEmpty) {
      _unitRows.add(_UnitRow());
      _baseIndex = 0;
    } else {
      for (var i = 0; i < units.length; i++) {
        final u = units[i];
        _unitRows.add(_UnitRow(
          unitId: u.unitId,
          sale: u.salePrice == 0 ? '' : _trim(u.salePrice),
          factor: _trim(u.conversionFactor),
        ));
        if (u.isBaseUnit) _baseIndex = i;
        if (u.isDefault) _defaultIndex = i;
      }
    }
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _brand.dispose();
    _generic.dispose();
    _barcode.dispose();
    _description.dispose();
    for (final r in _unitRows) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoryId == null) {
      AppSnackbar.error(context, AppStrings.selectCategory);
      return;
    }

    // Build valid rows, tagging the base by its original index.
    final rows = <MedicineUnitPriceInput>[];
    var baseIncluded = false;
    for (var i = 0; i < _unitRows.length; i++) {
      final r = _unitRows[i];
      // A unit is kept as long as it's chosen; the sale price is OPTIONAL (an
      // empty price = 0, e.g. a not-yet-priced imported medicine). Previously an
      // empty price dropped the row, so editing an unpriced medicine wrongly
      // reported "أضِف وحدة واحدة على الأقل".
      if (r.unitId == null) continue;
      final isBase = i == _baseIndex;
      final factor = isBase ? 1.0 : (double.tryParse(r.factor.text.trim()) ?? 0);
      if (!isBase && factor <= 0) {
        AppSnackbar.error(context, AppStrings.conversionFactorHint);
        return;
      }
      if (isBase) baseIncluded = true;
      rows.add(MedicineUnitPriceInput(
        unitId: r.unitId!,
        salePrice: double.tryParse(r.sale.text.trim()) ?? 0,
        conversionFactor: factor,
        isBaseUnit: isBase,
        isDefault: i == _defaultIndex,
      ));
    }

    if (rows.isEmpty) {
      AppSnackbar.error(context, AppStrings.atLeastOneUnit);
      return;
    }
    if (!baseIncluded) {
      AppSnackbar.error(context, AppStrings.selectOneBaseUnit);
      return;
    }

    // تنويه: سعر بيع أقل من الكلفة (الكلفة تُحسب على الوحدة الأساسية).
    final cost = widget.existing?.purchaseCost ?? 0;
    if (cost > 0 &&
        rows.any((r) => r.salePrice > 0 && r.salePrice < cost * r.conversionFactor)) {
      final ok = await showConfirmationDialog(
        context,
        title: AppStrings.priceBelowCostTitle,
        message: AppStrings.priceBelowCostBody,
        confirmLabel: AppStrings.continueLabel,
      );
      if (!ok || !mounted) return;
    }

    final input = CreateMedicineInput(
      categoryId: _categoryId!,
      brandName: _brand.text.trim(),
      genericName: _generic.text.trim(),
      foreignName: _foreign.text.trim(),
      barcode: _barcode.text.trim(),
      manufacturerId: _manufacturerId,
      dosageForm: _dosageForm,
      description: _description.text.trim(),
      unitPrices: rows,
    );

    setState(() => _saving = true);
    final repo = ref.read(medicineRepositoryProvider);
    final notifier = ref.read(medicineCatalogProvider.notifier);

    if (widget.isEdit) {
      final r = await repo.update(widget.existing!.id, input);
      if (!mounted) return;
      final ok = r.fold((_) => true, (f) {
        showFailureSnackbar(context, f);
        return false;
      });
      if (!ok) {
        setState(() => _saving = false);
        return;
      }
      // Refresh just this medicine (server → cache → in-memory), keeps it sorted.
      await notifier.refreshOne(widget.existing!.id);
    } else {
      final r = await repo.create(input);
      if (!mounted) return;
      String newId = '';
      final ok = r.fold((id) {
        newId = id;
        return true;
      }, (f) {
        showFailureSnackbar(context, f);
        return false;
      });
      if (!ok) {
        setState(() => _saving = false);
        return;
      }
      // Fetch the new medicine and insert it into the cache + catalog (sorted),
      // so it shows immediately and is saved locally — no full re-pull.
      if (newId.isNotEmpty) {
        await notifier.insertNew(newId);
      } else {
        ref.invalidate(medicineCatalogProvider);
      }
    }

    if (!mounted) return;
    setState(() => _saving = false);
    AppSnackbar.success(context, AppStrings.medicineSavedSuccess);
    Navigator.of(context).pop();
  }

  // مفاتيح أهداف الجولة التعليمية (أول دواء).
  final _nameKey = GlobalKey();
  final _categoryKey = GlobalKey();
  final _unitsKey = GlobalKey();
  final _saveKey = GlobalKey();
  bool _coachShown = false;

  void _maybeShowCoach() {
    if (_coachShown) return;
    final onb = ref.read(onboardingControllerProvider);
    if (!onb.active || onb.stage != OnboardingStage.medicine) return;
    _coachShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(onboardingControllerProvider.notifier);
      showCoach(
        context,
        steps: [
          CoachStep(key: _nameKey, title: AppStrings.onbMedNameTitle, text: AppStrings.onbMedNameText),
          CoachStep(key: _categoryKey, title: AppStrings.onbMedCategoryTitle, text: AppStrings.onbMedCategoryText),
          CoachStep(key: _unitsKey, title: AppStrings.onbMedUnitsTitle, text: AppStrings.onbMedUnitsText, align: ContentAlign.top),
          CoachStep(key: _saveKey, title: AppStrings.onbMedSaveTitle, text: AppStrings.onbMedSaveText, align: ContentAlign.top),
        ],
        // After the medicine form, guide the user to add a purchase invoice.
        onFinish: () => notifier.toStage(OnboardingStage.purchase),
        onSkip: () => notifier.finish(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final manufacturers = ref.watch(manufacturersProvider).value ?? const [];
    final units = ref.watch(unitsProvider).value ?? const [];
    _maybeShowCoach();

    return BarcodeScannerListener(
      onScan: (code) {
        if (mounted) setState(() => _barcode.text = code);
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? AppStrings.editMedicine : AppStrings.addMedicine),
        actions: const [TutorialHelpButton(TutorialTopic.addMedicine)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ConstrainedContent(
              maxWidth: AppBreakpoints.maxFormWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppFormSection(
                    title: AppStrings.addMedicine,
                    children: [
                      // اسمان في السطر الواحد على العرض الكافي.
                      _fieldPair(
                        KeyedSubtree(
                          key: _nameKey,
                          child: AppTextField(
                            controller: _brand,
                            label: AppStrings.brandName,
                            isRequired: true,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? AppStrings.requiredField
                                : null,
                          ),
                        ),
                        AppTextField(
                            controller: _generic, label: AppStrings.genericName),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _fieldPair(
                        AppTextField(
                            controller: _foreign, label: 'الاسم بالأجنبي'),
                        AppTextField(
                            controller: _barcode, label: AppStrings.barcode),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _fieldPair(
                        KeyedSubtree(
                          key: _categoryKey,
                          child: AppDropdown<String>(
                            label: AppStrings.selectCategory,
                            isRequired: true,
                            value: _categoryId,
                            items: [
                              for (final c in categories)
                                AppDropdownItem(
                                    value: c.id, label: c.categoryName),
                            ],
                            onChanged: (v) => setState(() => _categoryId = v),
                          ),
                        ),
                        AppDropdown<String>(
                          label: AppStrings.selectManufacturer,
                          value: _manufacturerId,
                          items: [
                            for (final m in manufacturers)
                              AppDropdownItem(value: m.id, label: m.name),
                          ],
                          onChanged: (v) =>
                              setState(() => _manufacturerId = v),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppDropdown<DosageForm>(
                        label: AppStrings.dosageForm,
                        value: _dosageForm,
                        items: [
                          for (final d in DosageForm.values)
                            AppDropdownItem(value: d, label: d.label),
                        ],
                        onChanged: (v) => setState(
                            () => _dosageForm = v ?? DosageForm.tablet),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _description,
                        label: AppStrings.description,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  KeyedSubtree(key: _unitsKey, child: _unitsSection(units)),
                  const SizedBox(height: AppSpacing.xl),
                  KeyedSubtree(
                    key: _saveKey,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: SizedBox(
                        width: 180,
                        child: AppButton.primary(
                          label: _saving ? AppStrings.saving : AppStrings.save,
                          isLoading: _saving,
                          onPressed: _save,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  /// صفّان من الحقول في السطر الواحد على العرض الكافي (سطح المكتب)، ويتراصّان
  /// عمودياً على الضيق — بنفس أسلوب نماذج المشروع الأخرى.
  Widget _fieldPair(Widget a, Widget b) => LayoutBuilder(
        builder: (context, c) => c.maxWidth >= 480
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: a),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: b),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [a, const SizedBox(height: AppSpacing.md), b],
              ),
      );

  Widget _unitsSection(List<Unit> units) {
    return AppFormSection(
      title: AppStrings.pricedUnits,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            AppStrings.baseUnitHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        ),
        if (widget.isEdit && (widget.existing?.purchaseCost ?? 0) > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(Icons.payments_outlined, size: AppSizes.iconSm),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${AppStrings.purchaseCostLabel}: '
                  '${_trim(widget.existing!.purchaseCost)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        for (var i = 0; i < _unitRows.length; i++) _unitRowCard(i, units),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton.outline(
              label: AppStrings.addPricedUnit,
              icon: Icons.add,
              fullWidth: false,
              onPressed: () => setState(() => _unitRows.add(_UnitRow())),
            ),
            AppButton.text(
              label: AppStrings.addNewUnit,
              icon: Icons.add_circle_outline,
              fullWidth: false,
              onPressed: _createUnit,
            ),
          ],
        ),
      ],
    );
  }

  /// Quickly create a new medicine unit (e.g. علبة/شريط) without leaving the form.
  Future<void> _createUnit() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.rule_outlined,
                          color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(AppStrings.addNewUnit,
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
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: ctrl,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: AppStrings.unitNameLabel),
                    onSubmitted: (_) => Navigator.pop(ctx, ctrl.text.trim()),
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
                          onPressed: () => Navigator.pop(ctx),
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
                          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
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
      },
    );
    ctrl.dispose();
    if (name == null || name.isEmpty) return;
    final res = await ref.read(unitRepositoryProvider).create(name: name);
    if (!mounted) return;
    res.fold(
      (_) {
        ref.invalidate(unitsProvider);
        AppSnackbar.success(context, AppStrings.unitCreated);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  Widget _unitRowCard(int index, List<Unit> units) {
    final row = _unitRows[index];
    final isBase = index == _baseIndex;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppDropdown<String>(
                    hint: AppStrings.selectUnit,
                    value: row.unitId,
                    items: [
                      for (final u in units)
                        AppDropdownItem<String>(value: u.id, label: u.name),
                    ],
                    onChanged: (v) => setState(() => row.unitId = v),
                  ),
                ),
                if (_unitRows.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: AppStrings.cancel,
                    onPressed: () => setState(() {
                      _unitRows.removeAt(index).dispose();
                      if (_baseIndex >= _unitRows.length) {
                        _baseIndex = _unitRows.length - 1;
                      } else if (index < _baseIndex) {
                        _baseIndex -= 1;
                      }
                      if (_defaultIndex >= _unitRows.length) {
                        _defaultIndex = _unitRows.length - 1;
                      } else if (index < _defaultIndex) {
                        _defaultIndex -= 1;
                      }
                      if (_defaultIndex < 0) _defaultIndex = 0;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppNumberField(
                      controller: row.sale, label: AppStrings.salePrice),
                ),
                if (!isBase) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppNumberField(
                        controller: row.factor,
                        label: AppStrings.conversionFactor),
                  ),
                ],
              ],
            ),
            // اختيار الوحدة الأساسية — واحدة فقط
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                onTap: () => setState(() {
                  _baseIndex = index;
                  row.factor.text = '1';
                }),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBase
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: AppSizes.iconSm,
                        color: isBase
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).hintColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text(AppStrings.baseUnit),
                    ],
                  ),
                ),
              ),
            ),
            // اختيار الوحدة الافتراضية — تُختار تلقائياً عند البيع (واحدة فقط)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                onTap: () => setState(() => _defaultIndex = index),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        index == _defaultIndex
                            ? Icons.star
                            : Icons.star_border,
                        size: AppSizes.iconSm,
                        color: index == _defaultIndex
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).hintColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text(AppStrings.defaultUnit),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
