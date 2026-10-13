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

/// Opens a bottom-sheet picker; returns the chosen medicine or null.
Future<Medicine?> showMedicinePicker(
  BuildContext context,
  List<Medicine> medicines,
) {
  return showModalBottomSheet<Medicine>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _MedicinePickerSheet(medicines: medicines),
  );
}

class _MedicinePickerSheet extends StatefulWidget {
  const _MedicinePickerSheet({required this.medicines});

  final List<Medicine> medicines;

  @override
  State<_MedicinePickerSheet> createState() => _MedicinePickerSheetState();
}

class _MedicinePickerSheetState extends State<_MedicinePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
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

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            AppSearchField(
              hint: AppStrings.searchMedicineHint,
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
                          title: Text(m.displayName,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: m.barcode.isEmpty ? null : Text(m.barcode),
                          trailing: Text(price),
                          onTap: () => Navigator.of(context).pop(m),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
