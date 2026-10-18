import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
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

  @override
  void initState() {
    super.initState();
    // سطر «يعادل …» يتبع الكتابة حرفاً بحرف، فالرقم المكتوب تُرى قيمته
    // بالأساسية قبل الحفظ لا بعده.
    _amount.addListener(_onAmountTyped);
  }

  void _onAmountTyped() {
    if (_currencyId != null) setState(() {});
  }

  bool get _isCustomer => widget.partyType == PartyType.customer;

  @override
  void dispose() {
    _amount.removeListener(_onAmountTyped);
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
    // السقف يُفحَص **بالأساسية دائماً** لا بالأساسية وحدها كما كان: الدين
    // مُمسَك بالأساسية، والمبلغ بعملةٍ أخرى يُقارَن بعد تحويله. وكان الفحص
    // يُتخطّى كلّما اختيرت عملةٌ أجنبية، فيصل الخادمَ مبلغٌ يفوق الدين
    // ويُردّ برسالةٍ بعد انتظار الشبكة — والخطأ كان قابلاً للكشف فوراً.
    if (_amountInBase(amount) > widget.debt.balance + _toleranceInBase) {
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

  /// آخر حسابٍ اقترحناه — به نعرف أن المستخدم لم يختر بنفسه بعد.
  String? _lastSuggestedAccountId;

  /// حسابات النقد: أبناء «الصندوق» وحساب «البنك».
  ///
  /// الاقتراح لا يجوز أن يجول في الدليل كلّه: أوّل حسابٍ بالعملة المطلوبة قد
  /// يكون حساب عميلٍ أو مصروف، فيُرحَّل القبض إلى المكان الخطأ بلا أن ينتبه
  /// أحد. وبنية الدليل معروفة: «١١٠١» أبٌ لصناديق العملات، و«١١٠٢» البنك.
  List<Account> _cashAccounts(List<Account> all) {
    final cashParent = all.where((a) => a.code == '1101').firstOrNull;
    final bank = all.where((a) => a.code == '1102').firstOrNull;
    final parents = {
      if (cashParent != null) cashParent.id,
      if (bank != null) bank.id,
    };
    final hasChildren = <String>{for (final a in all) ?a.parentId};
    return [
      for (final a in all)
        if (!hasChildren.contains(a.id) &&
            (parents.contains(a.parentId) ||
                (bank != null && a.id == bank.id)))
          a,
    ];
  }

  /// يختار حساب القبض/الدفع المطابق لعملة المبلغ.
  ///
  /// قبضُ دولاراتٍ في صندوق الليرة يُفسد رصيد الصندوقين معاً، والمستخدم لا
  /// يرى الخطأ إلّا عند الجرد. فمتى بدّل العملة تبعها الحساب — ما لم يكن قد
  /// اختار حساباً بنفسه، فاختياره أولى من اقتراحنا.
  void _suggestAccountForCurrency(List<Account> all, Currency? base) {
    final untouched =
        _accountId == null || _accountId == _lastSuggestedAccountId;
    if (!untouched) return;

    final cash = _cashAccounts(all);
    if (cash.isEmpty) return;

    final wanted = _currencyId ?? base?.id;
    final match = cash.where((a) => a.currencyId == wanted).firstOrNull;
    final fallback = cash.where((a) => a.currencyId == base?.id).firstOrNull;
    final suggested = match ?? fallback;
    if (suggested == null || suggested.id == _accountId) return;

    _lastSuggestedAccountId = suggested.id;
    _accountId = suggested.id;
  }

  /// تنبيهٌ حين تختلف عملة الحساب عن عملة المبلغ — لا منع: قد يكون المقصود.
  String? _accountCurrencyWarning(List<Account> all, Currency? base) {
    final account = all.where((a) => a.id == _accountId).firstOrNull;
    if (account == null || account.currencyId == null) return null;
    final wanted = _currencyId ?? base?.id;
    if (wanted == null || account.currencyId == wanted) return null;
    return 'عملة الحساب (${account.currencyCode ?? ''}) تخالف عملة المبلغ';
  }

  /// عملة الإدخال الحالية — `null` في القائمة تعني الأساسية.
  Currency? _selectedCurrency(List<Currency> currencies, Currency? base) =>
      _currencyId == null
          ? base
          : currencies.where((c) => c.id == _currencyId).firstOrNull;

  /// هامش المقارنة بالأساسية.
  ///
  /// الخانتان العشريتان في الدولار تساويان ١٤٤ ل.س تقريباً، فهامشُ نصف قرشٍ
  /// بالأساسية يجعل كل تسديدٍ كاملٍ بعملةٍ أجنبية «يتجاوز الدين». الهامش هنا
  /// = أصغر كسرٍ في عملة الإدخال محوَّلاً إلى الأساسية — فيتّسع بسعة الخطأ
  /// الذي يُحدثه التقريب نفسه، ويبقى ضيّقاً بالأساسية.
  double get _toleranceInBase {
    final unit = _amountInBase(0.01);
    return unit > 0.005 ? unit : 0.005;
  }

  /// المبلغ المكتوب محوَّلاً إلى الأساسية — وحدةُ القياس التي يُمسَك بها
  /// الدين ويُقارَن بها السقف.
  double _amountInBase(double typed) {
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    return convertToBase(typed, base, _selectedCurrency(currencies, base));
  }

  /// تبديل عملة المبلغ: يُحوَّل المكتوب بسعر الصرف بدل أن يبقى رقماً جامداً.
  ///
  /// مَن كتب ٥٠٠٠٠٠ ليرة ثم بدّل إلى الدولار يقصد **ما يعادلها**، لا خمسمئة
  /// ألف دولار. وكان الرقم يبقى كما هو فيُسدَّد ضعفُ الدين آلاف المرّات بتبديل
  /// حقلٍ واحد. والتحويل أمام عينه يُظهر سعر الصرف المطبَّق قبل الحفظ.
  void _changeCurrency(String? newId) {
    final base = ref.read(baseCurrencyProvider);
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final from = _selectedCurrency(currencies, base);
    final to = newId == null
        ? base
        : currencies.where((c) => c.id == newId).firstOrNull;

    setState(() {
      _currencyId = newId;
      _amountError = null;

      if (from == null || to == null || from.id == to.id) return;
      final typed = double.tryParse(_amount.text.trim().replaceAll(',', ''));
      if (typed == null || typed == 0) return;

      // من عملةٍ إلى أخرى عبر الأساسية — نفس مسار بقية التحويلات.
      final converted = convertFromBase(convertToBase(typed, base, from), base, to);
      // **للأسفل** لا تقريباً معتاداً: ٧٫٦٣٨٨$ تُقرَّب إلى ٧٫٦٤$، وهي عند
      // العودة ١١٠٠٫١٦ ل.س على دينٍ قدره ١١٠٠ — فيُرفَض تبديلُ عملةٍ لم
      // يُغيّر المستخدم فيه رقماً. القصّ يُبقيه دون الدين دائماً.
      final cut = (converted * 100).floorToDouble() / 100;
      // مبلغٌ أصغر من قرشٍ واحد يُقصّ إلى صفر، فيُترَك كما هو.
      _amount.text = (cut <= 0 ? converted : cut).toStringAsFixed(2);
      _amount.selection =
          TextSelection.collapsed(offset: _amount.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts = ref.watch(accountsListProvider).value ?? const [];
    final currencies = ref.watch(currenciesProvider).value ?? const [];
    final base = ref.watch(baseCurrencyProvider);
    _suggestAccountForCurrency(accounts, base);
    final accountWarning = _accountCurrencyWarning(accounts, base);

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
                  onChanged: _saving ? null : _changeCurrency,
                ),
                if (_currencyId != null) _EquivalentLine(
                  text: _equivalentText(currencies, base),
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
              if (accountWarning != null)
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppSpacing.xs, right: AppSpacing.xs),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 14, color: theme.colorScheme.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          accountWarning,
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              _DateTimeField(
                value: _date,
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

  /// «٥٠٫٠٠ USD ‎=‎ ٣٦٠٬٠٠٠ ل.س» — السطر الذي يُطمئن المستخدم إلى سعر الصرف
  /// المطبَّق فعلاً قبل أن يحفظ.
  String _equivalentText(List<Currency> currencies, Currency? base) {
    final typed = double.tryParse(_amount.text.trim().replaceAll(',', ''));
    final selected = _selectedCurrency(currencies, base);
    if (typed == null || typed <= 0 || selected == null || base == null) {
      return 'يُحفظ السند بالعملة الأساسية بعد التحويل';
    }
    final inBase = convertToBase(typed, base, selected);
    return '${Formatters.number(typed)} ${selected.code}'
        ' = ${Formatters.number(inBase)} ${base.code}';
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

/// تاريخ الاستلام **ووقته** — لا التاريخ وحده.
///
/// السند يُقيَّد بلحظته: صيدليةٌ تقبض من عميلين في يومٍ واحد تحتاج ترتيبهما
/// في الكشف، وتاريخٌ بلا وقت يجعل حركات اليوم كلّها عند منتصف الليل بترتيبٍ
/// عشوائيّ بينها. والافتراضي لحظةُ فتح الحوار، فالحالة الغالبة قبضٌ الآن
/// يُحفظ بلا أن يُلمَس الحقل.
class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.value, required this.onPick});

  final DateTime value;
  final ValueChanged<DateTime> onPick;

  Future<void> _pick(BuildContext context) async {
    final day = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(2020),
      // لا تاريخ مستقبلي: يُفسد ترتيب الكشف والرصيد المتراكم، والخادم
      // يرفضه أيضاً.
      lastDate: DateTime.now(),
    );
    if (day == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );
    // إلغاء اختيار الوقت لا يُلغي اختيار اليوم: يُحتفَظ بالوقت القديم.
    final t = time ?? TimeOfDay.fromDateTime(value);

    var picked = DateTime(day.year, day.month, day.day, t.hour, t.minute);
    // ساعةٌ لم تأتِ بعد من يومنا هذا تُردّ إلى الآن بدل أن تُرفَض بعد الحفظ.
    final now = DateTime.now();
    if (picked.isAfter(now)) picked = now;
    onPick(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNow = DateTime.now().difference(value).inMinutes.abs() < 1;

    return InkWell(
      borderRadius: AppRadius.brSm,
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'تاريخ الاستلام ووقته',
          prefixIcon: const Icon(Icons.event_outlined),
          // «الآن» تعيد اللحظة الحالية بنقرة — أسرع من مرور مُنتقيين.
          suffixIcon: isNow
              ? null
              : IconButton(
                  tooltip: 'الآن',
                  icon: const Icon(Icons.restore, size: 18),
                  onPressed: () => onPick(DateTime.now()),
                ),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppDate.ymdHm(value),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}

/// سطر المعادل أسفل حقل المبلغ — هادئ، لا يُزاحم الحقل ولا يُشبه الخطأ.
class _EquivalentLine extends StatelessWidget {
  const _EquivalentLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, right: AppSpacing.xs),
      child: Row(
        children: [
          Icon(Icons.swap_horiz_rounded,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
