import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/catalog/presentation/pages/add_catalog_to_stock_page.dart';
import 'package:saydaliati/features/catalog/presentation/pages/catalog_detail_page.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/medicines/presentation/price_sync_action.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// الكاتلوغ العام — global, read-only drug reference. Two views:
///  • «الأدوية»: searchable (trade/generic/english/arabic/barcode) + camera scan.
///  • «الشركات»: grouped by manufacturer; tap a company to browse its drugs.
/// Tapping any item opens a detail page with alternatives.
class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final _controller = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _runSearch(String v) {
    _debounce?.cancel();
    setState(() => _query = v.trim());
  }

  /// Type-to-search with a short debounce so we don't fire a query per keystroke.
  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = v.trim());
    });
  }

  /// Manual local refresh — allowed only once every 6 hours (computed precisely
  /// from the last pull); otherwise tells the user how long remains.
  Future<void> _updateLocal() async {
    final svc = ref.read(catalogSyncServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (await svc.needsUpdate()) {
      messenger.showSnackBar(const SnackBar(content: Text('جارٍ تحديث الكاتلوغ محلياً…')));
      await svc.sync(force: true);
      if (!mounted) return;
      ref.invalidate(catalogSearchProvider);
      messenger.showSnackBar(const SnackBar(content: Text('تم تحديث الكاتلوغ محلياً')));
    } else {
      final rem = await svc.remainingThrottle();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text('التحديث المحلي متاح كل 6 ساعات — جرّب بعد '
            '${rem.inHours}س ${rem.inMinutes % 60}د'),
      ));
    }
  }

  Future<void> _handleScan(String code) async {
    if (code.isEmpty || !mounted) return;
    // Exact barcode lookup — offline-first: hit the local mirror when warm, else
    // the API. If found open detail; else fall back to a name/barcode search.
    final local = ref.read(catalogLocalDataSourceProvider);
    CatalogItem? item;
    if ((await local.count()) > 0) {
      item = await local.byBarcode(code);
    } else {
      item = await ref.read(catalogRemoteDataSourceProvider).byBarcode(code);
    }
    if (!mounted) return;
    final found = item;
    if (found != null) {
      Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => CatalogDetailPage(item: found)));
    } else {
      _controller.text = code;
      _runSearch(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    // شركات الكتالوغ انتقلت إلى شاشة «الشركات المصنعة» (تبويب شركات الكتالوغ).
    return BarcodeScannerListener(
      onScan: _handleScan,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الكاتلوغ العام'),
          actions: [
            IconButton(
              tooltip: 'مزامنة أسعار أدويتي',
              icon: const Icon(Icons.price_change_outlined),
              onPressed: () => runMedicinePriceSync(context, ref),
            ),
            IconButton(
              tooltip: 'تحديث البيانات محلياً',
              icon: const Icon(Icons.cloud_download_outlined),
              onPressed: _updateLocal,
            ),
          ],
        ),
        body: _SearchTab(
          controller: _controller,
          query: _query,
          onSearch: _runSearch,
          onChanged: _onChanged,
        ),
      ),
    );
  }
}

class _SearchTab extends ConsumerWidget {
  const _SearchTab({
    required this.controller,
    required this.query,
    required this.onSearch,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            onSubmitted: onSearch,
            decoration: const InputDecoration(
              hintText: 'ابحث: اسم تجاري / علمي / إنجليزي / عربي / باركود',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const _AddedProgressBar(),
        // Empty query → browse the WHOLE mirror lazily (all ~22.5k, paged on
        // scroll). A typed query → narrowed search results.
        Expanded(child: query.isEmpty ? const _BrowseAllList() : _SearchResults(query: query)),
      ],
    );
  }
}

/// «١١٠ مضاف من أصل ٢٢٬٥٠٠» — كم من الكتالوغ العام صار عندي بأدويتي، مطابقةً
/// بالباركود مع النسخة المحلية الكاملة. لا تظهر إن لم تُزامَن النسخة المحلية
/// بعد (لا معنى لنسبة من كتالوغ فارغ).
class _AddedProgressBar extends ConsumerWidget {
  const _AddedProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(catalogAddedProgressProvider);
    final progress = async.value;
    if (progress == null) return const SizedBox.shrink();

