import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/shared/widgets/dialogs/entity_form_dialog.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_toolbar_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// حقل اختيار عميل بالبحث: يعرض العميل المختار، وبالنقر يفتح بوب أب بحث —
/// كتابة الاسم أو الهاتف تُصفّي القائمة فوراً. نفس أسلوب [AccountPickerField]،
/// يُستخدَم بواجهة فاتورة المبيعات.
class CustomerPickerField extends StatelessWidget {
  const CustomerPickerField({
    required this.customers,
    required this.selectedId,
    required this.onSelected,
    this.label,
    this.hint,
    this.allowClear = false,
    this.onCleared,
    this.compact = false,
    super.key,
  });

  final List<Customer> customers;
  final String? selectedId;
  final ValueChanged<Customer> onSelected;
  final String? label;
  final String? hint;

  /// يعرض زر مسح الاختيار (رجوع لـ"بلا عميل") — مفيد حيث العميل اختياري.
  final bool allowClear;
  final VoidCallback? onCleared;

  /// نسخة شريط أدوات الفاتورة: نفس الحقل بارتفاع وحدّ وأيقونات موحّدة مع بقية
  /// عناصر الشريط ([AppToolbarField]). الافتراضي `false` فلا تتغيّر الشاشات
  /// الأخرى التي تستخدم الحقل بشكله الكامل.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = customers.where((c) => c.id == selectedId).firstOrNull;
    final text = selected?.fullName.isNotEmpty == true ? selected!.fullName : null;

    Future<void> pick() async {
      final picked = await showCustomerPicker(context, customers);
      if (picked != null) onSelected(picked);
    }

    if (compact) {
      return AppToolbarField(
        icon: Icons.person_outline,
        label: label,
        value: text,
        placeholder: hint ?? 'اختر عميلاً',
        // زر المسح بحجم الأيقونات نفسه (لا IconButton بمربّع لمس 48px يرفع
        // الحقل عن سطر الشريط)، ويظهر فقط حين يكون هناك اختيار فعلي.
        trailing: allowClear && selected != null
            ? _ClearButton(onPressed: onCleared)
            : toolbarTrailingIcon(context, Icons.search),
        onTap: pick,
      );
    }

    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: pick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.person_outline),
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
          text ?? (hint ?? 'اختر عميلاً'),
          overflow: TextOverflow.ellipsis,
          style: selected == null
              ? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// زر مسح الاختيار داخل حقل الشريط — بحجم أيقونات الشريط نفسها مع منطقة نقر
/// مريحة (24×24) تبقى سهلة الإصابة بالفأرة في الاستخدام اليومي.
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'مسح الاختيار',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onPressed,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Center(child: toolbarTrailingIcon(context, Icons.close)),
        ),
      ),
    );
  }
}

/// بوب أب بحث عن عميل (بالاسم أو الهاتف)، يُعاد التركيز للبحث تلقائياً.
Future<Customer?> showCustomerPicker(BuildContext context, List<Customer> customers) {
  return showDialog<Customer>(
    context: context,
    builder: (_) => _CustomerPickerDialog(customers: customers),
  );
}

class _CustomerPickerDialog extends ConsumerStatefulWidget {
  const _CustomerPickerDialog({required this.customers});

  final List<Customer> customers;

  @override
  ConsumerState<_CustomerPickerDialog> createState() => _CustomerPickerDialogState();
}

class _CustomerPickerDialogState extends ConsumerState<_CustomerPickerDialog> {
  String _query = '';
  late List<Customer> _customers = widget.customers;
  bool _adding = false;

  /// يفتح نموذج إضافة عميل سريع، ثم يُحدِّد العميل الجديد تلقائياً (يُغلِق
  /// هذا البوب أب بنتيجته) — بلا حاجة للعودة والبحث عنه يدوياً.
  Future<void> _addNew() async {
    final values = await showEntityFormDialog(
      context,
      title: AppStrings.addCustomer,
      icon: Icons.person_add_alt_1_outlined,
      fields: const [
        EntityField(key: 'firstName', label: AppStrings.firstName, isRequired: true),
        EntityField(key: 'lastName', label: AppStrings.lastName),
        EntityField(key: 'phone', label: AppStrings.phone),
        EntityField(key: 'address', label: AppStrings.address),
      ],
    );
    if (values == null || !mounted) return;

    setState(() => _adding = true);
    final firstName = values['firstName']!;
    final lastName = values['lastName'] ?? '';
    final phone = values['phone'] ?? '';
    final result = await ref.read(customerRepositoryProvider).create(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          address: values['address'] ?? '',
        );
    if (!mounted) return;
    setState(() => _adding = false);

    result.fold(
      (_) async {
        ref.invalidate(customersProvider);
        final fresh = await ref.read(customersProvider.future);
        if (!mounted) return;
        final created = fresh
            .where((c) =>
                c.firstName == firstName && c.lastName == lastName && c.phone == phone)
            .lastOrNull;
        if (created != null) {
          Navigator.of(context).pop(created);
        } else {
          setState(() => _customers = fresh);
        }
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? _customers
        : _customers
            .where((c) =>
                c.fullName.toLowerCase().contains(q) || c.phone.toLowerCase().contains(q))
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
                  Icon(Icons.person_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('اختر عميلاً',
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
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: _adding ? null : _addNew,
                  icon: _adding
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.add, size: 16),
                  label: const Text('عميل جديد'),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppSearchField(
                hint: 'ابحث بالاسم أو الهاتف',
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(message: 'لا يوجد عملاء مطابقون')
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
                                c.fullName.isNotEmpty ? c.fullName.substring(0, 1) : '#',
                                style: TextStyle(
                                    fontSize: 11, color: theme.colorScheme.primary),
                              ),
                            ),
                            title: Text(c.fullName,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: c.phone.isNotEmpty ? Text(c.phone) : null,
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
