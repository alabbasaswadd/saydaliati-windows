import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/catalog/presentation/medicine_share.dart';
import 'package:saydaliati/features/catalog/presentation/pages/add_catalog_to_stock_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';


/// Clear, branded display page for a global-catalog medicine. The card is
/// wrapped in a RepaintBoundary so it can be shared as an image; a PDF (with
/// alternatives + our QR) can also be shared. Supports add-to-stock + alternatives.
class CatalogDetailPage extends ConsumerStatefulWidget {
  const CatalogDetailPage({required this.item, super.key});

  final CatalogItem item;

  @override
  ConsumerState<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends ConsumerState<CatalogDetailPage> {
  final _cardKey = GlobalKey();

  CatalogItem get item => widget.item;

  Future<void> _share() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('مشاركة كصورة'),
              subtitle: const Text('صورة بطاقة الدواء كما تظهر'),
              onTap: () => Navigator.pop(ctx, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('مشاركة كملف PDF'),
              subtitle: const Text('الدواء + البدائل مع هوية صيدليتي ورمز الموقع'),
              onTap: () => Navigator.pop(ctx, 'pdf'),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      if (choice == 'image') {
        await shareMedicineAsImage(_cardKey, item.displayName);
      } else {
        messenger.showSnackBar(const SnackBar(content: Text('جارٍ تجهيز ملف PDF…')));
        final alts = await ref.read(catalogItemAlternativesProvider(item.id).future);
        await shareMedicineAsPdf(item, alts);
      }
    } catch (e) {
      if (mounted) messenger.showSnackBar(SnackBar(content: Text('تعذّرت المشاركة: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'مشاركة',
            icon: const Icon(Icons.share_outlined),
            onPressed: _share,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // The shareable card (captured as an image).
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _brandStrip(theme, semantic),
                  const SizedBox(height: AppSpacing.md),
                  _hero(theme, semantic),
                  const SizedBox(height: AppSpacing.md),
                  _detail(theme, semantic, 'المادة الفعّالة / التركيب', item.genericName),
                  _detail(theme, semantic, 'الباركود', item.barcode),
                  _detail(theme, semantic, 'العبوة', item.note),
                  _detail(theme, semantic, 'الاستخدام', item.usage),
                  _detail(theme, semantic, 'الجرعة', item.dosage),
                  _detail(theme, semantic, 'الرمز (sako)', item.sakoCode),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => AddCatalogToStockPage(item: item),
            )),
            icon: const Icon(Icons.add_business_outlined),
            label: const Text('إضافة إلى مخزوني'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => _CatalogAlternativesPage(item: item),
            )),
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('عرض البدائل'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }

  // صيدليتي brand strip — shown atop the card so the shared image is branded.
  Widget _brandStrip(ThemeData theme, AppSemanticColors semantic) => Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.brSm,
            child: Image.asset('assets/icon/app_icon.png',
                width: 40, height: 40, fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.local_pharmacy, color: theme.colorScheme.primary)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('صيدليتي',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              Text('بطاقة دواء من الكاتلوغ',
                  style: theme.textTheme.bodySmall?.copyWith(color: semantic.textSecondary)),
            ],
          ),
        ],
      );

  Widget _hero(ThemeData theme, AppSemanticColors semantic) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.14),
              theme.colorScheme.primary.withValues(alpha: 0.04),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: AppRadius.brLg,
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: AppRadius.brMd,
              ),
              child: Icon(Icons.medication_rounded,
                  color: theme.colorScheme.primary, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.displayName,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (item.foreignName.isNotEmpty && item.foreignName != item.brandName)
                    Text(item.foreignName,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: semantic.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.factory_outlined, size: 15, color: semantic.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(item.manufacturerName.isEmpty ? '—' : item.manufacturerName,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: semantic.textSecondary)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.14),
                          borderRadius: AppRadius.brSm,
                        ),
                        child: Text(
                          item.pricePublic > 0
                              ? Formatters.money(item.pricePublic, item.currencySymbol)
                              : 'غير مسعّر',
                          style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _detail(ThemeData theme, AppSemanticColors semantic, String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelMedium?.copyWith(color: semantic.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// Alternatives of a catalog item (same generic), sourced from the global catalog.
class _CatalogAlternativesPage extends ConsumerWidget {
  const _CatalogAlternativesPage({required this.item});

  final CatalogItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    final async = ref.watch(catalogItemAlternativesProvider(item.id));

    return Scaffold(
      appBar: AppBar(title: const Text('البدائل')),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(catalogItemAlternativesProvider(item.id))),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
                icon: Icons.swap_horiz_rounded, message: 'لا توجد بدائل في الكاتلوغ');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) {
              final a = items[i];
              return Material(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.brMd,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.brMd,
                      side: BorderSide(color: semantic.border)),
                  title: Text(a.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(a.manufacturerName.isEmpty ? '—' : a.manufacturerName,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(
                      a.pricePublic > 0 ? Formatters.money(a.pricePublic, a.currencySymbol) : '—',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.primary)),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => CatalogDetailPage(item: a))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
