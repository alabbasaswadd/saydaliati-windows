import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/expenses/expense_providers.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';

/// حوار إضافة/تعديل مصروف — بأسلوب نوافذ ويندوز (مطابق لـ EntityFormDialog):
/// عرض ثابت ضيّق، رأس بأيقونة + عنوان + زر إغلاق صغير، أزرار بحجم محتواها.
///
/// الحفظ يحدث هنا داخل الحوار نفسه (لا يُغلَق فوراً بقيم خام): عند الضغط
/// «حفظ» يبقى الحوار مفتوحاً وزرّ الحفظ يتحوّل لمؤشّر تحميل، ولا يُغلَق إلا
/// بعد نجاح الطلب — عند الفشل يبقى مفتوحاً ويظهر سبب الخطأ. يُعيد `true` عند
/// الحفظ الناجح، أو `null`/`false` عند الإلغاء.
Future<bool?> showExpenseFormDialog(
  BuildContext context, {
  required List<ExpenseCategory> categories,
  Expense? existing,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        _ExpenseFormDialog(categories: categories, existing: existing),
  );
}

class _ExpenseFormDialog extends ConsumerStatefulWidget {
  const _ExpenseFormDialog({required this.categories, this.existing});

  final List<ExpenseCategory> categories;
  final Expense? existing;

  @override
  ConsumerState<_ExpenseFormDialog> createState() => _ExpenseFormDialogState();
}