    final ratio = progress.total == 0 ? 0.0 : progress.added / progress.total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${Formatters.integer(progress.added)} مضاف من أصل '
            '${Formatters.integer(progress.total)}',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio.clamp(0, 1),
                minHeight: 4,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogSearchProvider(query));
    return async.when(
      loading: () => const LoadingState(),
      error: (e, _) => ErrorState.fromError(e,
          onRetry: () => ref.invalidate(catalogSearchProvider(query))),
      data: (items) => items.isEmpty
          ? const EmptyState(
              icon: Icons.medication_outlined,
              message: 'لا نتائج — جرّب اسماً أو باركود آخر')
          : CatalogGrid(items: items),
    );
  }
}

/// Browse the ENTIRE local mirror as the project-standard grid: all pages are
/// loaded once (local SQLite) then the grid virtualizes rendering — so the
/// per-column filters search the whole catalog, not just the visible page.
class _BrowseAllList extends ConsumerStatefulWidget {
  const _BrowseAllList();

  @override
  ConsumerState<_BrowseAllList> createState() => _BrowseAllListState();
}

class _BrowseAllListState extends ConsumerState<_BrowseAllList> {
  static const int _pageSize = 2000;
  List<CatalogItem>? _items;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final local = ref.read(catalogLocalDataSourceProvider);
    final all = <CatalogItem>[];
    while (true) {
      final rows = await local.page(limit: _pageSize, offset: all.length);
      all.addAll(rows);
      if (rows.length < _pageSize) break;
    }
    if (mounted) setState(() => _items = all);
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items == null) return const LoadingState();
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.cloud_download_outlined,
        message:
            'لم يُحمّل الكاتلوغ محلياً بعد — اضغط «تحديث البيانات محلياً» أعلى الصفحة',
      );
    }
    return CatalogGrid(items: items);
  }
}

/// قالب غريد الكتالوغ — جاهز لإعادة الاستخدام في أي شاشة تعرض أدوية الكتالوغ:
/// أعمدة بفلترة «يحتوي»، إظهار/إخفاء أعمدة، نقرة مزدوجة للتفاصيل، وعمود
/// إجراءات (تفاصيل / إضافة للمخزون).
class CatalogGrid extends ConsumerStatefulWidget {
  const CatalogGrid({required this.items, super.key});

  final List<CatalogItem> items;

  @override
  ConsumerState<CatalogGrid> createState() => _CatalogGridState();
}

class _CatalogGridState extends ConsumerState<CatalogGrid> {
  TrinaGridStateManager? _manager;

  static const _fId = 'id';
  static const _fName = 'name';
  static const _fCompany = 'company';
  static const _fGeneric = 'generic';
  static const _fPack = 'pack';
  static const _fBarcode = 'barcode';
  static const _fPublic = 'pricePublic';
  static const _fPharmacist = 'pricePharmacist';
  static const _fActions = 'actions';

  /// معرّفات أصناف قيد الإضافة السريعة الآن — تمنع نقرتين على نفس الصف وتُظهر
  /// دورانَ تحميل مكانَ الأيقونة.
  final Set<String> _quickAdding = {};

