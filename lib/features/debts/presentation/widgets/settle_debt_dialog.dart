import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/debts/debt_providers.dart';
import 'package:saydaliati/features/debts/domain/party_debt.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// حوار تسديد دين طرف — كلّه أو قسماً منه.
///
/// المبلغ يبدأ بكامل الدين لأنه الحالة الأغلب، ويبقى قابلاً للتعديل للتسديد
/// الجزئي. والسقف يُفرَض في الطرفين: الواجهة تمنع الخطأ قبل الشبكة، والخادم
/// يرفضه مهما أُرسل — فجهازان يُسدِّدان في اللحظة نفسها لا يُنتجان رصيداً
/// سالباً.
Future<bool> showSettleDebtDialog(
  BuildContext context, {
  required PartyType partyType,
  required PartyDebt debt,
}) async {
  final done = await showDialog<bool>(
    context: context,
    builder: (_) => _SettleDebtDialog(partyType: partyType, debt: debt),
  );
  return done ?? false;
}

class _SettleDebtDialog extends ConsumerStatefulWidget {
  const _SettleDebtDialog({required this.partyType, required this.debt});

  final PartyType partyType;
  final PartyDebt debt;

  @override
  ConsumerState<_SettleDebtDialog> createState() => _SettleDebtDialogState();
}

class _SettleDebtDialogState extends ConsumerState<_SettleDebtDialog> {
  late final TextEditingController _amount =
      TextEditingController(text: widget.debt.balance.toStringAsFixed(2));
  final _note = TextEditingController();

  String? _accountId;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _amountError;

  bool get _isCustomer => widget.partyType == PartyType.customer;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  double? get _parsedAmount {
    final raw = _amount.text.trim().replaceAll(',', '');
    final v = double.tryParse(raw);
    if (v == null || v <= 0) return null;
    return v;
  }

  Future<void> _submit() async {
    final amount = _parsedAmount;
    if (amount == null) {
      setState(() => _amountError = 'أدخل مبلغاً أكبر من صفر');
      return;
    }
    // المقارنة بالأساسية: الدين معروض بها، فالمبلغ المُدخَل بعملة أخرى
    // يفحصه الخادم بسعره هو.
    if (_currencyId == null && amount > widget.debt.balance + 0.005) {
      setState(() => _amountError =
          'المبلغ يتجاوز الدين المتبقّي (${Formatters.number(widget.debt.balance)})');
      return;
    }
    if (_accountId == null || _accountId!.isEmpty) {
      AppSnackbar.error(context, 'اختر حساب الصندوق أو البنك');
      return;
    }

    setState(() {
      _saving = true;
      _amountError = null;
    });

    try {
      final settle = ref.read(settleDebtProvider);
      final result = await settle(SettleDebtInput(
        partyType: widget.partyType,
        partyId: widget.debt.partyId,
        amount: amount,
        paymentAccountId: _accountId!,
        currencyId: _currencyId,
        date: _date,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ));

      if (!mounted) return;
      Navigator.of(context).pop(true);
      AppSnackbar.success(
        context,
        result.remainingBalance <= 0
            ? 'تم التسديد كاملاً — لا دين متبقٍّ'
            : 'تم التسديد — المتبقّي ${Formatters.number(result.remainingBalance)}',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showFailureSnackbar(context, error);
    }
  }

  String? _currencyId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts = ref.watch(accountsListProvider).value ?? const [];
    final currencies = ref.watch(currenciesProvider).value ?? const [];
    final base = ref.watch(baseCurrencyProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(_isCustomer ? Icons.payments_outlined : Icons.outbox_outlined,
              color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              _isCustomer ? 'سند قبض' : 'سند دفع',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DebtSummary(name: debtName, balance: widget.debt.balance),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _amount,
                label: 'المبلغ المُسدَّد',
                keyboardType: TextInputType.number,
                errorText: _amountError,
                onChanged: (_) {
                  if (_amountError != null) setState(() => _amountError = null);
                },
              ),
              if (currencies.length > 1) ...[
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String?>(
                  initialValue: _currencyId,
                  decoration: const InputDecoration(labelText: 'عملة المبلغ'),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('${base?.code ?? ''} (الأساسية)'),
                    ),
                    for (final c in currencies.where((c) => c.id != base?.id))
                      DropdownMenuItem<String?>(value: c.id, child: Text(c.code)),
                  ],
                  onChanged: (v) => setState(() => _currencyId = v),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AccountPickerField(
                label: _isCustomer
                    ? 'حساب استلام المبلغ'
                    : 'حساب دفع المبلغ',
                accounts: accounts,
                selectedId: _accountId,
                onSelected: (a) => setState(() => _accountId = a.id),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DateField(
                date: _date,
                onPick: (d) => setState(() => _date = d),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _note, label: AppStrings.notes),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('تسديد'),
        ),
      ],
    );
  }

  String get debtName => widget.debt.partyName.isEmpty
      ? widget.partyType.label
      : widget.debt.partyName;
}

/// اسم الطرف ودينه الحالي — فلا يُسدَّد مبلغٌ دون رؤية ما عليه.
class _DebtSummary extends StatelessWidget {
  const _DebtSummary({required this.name, required this.balance});

  final String name;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppRadius.brSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('الدين الحالي', style: theme.textTheme.labelSmall),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  Formatters.number(balance),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onPick});

  final DateTime date;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.brSm,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          // لا تاريخ مستقبلي: يُفسد ترتيب الكشف والرصيد المتراكم، والخادم
          // يرفضه أيضاً.
          lastDate: DateTime.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'التاريخ',
          prefixIcon: Icon(Icons.event_outlined),
        ),
        child: Text(
          '${date.year}-${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}',
        ),
      ),
    );
  }
}
