import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/catalog/presentation/pages/add_catalog_to_stock_page.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/presentation/pages/medicine_form_page.dart';

/// Behaviour for a scanned barcode in a sale/purchase context:
///  • if a medicine with that barcode exists in the pharmacy's stock → [onFound].
///  • otherwise → a clean, clear popup explaining the drug isn't in the
///    pharmacy's stock, offering «الانتقال للمخزون». Going there looks the
///    barcode up in the GLOBAL catalog — if found, it opens the add-to-stock
///    form (which creates a pharmacy medicine from the catalog fields); if not
///    found, it opens a blank medicine form prefilled with the scanned code.
Future<void> handleScannedBarcode({
  required BuildContext context,
  required WidgetRef ref,
  required List<Medicine> catalog,
  required String code,
  required void Function(Medicine) onFound,
}) async {
  final match = catalog.findByBarcode(code);
  if (match != null) {
    onFound(match);
    return;
  }

  final go = await showDialog<bool>(
    context: context,
    builder: (_) => _NotInStockDialog(code: code),
  );
  if (go == true && context.mounted) {
    await _goToStock(context: context, ref: ref, code: code);
  }
}

/// Clean "not in your stock" popup for a scanned barcode that didn't match any
/// of the pharmacy's own medicines.
class _NotInStockDialog extends StatelessWidget {
  const _NotInStockDialog({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // أيقونة واضحة ضمن دائرة لونية.
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.errorContainer,
              ),
              child: Icon(Icons.search_off_rounded,
                  color: theme.colorScheme.onErrorContainer, size: 30),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text('الدواء غير موجود في مخزونك',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'الباركود الممسوح غير مطابق لأي دواء في مخزونك. '
                'يمكنك البحث عنه في الكاتلوغ العام وإضافته إلى مخزونك.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 12),
            // عرض الباركود الممسوح بشكل واضح.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(code,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.add_business_outlined, size: 18),
                    label: const Text('الانتقال للمخزون'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Resolve the scanned code against the global catalog, then add to stock.
Future<void> _goToStock({
  required BuildContext context,
  required WidgetRef ref,
  required String code,
}) async {
  final item = await ref.read(catalogRemoteDataSourceProvider).byBarcode(code);
  if (!context.mounted) return;

  // No manual refresh needed: both the add-to-stock page and the new-medicine
  // form insert the created medicine into the in-memory catalog (and write it
  // through the local cache) via MedicineCatalog.insertNew — so re-scanning the
  // same barcode finds it immediately, with no reload/flash.
  await Navigator.of(context).push<Object?>(
    MaterialPageRoute<Object?>(
      builder: (_) => item != null
          // Found in the global catalog → prefilled add-to-stock form.
          ? AddCatalogToStockPage(item: item)
          // Not in the catalog → blank medicine form with the scanned barcode.
          : MedicineFormPage(initialBarcode: code),
    ),
  );
}