  void _openDetail(CatalogItem item) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => CatalogDetailPage(item: item)));
  }

  /// تسجيل فوري بلا نموذج ولا مخزون: كمية صفر عمداً — يضيف الدواء إلى
  /// «أدويتي» فقط، بلا دفعة مخزون وهمية (الاستلام الفعلي لاحقاً من «استلام
  /// مخزون» حين تصل كمية حقيقية). سعرا البيع/الشراء على الدواء نفسه رغم ذلك،
  /// مبذوران من السعر العام وسعر الصيدلاني بالكاتلوغ (محوَّلين للعملة
  /// الأساسية) إن وُجدا وإلا صفر.
  Future<void> _quickAdd(CatalogItem item) async {
    if (_quickAdding.contains(item.id)) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _quickAdding.add(item.id));

    try {
      final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
      Currency? base;
      for (final c in currencies) {
        if (c.isBaseCurrency) {
          base = c;
          break;
        }
      }
      base ??= currencies.isNotEmpty ? currencies.first : null;
      Currency? itemCurrency;
      for (final c in currencies) {
        if (c.code == item.currency) {
          itemCurrency = c;
          break;
        }
      }
      double convert(double v) {
        if (v <= 0) return 0;
        if (itemCurrency != null &&
            base != null &&
            itemCurrency.id != base.id &&
            itemCurrency.exchangeRate > 0) {
          return convertToBase(v, base, itemCurrency);
        }
        return v;
      }

      // كمية صفر عمداً: الإضافة السريعة تُسجِّل الدواء بقائمة أدويتي بلا
      // دفعة مخزون وهمية — الاستلام الفعلي لاحقاً من «استلام مخزون» حين
      // تصل كمية حقيقية. سعرا البيع/الشراء يُبذَران بالكاتلوغ رغم ذلك: هما
      // على الدواء نفسه لا على دفعة، فيبقيان مفيدين حتى بلا مخزون.
      final medId = await ref.read(catalogRemoteDataSourceProvider).addToStock(
            catalogId: item.id,
            quantity: 0,
            purchasePrice: convert(item.pricePharmacist),
            salePrice: convert(item.pricePublic),
            expiryDate: DateTime.now().add(const Duration(days: 365 * 3)),
            barcode: item.barcode,
          );
      if (medId.isNotEmpty) {
        try {
          await ref.read(medicineCatalogProvider.notifier).insertNew(medId);
        } catch (_) {/* أفضل جهد — لا يُفشل الإضافة */}
      }
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
          content: Text(
              'أُضيف «${item.displayName}» إلى أدويتك بلا مخزون — زوّده بكمية من «استلام مخزون» حين تصل')));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('تعذّرت الإضافة: $e')));
    } finally {
      if (mounted) setState(() => _quickAdding.remove(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final byId = {for (final it in widget.items) it.id: it};
    final myBarcodes = ref.watch(myMedicineBarcodesProvider);
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AppGridColumnsButton(managerGetter: () => _manager),
          ),
          Expanded(
            child: AppGrid(
              // تغيّر النتائج (بحث جديد) أو تغيّر أدويتي (إضافة سريعة) → شبكة
              // جديدة. Trina يخزّن الأعمدة داخلياً ولا يعيد قراءتها من
              // `columns:` عند إعادة البناء وحدها بلا تغيّر المفتاح (نفس ما
              // واجهناه بفاتورة المشتريات) — فبلا بصمة باركودات أدويتي هنا،
              // تبقى إشارة ✓ وزرّ الإضافة السريعة بحالتهما القديمة بعد أي
              // إضافة حتى بحثٍ جديد يُجبر الشبكة على التجدّد.
              key: ValueKey(Object.hash(
                  widget.items.length ^ widget.items.hashCode,
                  Object.hashAllUnordered(myBarcodes))),
              columns: _columns(byId, myBarcodes),
              rows: [for (final it in widget.items) _row(it)],
              onLoaded: (m) => _manager = m,
              onRowDoubleTap: (e) {
                final item = byId[e.row.cells[_fId]?.value];
                if (item != null) _openDetail(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// هل هذا الصنف مضاف أصلاً إلى أدويتي؟ — مطابقةً بالباركود (الرابط الوحيد
  /// المتاح)، يُستعمَل لشارة الاسم ولاستبدال زرّ الإضافة السريعة بإشارة صحّ.
  bool _isAdded(CatalogItem item, Set<String> myBarcodes) {
    final barcode = item.barcode.trim();
    return barcode.isNotEmpty && myBarcodes.contains(barcode);
  }

  List<TrinaColumn> _columns(
      Map<String, CatalogItem> byId, Set<String> myBarcodes) {
    return [
      appGridTextColumn('الاسم', _fName, width: 220, renderer: (ctx) {
        final item = byId[ctx.row.cells[_fId]?.value];
        final name = ctx.cell.value?.toString() ?? '';
        final added = item != null && _isAdded(item, myBarcodes);
        if (!added) return Text(name, overflow: TextOverflow.ellipsis);
        return Row(
          children: [
            Tooltip(
              message: 'مضاف إلى أدويتي',
              child: Icon(Icons.check_circle,
                  size: 14, color: context.semantic.success),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
          ],
        );
      }),
      appGridTextColumn('الشركة', _fCompany, width: 150),
      appGridTextColumn('التركيب العلمي', _fGeneric, width: 180),
      appGridTextColumn('العبوة', _fPack, width: 120, hide: true),
      appGridTextColumn('الباركود', _fBarcode, width: 130, hide: true),
      appGridNumberColumn('السعر العام', _fPublic, width: 130,
          renderer: (ctx) {
        final v = ctx.cell.value;
        final n = v is num ? v.toDouble() : 0.0;
        if (n <= 0) return const SizedBox.shrink();
        final item = byId[ctx.row.cells[_fId]?.value];
        final sym = item?.currencySymbol ?? '';
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            sym.isEmpty
                ? Formatters.number(n)
                : '${Formatters.number(n)} $sym',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }),
      appGridNumberColumn('سعر الصيدلاني', _fPharmacist,
          width: 110, hide: true),
      TrinaColumn(
        title: '',
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 134,
        enableEditingMode: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableSorting: false,
        renderer: (ctx) {
          final item = byId[ctx.row.cells[_fId]?.value];
          if (item == null) return const SizedBox.shrink();
          final adding = _quickAdding.contains(item.id);
          final added = _isAdded(item, myBarcodes);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.info_outline, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: 'التفاصيل',
                onPressed: () => _openDetail(item),
              ),
              // إضافة فورية بقيم افتراضية — بلا نموذج، لتسجيل الدواء بسرعة.
              // تتحوّل إلى إشارة صحّ معطَّلة إن كان مضافاً أصلاً: إعادة
              // الضغط لا تُنشئ دواءً مكرَّراً (الخادم يطابق بالباركود) لكنها
              // تضيف دفعة مخزون جديدة بقيم افتراضية بلا داعٍ — أفضل منعها.
              if (adding)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else if (added)
                Tooltip(
                  message: 'مضاف بالفعل إلى أدويتي',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.check_circle,
                        size: 16, color: context.semantic.success),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.bolt_outlined, size: 16),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'إضافة سريعة إلى أدويتي (بلا مخزون)',
                  onPressed: () => _quickAdd(item),
                ),
              IconButton(
                icon: const Icon(Icons.add_business_outlined, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: 'إضافة للمخزون (نموذج كامل)',
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => AddCatalogToStockPage(item: item))),
              ),
            ],
          );
        },
      ),
      TrinaColumn(
        title: '',
        field: _fId,
        type: TrinaColumnType.text(),
        hide: true,
      ),
    ];
  }

  TrinaRow<dynamic> _row(CatalogItem it) {
    return TrinaRow(
      cells: {
        _fId: TrinaCell(value: it.id),
        _fName: TrinaCell(value: it.displayName),
        _fCompany: TrinaCell(value: it.manufacturerName),
        _fGeneric: TrinaCell(value: it.genericName),
        _fPack: TrinaCell(value: it.note),
        _fBarcode: TrinaCell(value: it.barcode),
        _fPublic: TrinaCell(value: it.pricePublic),
        _fPharmacist: TrinaCell(value: it.pricePharmacist),
      },
    );
  }
}

