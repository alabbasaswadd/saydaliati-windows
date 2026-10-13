import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';

/// Shared «مزامنة أسعار الأدوية» flow — used from both أدويتي and الكاتلوغ:
///  1. a confirmation popup explaining what will happen (and how to opt a drug out),
///  2. a comfortable waiting overlay,
///  3. sync prices on the backend, then re-pull the pharmacy's medicines into the
///     local cache (so offline data matches), and refresh the on-screen list.
Future<void> runMedicinePriceSync(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => const _PriceSyncConfirmDialog(),
  );
  if (confirmed != true || !context.mounted) return;

  // Comfortable, non-dismissible waiting overlay.
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _SyncingDialog(),
  );

  Map<String, dynamic> summary = {};
  try {
    summary = await ref.read(medicineRemoteDataSourceProvider).syncPrices();
    // Backend updated → refresh the local cache from the server so offline matches.
    final fresh = await ref.read(medicineRemoteDataSourceProvider).list();
    await ref.read(medicineLocalDataSourceProvider).replaceAll(fresh);
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // close overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذّرت مزامنة الأسعار: $e')),
      );
    }
    return;
  }

  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop(); // close overlay
  ref.invalidate(medicineCatalogProvider); // re-read the list from the fresh cache

  final updated = (summary['updated'] as num?)?.toInt() ?? 0;
  final skipped = (summary['skippedDisabled'] as num?)?.toInt() ?? 0;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'تمت مزامنة الأسعار — حُدِّث $updated دواء'
        '${skipped > 0 ? ' · مستثنى $skipped' : ''}',
      ),
    ),
  );
}

/// Confirmation popup for the price sync — Windows-style dialog: narrow fixed
/// width, a close ✕ in the header, and small content-sized buttons aligned to
/// the end (not full-width stretched like the old mobile-style popup).
class _PriceSyncConfirmDialog extends StatelessWidget {
  const _PriceSyncConfirmDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس بأسلوب نوافذ ويندوز: أيقونة + عنوان + زر إغلاق صغير.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.price_change_outlined,
                      color: theme.colorScheme.primary, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('مزامنة أسعار الأدوية',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
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
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'سيتم تحديث أسعار أدويتك من الكاتلوغ العام (سعر العموم).\n\n'
                'الأدوية التي أوقفتَ فيها خيار «تحديث السعر تلقائياً» لن تتغيّر أسعارها. '
                'لاستثناء دواء معيّن، أوقِف الخيار من صفحة الدواء ثم أعِد المزامنة.\n\n'
                'هل تريد المتابعة؟',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              // أزرار بحجم محتواها بدل الممتدة — أسلوب نوافذ ويندوز.
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
                      onPressed: () => Navigator.pop(context, false),
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
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('مزامنة'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A friendly waiting dialog so the user doesn't get bored while prices sync.
class _SyncingDialog extends StatelessWidget {
  const _SyncingDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text('جارٍ مزامنة الأسعار…',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('نحدّث أسعار أدويتك من الكاتلوغ، يرجى الانتظار قليلاً',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
