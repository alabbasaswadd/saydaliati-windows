import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/network/server_capabilities.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';
import 'package:saydaliati/features/vouchers/domain/entities/voucher.dart';
import 'package:saydaliati/features/vouchers/voucher_providers.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// صفحة إدخال السندات بنظام التابات — تُفتح من قائمة السندات عند ضغط «سند
/// جديد». يمكن فتح عدة سندات جديدة في آنٍ واحد عبر زر «+»؛ كل تاب يحتفظ
/// بحالته الخاصة حتى يُحفَظ أو يُغلَق.
class VoucherEntryPage extends ConsumerStatefulWidget {
  const VoucherEntryPage({super.key});

  @override
  ConsumerState<VoucherEntryPage> createState() => _VoucherEntryPageState();
}

class _VoucherEntryPageState extends ConsumerState<VoucherEntryPage> {
  final List<int> _tabIds = [1];
  int _nextId = 2;
  int _activeIndex = 0;

  void _addTab() => setState(() {
        _tabIds.add(_nextId++);
        _activeIndex = _tabIds.length - 1;
      });

  void _closeTab(int index) {
    if (_tabIds.length == 1) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _tabIds.removeAt(index);
      if (_activeIndex >= _tabIds.length) {
        _activeIndex = _tabIds.length - 1;
      } else if (_activeIndex > index) {
        _activeIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدخال السندات'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _buildTabStrip(context),
        ),
      ),
      body: IndexedStack(
        index: _activeIndex,
        children: [
          for (var i = 0; i < _tabIds.length; i++)
            _VoucherEntryForm(
              key: ValueKey(_tabIds[i]),
              onClose: () => _closeTab(i),
            ),
        ],
      ),
    );
  }

  Widget _buildTabStrip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < _tabIds.length; i++)
                  _buildTabChip(theme, i),
              ],
            ),
          ),
          IconButton(
            tooltip: 'سند جديد',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 18),
            onPressed: _addTab,
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(ThemeData theme, int index) {
    final selected = index == _activeIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: Material(
        color: selected ? theme.colorScheme.surface : Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: InkWell(
          onTap: () => setState(() => _activeIndex = index),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 160),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary.withValues(alpha: 0.35)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'سند ${index + 1}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
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

// ─────────────────────────────────────────────────────────────────────────────

/// نموذج سند مضمَّن داخل تاب — نفس منطق حوار السند مع فارقين:
/// 1. بعد الحفظ: يُصفَّر النموذج (لا يُغلَق) + تُعرَض رسالة نجاح.
/// 2. زر «إغلاق» يغلق التاب لا الحوار.
class _VoucherEntryForm extends ConsumerStatefulWidget {
  const _VoucherEntryForm({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  ConsumerState<_VoucherEntryForm> createState() => _VoucherEntryFormState();
}

class _VoucherEntryFormState extends ConsumerState<_VoucherEntryForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  DateTime? _date = DateTime.now();
  String? _debitAccountId;
  String? _creditAccountId;
  String? _currencyId;
  String? _lastSuggestedCurrencyId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _suggestCurrencyForAccount(String? accountId) {
    final untouched =
        _currencyId == null || _currencyId == _lastSuggestedCurrencyId;
    if (!untouched) return;

    final accounts =
        ref.read(accountsListProvider).value ?? const <Account>[];
    final account = accounts.where((a) => a.id == accountId).firstOrNull;
    if (account == null) return;

    _lastSuggestedCurrencyId = account.currencyId;
    _currencyId = account.currencyId;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _descriptionController.clear();
    _amountController.clear();
    setState(() {
      _date = DateTime.now();
      _debitAccountId = null;
      _creditAccountId = null;
      _currencyId = null;
      _lastSuggestedCurrencyId = null;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_date == null || _debitAccountId == null || _creditAccountId == null) {
      return;
    }
    if (_debitAccountId == _creditAccountId) {
      AppSnackbar.error(context, 'لا يمكن اختيار نفس الحساب للطرفين');
      return;
    }

    final enteredAmount =
        double.tryParse(_amountController.text.trim()) ?? 0;

    final base = ref.read(baseCurrencyProvider);
    final currencies =
        ref.read(currenciesProvider).value ?? const <Currency>[];
    final selected =
        currencies.where((c) => c.id == _currencyId).firstOrNull;
    final serverConverts = ref.read(serverCapabilitiesProvider).value
            ?.amountsInOriginalCurrency ==
        true;
    final amount = serverConverts
        ? enteredAmount
        : convertToBase(enteredAmount, base, selected);

    setState(() => _saving = true);

    final result =
        await ref.read(voucherRepositoryProvider).create(CreateVoucherInput(
              date: _date!,
              description: _descriptionController.text.trim(),
              debitAccountId: _debitAccountId!,
              creditAccountId: _creditAccountId!,
              amount: amount,
              currencyId: serverConverts ? _currencyId : null,
            ));

    if (!mounted) return;
    result.fold(
      (_) {
        ref.invalidate(vouchersListProvider);
        AppSnackbar.success(context, AppStrings.createdSuccess);
        setState(() => _saving = false);
        _resetForm();
      },
      (failure) {
        setState(() => _saving = false);
        showFailureSnackbar(context, failure);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts =
        ref.watch(accountsListProvider).value ?? const <Account>[];

    return SaveShortcut(
      onSave: _submit,
      enabled: !_saving,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── رأس القسم ──
                  Row(
                    children: [
                      Icon(Icons.description_outlined,
                          color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text('سند جديد',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _saving ? null : widget.onClose,
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('إغلاق'),
                        style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error),
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
                    accounts: accounts,
                    selectedId: _debitAccountId,
                    onSelected: (a) => setState(() {
                      _debitAccountId = a.id;
                      _suggestCurrencyForAccount(a.id);
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AccountPickerField(
                    label: 'إلى حساب (دائن)',
                    accounts: accounts,
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                  const SizedBox(height: AppSpacing.xl),
                  // ── أزرار التحكم ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 112,
                        height: 36,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            textStyle: theme.textTheme.bodyMedium,
                          ),
                          onPressed: _saving ? null : _resetForm,
                          child: const Text('تفريغ'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 112,
                        height: 36,
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
                              : const Text('حفظ السند'),
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
    );
  }
}
