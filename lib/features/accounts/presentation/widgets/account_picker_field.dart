import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/accounts/account_providers.dart';
import 'package:saydaliati/features/accounts/domain/entities/account.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_toolbar_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// حقل اختيار حساب بالبحث: يعرض الحساب المختار، وبالنقر يفتح بوب أب بحث —
/// كتابة رقم الحساب (أو أوّله) أو اسمه يُصفّي القائمة فوراً. نفس أسلوب
/// [MedicinePickerField]، يُستخدَم بالسندات وواجهة الفاتورة (مبيعات/مشتريات).
class AccountPickerField extends ConsumerWidget {
  const AccountPickerField({
    required this.accounts,
    required this.selectedId,
    required this.onSelected,
    this.label,
    this.hint,
    this.compact = false,
    this.leafOnly = true,
    super.key,
  });

  final List<Account> accounts;
  final String? selectedId;
  final ValueChanged<Account> onSelected;
  final String? label;
  final String? hint;

  /// نسخة شريط أدوات الفاتورة: نفس الحقل بارتفاع وحدّ وأيقونات موحّدة مع بقية
  /// عناصر الشريط ([AppToolbarField]). الافتراضي `false` فلا تتغيّر السندات
  /// وبقية الشاشات التي تستخدم الحقل بشكله الكامل.
  final bool compact;

  /// إخفاء الحسابات التي لها فروع — الحركة تقع على حساب ورقة فقط.
  ///
  /// «الصندوق» مثلاً أبٌ لفروع العملات، فاستلام الدفع عليه مباشرةً يجعل
  /// المبلغ يُحتسَب مرّتين: في رصيده المباشر وضمن تجميع فروعه. الباكند يرفض
  /// ذلك، وهذا يمنع وصول المستخدم إلى الاختيار الخاطئ من أصله.
  ///
  /// الافتراضي `true` لأن كل استعمالات هذا الحقل مواضعُ ترحيل.
  final bool leafOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = accounts.where((a) => a.id == selectedId).firstOrNull;
    final text = selected != null ? '${selected.code} — ${selected.name}' : null;

    // الأبوّة تُقرَّر من دليل الحسابات الكامل لا من القائمة الممرَّرة: قائمة
    // مُصفّاة مسبقاً (حسابات المصاريف مثلاً) قد لا تحوي أبناء حسابٍ فيها
    // فيبدو ورقةً وهو أب.
    final all = ref.watch(accountsListProvider).value ?? accounts;
    final options = leafOnly ? _leaves(accounts, all) : accounts;
    final hiddenParents = accounts.length - options.length;

    Future<void> pick() async {
      final picked = await showAccountPicker(context, options,
          hiddenParents: hiddenParents);
      if (picked != null) onSelected(picked);
    }

    if (compact) {
      return AppToolbarField(
        icon: Icons.account_balance_outlined,
        label: label,
        value: text,
        placeholder: hint ?? 'اختر حساباً',
        trailing: toolbarTrailingIcon(context, Icons.search),
        onTap: pick,
      );
    }

    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: pick,
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
          text ?? (hint ?? 'اختر حساباً'),
          overflow: TextOverflow.ellipsis,
          style: selected == null
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// الحسابات الورقية من [candidates] — أبٌ هو من ظهر مُعرّفه كـ parentId لأي
/// حساب في [all] (دليل الحسابات الكامل).
List<Account> _leaves(List<Account> candidates, List<Account> all) {
  final parentIds = <String>{
    for (final a in all)
      if (a.parentId != null && a.parentId!.isNotEmpty) a.parentId!,
  };
  return candidates.where((a) => !parentIds.contains(a.id)).toList();
}

/// بوب أب بحث عن حساب (بالرمز أو الاسم)، يُعاد التركيز للبحث تلقائياً.
Future<Account?> showAccountPicker(
  BuildContext context,
  List<Account> accounts, {
  int hiddenParents = 0,
}) {
  return showDialog<Account>(
    context: context,
    builder: (_) =>
        _AccountPickerDialog(accounts: accounts, hiddenParents: hiddenParents),
  );
}

class _AccountPickerDialog extends StatefulWidget {
  const _AccountPickerDialog({required this.accounts, this.hiddenParents = 0});

  final List<Account> accounts;

  /// عدد الحسابات الأب المُستبعَدة — يُفسَّر للمستخدم بدل الإخفاء الصامت.
  final int hiddenParents;

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
              if (widget.hiddenParents > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 14, color: theme.hintColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'الحسابات التي لها فروع غير معروضة — الحركة تقع على '
                        'حساب فرعي.',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ],
                ),
              ],
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
                            shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
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