class _ExpenseFormDialogState extends ConsumerState<_ExpenseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _amountController =
      TextEditingController(text: widget.existing?.amount.toString() ?? '');
  late final _noteController =
      TextEditingController(text: widget.existing?.note ?? '');

  String? _categoryId;

  ExpenseCategory? get _selectedCategory =>
      widget.categories.where((c) => c.id == _categoryId).firstOrNull;

  /// التصنيف المختار بلا حساب مرتبط ⇒ لا قيد محاسبي ولا أثر على الصندوق.
  bool get _selectedCategoryUnlinked {
    final c = _selectedCategory;
    return c != null && (c.accountId == null || c.accountId!.isEmpty);
  }

  String get _selectedCategoryName => _selectedCategory?.name ?? '';
  DateTime? _spentOn;
  String? _paymentAccountId;
  String? _currencyId;
  bool _saving = false;

  /// آخر حساب دفع اقترحناه تلقائياً حسب العملة — لتمييز "لم يُلمَس" عن
  /// "المستخدم اختاره بنفسه"، فلا نخاطر بمحو اختيار صريح عند تبديل العملة.
  String? _lastSuggestedPaymentAccountId;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _categoryId = existing?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : null);
    _spentOn = existing?.spentOn ?? DateTime.now();
    _paymentAccountId = existing?.paymentAccountId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// يقترح صندوق العملة المختارة (الحساب المرتبط بها)، أو صندوق العملة
  /// الأساسية إن لم يوجد صندوق مخصَّص لها. لا يلمس اختياراً صريحاً للمستخدم.
  void _suggestPaymentAccountForCurrency(
      String? currencyId, List<Account> accounts, String? baseCurrencyId) {
    if (accounts.isEmpty) return;
    final untouched =
        _paymentAccountId == null || _paymentAccountId == _lastSuggestedPaymentAccountId;
    if (!untouched) return;

    final matching = accounts.where((a) => a.currencyId == currencyId).firstOrNull;
    final fallbackCash = accounts.where((a) => a.currencyId == baseCurrencyId).firstOrNull;
    final suggested = matching ?? fallbackCash;
    if (suggested == null) return;

    _lastSuggestedPaymentAccountId = suggested.id;
    _paymentAccountId = suggested.id;
  }

  Future<void> _submit(List<Currency> currencies, Currency? base) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoryId == null || _spentOn == null || _paymentAccountId == null) return;

    final selected = currencies.where((c) => c.id == _currencyId).firstOrNull ?? base;
    // المبلغ يُرسَل كما كُتب بعملته المختارة — لا تحويل هنا. الخادم يشتقّ
    // المقابل بالعملة الأساسية مرّة واحدة ويجمّده للقيد والتقارير.
    final enteredAmount = double.tryParse(_amountController.text.trim()) ?? 0;

    setState(() => _saving = true);

    final repo = ref.read(expenseRepositoryProvider);
    final result = widget.existing == null
        ? await repo.create(CreateExpenseInput(
            categoryId: _categoryId!,
            spentOn: _spentOn!,
            note: _noteController.text.trim(),
            amount: enteredAmount,
            currencyId: selected?.id ?? '',
            paymentAccountId: _paymentAccountId!,
            originalCurrencyId: selected?.id,
            exchangeRate: selected?.exchangeRate ?? 1,
          ))
        : await repo.update(
            widget.existing!.id,
            UpdateExpenseInput(
              categoryId: _categoryId!,
              spentOn: _spentOn!,
              note: _noteController.text.trim(),
              amount: enteredAmount,
              currencyId: selected?.id ?? '',
              paymentAccountId: _paymentAccountId!,
              originalCurrencyId: selected?.id,
              exchangeRate: selected?.exchangeRate ?? 1,
            ),
          );

    if (!mounted) return;
    result.fold(
      (_) => Navigator.of(context).pop(true),
      (failure) {
        setState(() => _saving = false);
        showFailureSnackbar(context, failure);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.existing != null;
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    // المصروف المحفوظ يحمل معرّف عملته صراحةً الآن — لا حاجة لمطابقة الرمز.
    _currencyId ??= (widget.existing?.currencyId.isNotEmpty ?? false)
        ? widget.existing!.currencyId
        : widget.existing?.currencyCode != null
        ? currencies
                .where((c) => c.code == widget.existing!.currencyCode)
                .firstOrNull
                ?.id ??
            base?.id
        : base?.id;
    _suggestPaymentAccountForCurrency(_currencyId, accounts, base?.id);

    return SaveShortcut(
      onSave: () => _submit(currencies, base),
      enabled: !_saving,
      child: PopScope(
      canPop: !_saving,
      child: Dialog(
        backgroundColor: theme.colorScheme.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 18),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          color: theme.colorScheme.primary, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            isEdit ? AppStrings.editExpense : AppStrings.addExpense,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
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
                          onPressed:
                              _saving ? null : () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.65,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppDropdown<String>(
                            label: AppStrings.expenseCategoryColumn,
                            isRequired: true,
                            enabled: !_saving,
                            value: _categoryId,
                            items: [
                              for (final c in widget.categories)
                                AppDropdownItem(value: c.id, label: c.name),
                            ],
                            onChanged: (v) => setState(() => _categoryId = v),
                          ),
                          // تصنيف غير مربوط بحساب ⇒ المصروف لن يحرّك أي رصيد.
                          // نقولها هنا لا بعد شهر من التسجيل.
                          if (_selectedCategoryUnlinked) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _UnlinkedCategoryWarning(
                                categoryName: _selectedCategoryName),
                          ],
                          const SizedBox(height: AppSpacing.md),
                          AppDatePicker(
                            label: AppStrings.expenseDate,
                            isRequired: true,
                            enabled: !_saving,
                            value: _spentOn,
                            lastDate: DateTime.now(),
                            onChanged: (d) => setState(() => _spentOn = d),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: AppTextField(
                                  controller: _amountController,
                                  label: AppStrings.expenseAmount,
                                  isRequired: true,
                                  enabled: !_saving,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*')),
                                  ],
                                  validator: (v) {
                                    final n = double.tryParse((v ?? '').trim());
                                    return (n == null || n <= 0)
                                        ? AppStrings.requiredField
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                flex: 2,
                                child: AppDropdown<String>(
                                  label: AppStrings.selectCurrency,
                                  isRequired: true,
                                  enabled: !_saving,
                                  value: _currencyId,
                                  items: [
                                    for (final c in currencies)
                                      AppDropdownItem(value: c.id, label: c.code),
                                  ],
                                  onChanged: (v) => setState(() {
                                    _currencyId = v;
                                    _suggestPaymentAccountForCurrency(v, accounts, base?.id);
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppDropdown<String>(
                            label: AppStrings.expensePaymentSource,
                            isRequired: true,
                            enabled: !_saving,
                            value: _paymentAccountId,
                            items: [
                              for (final a in accounts)
                                AppDropdownItem(value: a.id, label: a.name),
                            ],
                            onChanged: (v) =>
                                setState(() => _paymentAccountId = v),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _noteController,
                            label: AppStrings.expenseNote,
                            enabled: !_saving,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
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
                              _saving ? null : () => Navigator.of(context).pop(),
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
                          onPressed:
                              _saving ? null : () => _submit(currencies, base),
                          child: _saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
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
        ),
      ),
    ),
    );
  }
}


/// تنويه داخل نموذج المصروف: التصنيف المختار غير مربوط بحساب، فالمصروف
/// سيُسجَّل للمتابعة فقط ولن ينقص رصيد الصندوق ولن يظهر له سند قيد.
class _UnlinkedCategoryWarning extends StatelessWidget {
  const _UnlinkedCategoryWarning({required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = context.semantic.warning;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: AppRadius.brXs,
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_outlined,
              size: AppSizes.iconXs, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'تصنيف «$categoryName» غير مربوط بحساب — سيُسجَّل المصروف '
              'للمتابعة فقط ولن ينقص رصيد الصندوق ولن يظهر له سند قيد. '
              'اربطه من شاشة «تصنيفات المصاريف».',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
