import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// رصيد افتتاحي لصندوق عملة — سند قيد مزدوج (مدين الصندوق، دائن رأس المال)
/// بعملة الصندوق نفسها حصراً؛ لا حقل عملة هنا عمداً — القيمة المدخلة تُسجَّل
/// بعملة الصندوق المختار كما هي، والخادم يرفض أي حساب بلا عملة خاصة.
///
/// [accounts] القائمة المؤهَّلة فقط (مُصفّاة مسبقاً بحسب وجود عملة) — الحوار
/// لا يُعاد تصفيتها، فلا داعي لتمرير `currencies`/التحقق هنا مجدداً.
///
/// تاريخ الرصيد مهمّ لمن يُدخل فواتير قديمة بالرجوع: يجب أن يسبق أقدم فاتورة
/// سيُدخلها، وإلا ظهر رصيد الصندوق سالباً أثناء الإدخال الرجعي — القيود تُرتَّب
/// بتاريخها المحاسبي لا بوقت إدخالها الفعلي.
Future<bool?> showOpeningBalanceDialog(BuildContext context,
    {required List<Account> accounts}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _OpeningBalanceDialog(accounts: accounts),
  );
}

class _OpeningBalanceDialog extends ConsumerStatefulWidget {
  const _OpeningBalanceDialog({required this.accounts});

  final List<Account> accounts;

  @override
  ConsumerState<_OpeningBalanceDialog> createState() => _OpeningBalanceDialogState();
}

class _OpeningBalanceDialogState extends ConsumerState<_OpeningBalanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;
  late String? _accountId = widget.accounts.first.id;

  Account? get _account =>
      widget.accounts.where((a) => a.id == _accountId).firstOrNull;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final account = _account;
    if (account == null) return;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    setState(() => _saving = true);

    final result = await ref.read(accountRepositoryProvider).setOpeningBalance(
          account.id,
          amount: amount,
          date: _date,
          note: _noteController.text.trim(),
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
    final currencyCode = _account?.currencyCode ?? '';

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
            constraints: const BoxConstraints(maxWidth: 420),
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
                        Icon(Icons.savings_outlined,
                            color: theme.colorScheme.primary, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'رصيد افتتاحي',
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
                    AppDropdown<String?>(
                      label: 'الصندوق',
                      isRequired: true,
                      enabled: !_saving,
                      value: _accountId,
                      items: [
                        for (final a in widget.accounts)
                          AppDropdownItem(
                              value: a.id, label: '${a.name} (${a.currencyCode})'),
                      ],
                      onChanged: (v) => setState(() => _accountId = v),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // العملة ثابتة — لا يملك المستخدم اختيارها، فيُوضَّح ذلك
                    // صريحاً بدل أن يبدو الغياب حقلاً نسيناه.
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: context.semantic.info.withValues(alpha: 0.10),
                        borderRadius: AppRadius.brXs,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: AppSizes.iconXs, color: context.semantic.info),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'يُسجَّل المبلغ دوماً بعملة الصندوق ($currencyCode)',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: _amountController,
                      label: 'المبلغ ($currencyCode)',
                      isRequired: true,
                      enabled: !_saving,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      validator: (v) {
                        final n = double.tryParse((v ?? '').trim());
                        return (n == null || n <= 0) ? AppStrings.requiredField : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppDatePicker(
                      label: 'تاريخ الرصيد الافتتاحي',
                      hint: 'اختر تاريخاً سابقاً لأقدم فاتورة قديمة ستُدخلها',
                      isRequired: true,
                      enabled: !_saving,
                      value: _date,
                      lastDate: DateTime.now(),
                      onChanged: (d) => setState(() => _date = d),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: _noteController,
                      label: 'ملاحظة (اختياري)',
                      enabled: !_saving,
                      maxLines: 2,
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
