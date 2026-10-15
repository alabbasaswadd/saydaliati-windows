import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// حوار إضافة/تعديل حساب — بأسلوب نوافذ ويندوز، والحفظ داخل الحوار نفسه
/// (مؤشّر تحميل على زر الحفظ، يُغلَق فقط عند النجاح) — نفس نمط حوار المصروف.
Future<bool?> showAccountFormDialog(
  BuildContext context, {
  required List<Account> accounts,
  Account? existing,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AccountFormDialog(accounts: accounts, existing: existing),
  );
}

class _AccountFormDialog extends ConsumerStatefulWidget {
  const _AccountFormDialog({required this.accounts, this.existing});

  final List<Account> accounts;
  final Account? existing;

  @override
  ConsumerState<_AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends ConsumerState<_AccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late final _codeController = TextEditingController(text: widget.existing?.code ?? '');

  String? _parentId;
  AccountType _accountType = AccountType.asset;
  String? _currencyId;
  bool _saving = false;

  /// آخر رقم اقترحناه تلقائياً — يُستخدَم لتمييز "لم يُلمَس" عن "المستخدم
  /// كتب نفس الرقم يدوياً"، فنستطيع تحديث الاقتراح عند تبديل الأب أكثر من
  /// مرة دون أن نخاطر بمحو رقم أدخله المستخدم بنفسه.
  String? _lastSuggestedCode;

  @override
  void initState() {
    super.initState();
    _parentId = widget.existing?.parentId;
    _accountType = widget.existing?.accountType ?? AccountType.asset;
    _currencyId = widget.existing?.currencyId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// يقترح رقم الحساب من أرقام أبناء الأب المختار: أكبر رقم بينهم + 1، أو
  /// (رقم الأب + 1) إن كان هذا أول ابن له. لا يُستدعى عند التعديل — فقط حساب
  /// جديد، وفقط إن لم يكتب المستخدم رقماً يدوياً بعد.
  void _suggestCodeForParent(String? parentId) {
    if (widget.existing != null) return; // لا نُغيّر رقماً موجوداً بالتعديل

    final current = _codeController.text.trim();
    final untouched = current.isEmpty || current == _lastSuggestedCode;
    if (!untouched) return; // المستخدم كتب رقماً بنفسه — لا نلمسه

    if (parentId == null) return;
    final parent = widget.accounts.where((a) => a.id == parentId).firstOrNull;
    if (parent == null) return;

    final siblingCodes = widget.accounts
        .where((a) => a.parentId == parentId)
        .map((a) => int.tryParse(a.code))
        .whereType<int>()
        .toList();

    final parentCode = int.tryParse(parent.code);
    final suggested = siblingCodes.isNotEmpty
        ? (siblingCodes.reduce((a, b) => a > b ? a : b) + 1)
        : (parentCode != null ? parentCode + 1 : null);

    if (suggested == null) return;
    _lastSuggestedCode = suggested.toString();
    _codeController.text = _lastSuggestedCode!;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final repo = ref.read(accountRepositoryProvider);
    final input = AccountInput(
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      parentId: _parentId,
      accountType: _accountType,
      isActive: widget.existing?.isActive ?? true,
      currentBalance: widget.existing?.currentBalance ?? 0,
      currencyId: _currencyId,
    );
    final result = widget.existing == null
        ? await repo.create(input)
        : await repo.update(widget.existing!.id, input);

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
    // لا يمكن جعل الحساب أباً لنفسه.
    final parentOptions = widget.accounts.where((a) => a.id != widget.existing?.id).toList();

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
                      Icon(Icons.account_balance_outlined,
                          color: theme.colorScheme.primary, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            isEdit ? 'تعديل حساب' : 'إضافة حساب',
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
                  AppTextField(
                    controller: _nameController,
                    label: 'اسم الحساب',
                    isRequired: true,
                    enabled: !_saving,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppDropdown<String?>(
                    label: 'الحساب الأب (اختياري)',
                    enabled: !_saving,
                    value: _parentId,
                    items: [
                      const AppDropdownItem<String?>(value: null, label: 'بلا'),
                      for (final a in parentOptions)
                        AppDropdownItem(value: a.id, label: '${a.code} — ${a.name}'),
                    ],
                    onChanged: (v) => setState(() {
                      _parentId = v;
                      _suggestCodeForParent(v);
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _codeController,
                    label: 'رقم الحساب',
                    hint: 'يُقترَح تلقائياً عند اختيار الأب — يمكن تعديله',
                    isRequired: true,
                    enabled: !_saving,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppDropdown<AccountType>(
                    label: 'نوع الحساب',
                    isRequired: true,
                    enabled: !_saving,
                    value: _accountType,
                    items: [
                      for (final t in AccountType.values)
                        AppDropdownItem(value: t, label: t.label),
                    ],
                    onChanged: (v) => setState(() => _accountType = v ?? _accountType),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Builder(builder: (_) {
                    final currencies =
                        ref.watch(currenciesProvider).value ?? const [];
                    return AppDropdown<String?>(
                      label: 'عملة الحساب (اختياري)',
                      enabled: !_saving,
                      value: _currencyId,
                      items: [
                        const AppDropdownItem<String?>(value: null, label: 'بلا'),
                        for (final c in currencies)
                          AppDropdownItem(value: c.id, label: '${c.code} — ${c.name}'),
                      ],
                      onChanged: (v) => setState(() => _currencyId = v),
                    );
                  }),
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
