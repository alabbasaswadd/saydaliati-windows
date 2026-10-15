import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_toolbar_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// حقل اختيار عملة بالبحث: يعرض العملة المختارة، وبالنقر يفتح بوب أب بحث —
/// كتابة الرمز أو الاسم تُصفّي القائمة فوراً. نفس أسلوب [AccountPickerField]،
/// يُستخدَم بواجهة فاتورة المبيعات والمشتريات.
class CurrencyPickerField extends StatelessWidget {
  const CurrencyPickerField({
    required this.currencies,
    required this.selectedId,
    required this.onSelected,
    this.label,
    this.hint,
    this.compact = false,
    super.key,
  });

  final List<Currency> currencies;
  final String? selectedId;
  final ValueChanged<Currency> onSelected;
  final String? label;
  final String? hint;

  /// نسخة شريط أدوات الفاتورة: نفس الحقل بارتفاع وحدّ وأيقونات موحّدة مع بقية
  /// عناصر الشريط ([AppToolbarField]). الافتراضي `false` فلا تتغيّر الشاشات
  /// الأخرى التي تستخدم الحقل بشكله الكامل.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = currencies.where((c) => c.id == selectedId).firstOrNull;
    final text =
        selected != null ? '${selected.code} — ${selected.name}' : null;

    Future<void> pick() async {
      final picked = await showCurrencyPicker(context, currencies);
      if (picked != null) onSelected(picked);
    }

    if (compact) {
      return AppToolbarField(
        icon: Icons.payments_outlined,
        label: label,
        value: text,
        placeholder: hint ?? 'اختر عملة',
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
          prefixIcon: const Icon(Icons.payments_outlined),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(Icons.search),
          ),
        ),
        child: Text(
          text ?? (hint ?? 'اختر عملة'),
          overflow: TextOverflow.ellipsis,
          style: selected == null
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// بوب أب بحث عن عملة (بالرمز أو الاسم)، يُعاد التركيز للبحث تلقائياً.
Future<Currency?> showCurrencyPicker(BuildContext context, List<Currency> currencies) {
  return showDialog<Currency>(
    context: context,
    builder: (_) => _CurrencyPickerDialog(currencies: currencies),
  );
}

class _CurrencyPickerDialog extends StatefulWidget {
  const _CurrencyPickerDialog({required this.currencies});

  final List<Currency> currencies;

  @override
  State<_CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends State<_CurrencyPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.currencies
        : widget.currencies
            .where((c) =>
                c.code.toLowerCase().contains(q) || c.name.toLowerCase().contains(q))
            .toList();
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420, maxHeight: size.height * 0.6),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('اختر عملة',
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
                    ? const EmptyState(message: 'لا توجد عملات مطابقة')
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final c = items[i];
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  theme.colorScheme.primary.withValues(alpha: 0.10),
                              child: Text(
                                c.code.isNotEmpty ? c.code.substring(0, 1) : '#',
                                style: TextStyle(
                                    fontSize: 11, color: theme.colorScheme.primary),
                              ),
                            ),
                            title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(c.code),
                            onTap: () => Navigator.of(context).pop(c),
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
