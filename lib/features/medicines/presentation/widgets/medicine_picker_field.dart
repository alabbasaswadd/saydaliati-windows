import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// A tap-to-search field that opens a modal medicine picker (search by name/
/// barcode) and calls [onSelected]. Reusable anywhere a medicine must be chosen
/// (POS manual add, purchase lines, …). Clears back to the hint after each pick.
class MedicinePickerField extends StatelessWidget {
  const MedicinePickerField({
    required this.medicines,
    required this.onSelected,
    this.hint,
    super.key,
  });

  final List<Medicine> medicines;
  final ValueChanged<Medicine> onSelected;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: () async {
        final picked = await showMedicinePicker(context, medicines);
        if (picked != null) onSelected(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.add_circle_outline),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(Icons.search),
          ),
        ),
        child: Text(
          hint ?? AppStrings.addLine,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }
}

/// Opens a centered popup picker (search by name/barcode, autofocused);
/// returns the chosen medicine or null.
Future<Medicine?> showMedicinePicker(
  BuildContext context,
  List<Medicine> medicines,
) {
  return showDialog<Medicine>(
    context: context,
    builder: (_) => _MedicinePickerDialog(medicines: medicines),
  );
}

class _MedicinePickerDialog extends StatefulWidget {
  const _MedicinePickerDialog({required this.medicines});

  final List<Medicine> medicines;

  @override
  State<_MedicinePickerDialog> createState() => _MedicinePickerDialogState();
}

class _MedicinePickerDialogState extends State<_MedicinePickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.medicines
        : widget.medicines
            .where((m) =>
                m.brandName.toLowerCase().contains(q) ||
                m.brandNameArabic.contains(q) ||
                m.genericName.toLowerCase().contains(q) ||
                m.foreignName.toLowerCase().contains(q) ||
                m.barcode.toLowerCase().contains(q))
            .toList();
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: size.height * 0.72,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.medication_outlined,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      AppStrings.selectMedicine,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
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
                hint: AppStrings.searchMedicineHint,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(message: AppStrings.noMedicines)
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final m = items[i];
                          final price = m.units.isNotEmpty
                              ? Formatters.money(m.units.first.salePrice)
                              : '—';
                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.brSm),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.10),
                              child: Icon(Icons.medication_outlined,
                                  size: 18, color: theme.colorScheme.primary),
                            ),
                            title: Text(m.displayName,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle:
                                m.barcode.isEmpty ? null : Text(m.barcode),
                            trailing: Text(
                              price,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            onTap: () => Navigator.of(context).pop(m),
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
