import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/features/accounts/presentation/widgets/account_picker_field.dart';
import 'package:saydaliati/features/expenses/domain/entities/expense_category.dart';
import 'package:saydaliati/features/shortcuts/presentation/widgets/save_shortcut.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// نتيجة نموذج تصنيف المصروف.
class ExpenseCategoryFormResult {
  const ExpenseCategoryFormResult({required this.name, this.accountId});

  final String name;

  /// `null` يعني «بلا ربط» — مصاريف هذا التصنيف لن تمسّ الحسابات.
  final String? accountId;
}

Future<ExpenseCategoryFormResult?> showExpenseCategoryForm(
  BuildContext context, {
  ExpenseCategory? existing,
}) {
  return showDialog<ExpenseCategoryFormResult>(
    context: context,
    builder: (_) => _ExpenseCategoryFormDialog(existing: existing),
  );
}

/// نموذج تصنيف المصروف: الاسم + **الحساب المرتبط**.
///
/// الربط هو ما يجعل المصروف يؤثّر على الحسابات فعلاً: تصنيف مربوط بحساب
/// يُنشئ لكل مصروف قيداً (مدين حساب المصروف / دائن الصندوق) فينقص رصيد
/// الصندوق؛ وغير المربوط يبقى تتبّعاً بحتاً. لذلك الشاشة تقول ذلك صراحةً بدل
/// أن يكتشفه المستخدم بعد أن يسجّل مصاريف شهر كامل بلا أثر محاسبي.
class _ExpenseCategoryFormDialog extends ConsumerStatefulWidget {
  const _ExpenseCategoryFormDialog({this.existing});

  final ExpenseCategory? existing;

  @override
  ConsumerState<_ExpenseCategoryFormDialog> createState() =>
      _ExpenseCategoryFormDialogState();
}

class _ExpenseCategoryFormDialogState
    extends ConsumerState<_ExpenseCategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late String? _accountId = widget.existing?.accountId;

  /// اقتُرح الحساب تلقائياً بمطابقة الاسم؟ يُعرَض للمستخدم ليعلم أنه اقتراح.
  bool _suggested = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// حسابات المصروفات وحدها — ربط الإيجار بحساب «الصندوق» مثلاً خطأ محاسبي.
  List<Account> _expenseAccounts(List<Account> all) =>
      all.where((a) => a.accountType == AccountType.expense).toList();

  /// اقتراح بالاسم: «إيجار المحل» ← حساب «الإيجار». اقتراح لا أكثر — المستخدم
  /// هو من يعتمده بالحفظ (قرار EXPENSES_PLAN.md §0.3: لا ربط تلقائي صامت).
  void _suggestByName(List<Account> accounts) {
    if (_accountId != null) return;
    final name = _nameController.text.trim();
    if (name.length < 3) return;

    for (final a in _expenseAccounts(accounts)) {
      if (name.contains(a.name) || a.name.contains(name)) {
        setState(() {
          _accountId = a.id;
          _suggested = true;
        });
        return;
      }
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(ExpenseCategoryFormResult(
      name: _nameController.text.trim(),
      accountId: _accountId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accounts = ref.watch(accountsListProvider).value ?? const <Account>[];
    final expenseAccounts = _expenseAccounts(accounts);
    final isEdit = widget.existing != null;

    return SaveShortcut(
      onSave: _submit,
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category_outlined,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          isEdit
                              ? AppStrings.editExpenseCategory
                              : AppStrings.addExpenseCategory,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  AppTextField(
                    controller: _nameController,
                    label: AppStrings.expenseCategoryName,
                    isRequired: true,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.requiredField
                        : null,
                    onChanged: (_) => _suggestByName(accounts),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text('الحساب المرتبط (اختياري)',
                      style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  AccountPickerField(
                    label: 'حساب المصروف',
                    hint: 'بلا ربط — لا يؤثّر على الحسابات',
                    accounts: expenseAccounts,
                    selectedId: _accountId,
                    onSelected: (a) => setState(() {
                      _accountId = a.id;
                      _suggested = false;
                    }),
                  ),
                  if (_accountId != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () => setState(() {
                          _accountId = null;
                          _suggested = false;
                        }),
                        icon: const Icon(Icons.link_off, size: AppSizes.iconXs),
                        label: const Text('إزالة الربط'),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),
                  _Explainer(linked: _accountId != null, suggested: _suggested),

                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(AppStrings.cancel),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton(
                        onPressed: _submit,
                        child: const Text(AppStrings.save),
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

/// يشرح أثر الربط بعبارة واحدة تتغيّر بحسب الحالة.
class _Explainer extends StatelessWidget {
  const _Explainer({required this.linked, required this.suggested});

  final bool linked;
  final bool suggested;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = linked ? context.semantic.success : context.semantic.warning;
    final text = linked
        ? (suggested
            ? 'اقتُرح هذا الحساب بمطابقة الاسم — غيّره إن لم يكن المقصود. '
                'مصاريف هذا التصنيف ستُنشئ قيداً وتُنقِص رصيد حساب الدفع.'
            : 'مصاريف هذا التصنيف ستُنشئ قيداً محاسبياً: مدين هذا الحساب، '
                'دائن حساب الدفع — فينقص رصيد الصندوق فعلياً.')
        : 'بلا ربط: المصاريف ستُسجَّل للمتابعة فقط ولن تمسّ أرصدة الحسابات '
            'ولن يظهر لها سند قيد.';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: AppRadius.brSm,
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(linked ? Icons.check_circle_outline : Icons.info_outline,
              size: AppSizes.iconSm, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
