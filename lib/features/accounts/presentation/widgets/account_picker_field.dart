import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// حقل اختيار حساب بالبحث: يعرض الحساب المختار، وبالنقر يفتح بوب أب بحث —
/// كتابة رقم الحساب (أو أوّله) أو اسمه يُصفّي القائمة فوراً. نفس أسلوب
/// [MedicinePickerField]، يُستخدَم بالسندات وواجهة الفاتورة (مبيعات/مشتريات).
class AccountPickerField extends StatelessWidget {
  const AccountPickerField({
    required this.accounts,
    required this.selectedId,
    required this.onSelected,
    this.label,
    this.hint,
    super.key,
  });

  final List<Account> accounts;
  final String? selectedId;
  final ValueChanged<Account> onSelected;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = accounts.where((a) => a.id == selectedId).firstOrNull;

    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: () async {
        final picked = await showAccountPicker(context, accounts);
        if (picked != null) onSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.account_balance_outlined),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(Icons.search),
          ),
        ),
        child: Text(
          selected != null ? '${selected.code} — ${selected.name}' : (hint ?? 'اختر حساباً'),
          overflow: TextOverflow.ellipsis,
          style: selected == null
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// بوب أب بحث عن حساب (بالرمز أو الاسم)، يُعاد التركيز للبحث تلقائياً.
Future<Account?> showAccountPicker(BuildContext context, List<Account> accounts) {
  return showDialog<Account>(
    context: context,
    builder: (_) => _AccountPickerDialog(accounts: accounts),
  );
}

class _AccountPickerDialog extends StatefulWidget {
  const _AccountPickerDialog({required this.accounts});

  final List<Account> accounts;

  @override
  State<_AccountPickerDialog> createState() => _AccountPickerDialogState();
}

class _AccountPickerDialogState extends State<_AccountPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.accounts
        : widget.accounts
            .where((a) =>
                a.code.toLowerCase().startsWith(q) ||
                a.code.toLowerCase().contains(q) ||
                a.name.toLowerCase().contains(q))
            .toList();
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: size.height * 0.72),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('اختر حساباً',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppSearchField(
                hint: 'ابحث بالرمز أو الاسم',
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(message: 'لا توجد حسابات مطابقة')
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final a = items[i];
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  theme.colorScheme.primary.withValues(alpha: 0.10),
                              child: Text(
                                a.code.isNotEmpty ? a.code.substring(0, 1) : '#',
                                style: TextStyle(
                                    fontSize: 11, color: theme.colorScheme.primary),
                              ),
                            ),
                            title: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(a.code),
                            onTap: () => Navigator.of(context).pop(a),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
