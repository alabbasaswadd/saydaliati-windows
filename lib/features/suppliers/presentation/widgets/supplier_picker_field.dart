import 'package:flutter/material.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// حقل اختيار مورّد بالبحث: يعرض المورّد المختار، وبالنقر يفتح بوب أب بحث —
/// كتابة الاسم تُصفّي القائمة فوراً. نفس أسلوب [AccountPickerField]، يُستخدَم
/// بواجهة فاتورة المشتريات.
class SupplierPickerField extends StatelessWidget {
  const SupplierPickerField({
    required this.suppliers,
    required this.selectedId,
    required this.onSelected,
    this.label,
    this.hint,
    this.allowClear = false,
    this.onCleared,
    super.key,
  });

  final List<Supplier> suppliers;
  final String? selectedId;
  final ValueChanged<Supplier> onSelected;
  final String? label;
  final String? hint;

  /// يعرض زر مسح الاختيار (رجوع لـ"بلا مورّد") — المورّد اختياري بالشراء.
  final bool allowClear;
  final VoidCallback? onCleared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = suppliers.where((s) => s.id == selectedId).firstOrNull;

    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: () async {
        final picked = await showSupplierPicker(context, suppliers);
        if (picked != null) onSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.local_shipping_outlined),
          suffixIcon: allowClear && selected != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onCleared,
                )
              : const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: Icon(Icons.search),
                ),
        ),
        child: Text(
          selected != null ? selected.name : (hint ?? 'اختر مورّداً'),
          overflow: TextOverflow.ellipsis,
          style: selected == null
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// بوب أب بحث عن مورّد بالاسم، يُعاد التركيز للبحث تلقائياً.
Future<Supplier?> showSupplierPicker(BuildContext context, List<Supplier> suppliers) {
  return showDialog<Supplier>(
    context: context,
    builder: (_) => _SupplierPickerDialog(suppliers: suppliers),
  );
}

class _SupplierPickerDialog extends StatefulWidget {
  const _SupplierPickerDialog({required this.suppliers});

  final List<Supplier> suppliers;

  @override
  State<_SupplierPickerDialog> createState() => _SupplierPickerDialogState();
}

class _SupplierPickerDialogState extends State<_SupplierPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.suppliers
        : widget.suppliers.where((s) => s.name.toLowerCase().contains(q)).toList();
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
                  Icon(Icons.local_shipping_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('اختر مورّداً',
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
                hint: 'ابحث بالاسم',
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(message: 'لا يوجد موردون مطابقون')
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final s = items[i];
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  theme.colorScheme.primary.withValues(alpha: 0.10),
                              child: Text(
                                s.name.isNotEmpty ? s.name.substring(0, 1) : '#',
                                style: TextStyle(
                                    fontSize: 11, color: theme.colorScheme.primary),
                              ),
                            ),
                            title:
                                Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle:
                                s.contactPerson.isNotEmpty ? Text(s.contactPerson) : null,
                            onTap: () => Navigator.of(context).pop(s),
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