/// شركات الكتالوغ العام: بحث عن شركة ← قائمة شركات بعدد أدويتها ← أدوية
/// الشركة كغريد. تُعرض كتبويب داخل شاشة «الشركات المصنعة».
class CatalogCompaniesTab extends ConsumerStatefulWidget {
  const CatalogCompaniesTab({super.key});

  @override
  ConsumerState<CatalogCompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends ConsumerState<CatalogCompaniesTab> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(catalogManufacturersProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              hintText: 'ابحث عن شركة',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'مسح',
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
          ),
        ),
        Expanded(
          child: async.when(
            loading: () => const LoadingState(),
            error: (e, _) => ErrorState.fromError(e,
                onRetry: () => ref.invalidate(catalogManufacturersProvider)),
            data: (all) {
              final q = _query.toLowerCase();
              final companies = q.isEmpty
                  ? all
                  : all.where((c) => c.name.toLowerCase().contains(q)).toList();
              if (companies.isEmpty) {
                return EmptyState(
                  icon: Icons.factory_outlined,
                  message: _query.isEmpty ? 'لا توجد شركات' : 'لا شركة بهذا الاسم',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                itemCount: companies.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                itemBuilder: (_, i) {
                  final c = companies[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                      child: Icon(Icons.factory_outlined, color: theme.colorScheme.primary),
                    ),
                    title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text('${c.count}',
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.colorScheme.primary)),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => _ManufacturerItemsPage(name: c.name))),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ManufacturerItemsPage extends ConsumerWidget {
  const _ManufacturerItemsPage({required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogByManufacturerProvider(name));
    return Scaffold(
      appBar: AppBar(title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(catalogByManufacturerProvider(name))),
        data: (items) => items.isEmpty
            ? const EmptyState(icon: Icons.medication_outlined, message: 'لا أدوية')
            : CatalogGrid(items: items),
      ),
    );
  }
}
