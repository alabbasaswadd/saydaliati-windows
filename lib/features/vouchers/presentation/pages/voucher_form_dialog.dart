import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/network/server_capabilities.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';
import 'package:saydaliati/features/vouchers/voucher_providers.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';

/// حوار إضافة سند مباشر — طرف مدين وطرف دائن بنفس المبلغ (الحالة الشائعة
/// لسند قبض/دفع). نفس أسلوب حوار المصروف/الحساب: الحفظ داخل الحوار نفسه
/// مع مؤشّر تحميل، لا يُغلَق إلا بعد نجاح الطلب.
Future<bool?> showVoucherFormDialog(
  BuildContext context, {
  required List<Account> accounts,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _VoucherFormDialog(accounts: accounts),
  );
}

class _VoucherFormDialog extends ConsumerStatefulWidget {
  const _VoucherFormDialog({required this.accounts});

  final List<Account> accounts;

  @override
  ConsumerState<_VoucherFormDialog> createState() => _VoucherFormDialogState();
}

class _VoucherFormDialogState extends ConsumerState<_VoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _date = DateTime.now();
  String? _debitAccountId;
  String? _creditAccountId;
  String? _currencyId;
  String? _lastSuggestedCurrencyId;
  bool _saving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// يقترح عملة السند حسب عملة الحساب المدين المختار (أو الدائن إن لم
  /// يُحدَّد مدين) — أو العملة الأساسية إن لم يكن لأيٍّ منهما عملة خاصة. لا
  /// يلمس اختياراً صريحاً للمستخدم.
  void _suggestCurrencyForAccount(String? accountId) {
    final untouched =
        _currencyId == null || _currencyId == _lastSuggestedCurrencyId;
    if (!untouched) return;

    final account =
        widget.accounts.where((a) => a.id == accountId).firstOrNull;
    if (account == null) return;

    _lastSuggestedCurrencyId = account.currencyId;
    _currencyId = account.currencyId;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_date == null || _debitAccountId == null || _creditAccountId == null) return;
    if (_debitAccountId == _creditAccountId) {
      AppSnackbar.error(context, 'لا يمكن اختيار نفس الحساب للطرفين');
      return;
    }

    // المبلغ يُرسَل كما كُتب بعملته — التحويل صار على الخادم بسعره، فلا
    // ينحرف رصيد صندوق العملة عمّا كتبه المستخدم حين يختلف سعر العميل.
    final enteredAmount = double.tryParse(_amountController.text.trim()) ?? 0;

    // خادم أقدم لا يحوّل ⇒ نحوّل نحن كما كان، وإلا سُجّل المبلغ بعملة خاطئة.
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected = currencies.where((c) => c.id == _currencyId).firstOrNull;
    final serverConverts = ref.read(serverCapabilitiesProvider).value
            ?.amountsInOriginalCurrency == true;
    final amount =
        serverConverts ? enteredAmount : convertToBase(enteredAmount, base, selected);

    setState(() => _saving = true);
    final result = await ref.read(voucherRepositoryProvider).create(CreateVoucherInput(
          date: _date!,
          description: _descriptionController.text.trim(),
          debitAccountId: _debitAccountId!,
          creditAccountId: _creditAccountId!,
          amount: amount,
          currencyId: serverConverts ? _currencyId : null,
        ));

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

    return SaveShortcut(
      onSave: _submit,
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
                      Icon(Icons.description_outlined,
                          color: theme.colorScheme.primary, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('سند جديد',
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
                          onPressed:
                              _saving ? null : () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppDatePicker(
                    label: 'التاريخ',
                    isRequired: true,
                    enabled: !_saving,
                    value: _date,
                    lastDate: DateTime.now(),
                    onChanged: (d) => setState(() => _date = d),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _descriptionController,
                    label: 'البيان',
                    isRequired: true,
                    enabled: !_saving,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AccountPickerField(
                    label: 'من حساب (مدين)',
                    accounts: widget.accounts,
                    selectedId: _debitAccountId,
                    onSelected: (a) => setState(() {
                      _debitAccountId = a.id;
                      _suggestCurrencyForAccount(a.id);
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AccountPickerField(
                    label: 'إلى حساب (دائن)',
                    accounts: widget.accounts,
                    selectedId: _creditAccountId,
                    onSelected: (a) => setState(() {
                      _creditAccountId = a.id;
                      _suggestCurrencyForAccount(_debitAccountId ?? a.id);
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppTextField(
                          controller: _amountController,
                          label: 'المبلغ',
                          isRequired: true,
                          enabled: !_saving,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          validator: (v) {
                            final n = double.tryParse((v ?? '').trim());
                            return (n == null || n <= 0) ? AppStrings.requiredField : null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Builder(builder: (_) {
                          final currencies =
                              ref.watch(currenciesProvider).value ?? const [];
                          final base = ref.watch(baseCurrencyProvider);
                          return AppDropdown<String?>(
                            label: 'العملة',
                            enabled: !_saving,
                            value: _currencyId ?? base?.id,
                            items: [
                              for (final c in currencies)
                                AppDropdownItem(value: c.id, label: c.code),
                            ],
                            onChanged: (v) => setState(() => _currencyId = v),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                          onPressed: _saving ? null : _submit,
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
