import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/catalog/presentation/pages/add_catalog_to_stock_page.dart';
import 'package:saydaliati/features/catalog/presentation/pages/catalog_detail_page.dart';
import 'package:saydaliati/features/medicines/presentation/price_sync_action.dart';
import 'package:saydaliati/services/barcode_scanner.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

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
    return BarcodeScannerListener(
      onScan: _handleScan,
      child: DefaultTabController(
        length: 2,
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
            bottom: const TabBar(tabs: [Tab(text: 'الأدوية'), Tab(text: 'الشركات')]),
          ),
          body: TabBarView(
            children: [
              _SearchTab(
                controller: _controller,
                query: _query,
                onSearch: _runSearch,
                onChanged: _onChanged,
              ),
              const _CompaniesTab(),
            ],
          ),
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
        // Empty query → browse the WHOLE mirror lazily (all ~22.5k, paged on
        // scroll). A typed query → narrowed search results.
        Expanded(child: query.isEmpty ? const _BrowseAllList() : _SearchResults(query: query)),
      ],
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
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _CatalogTile(item: items[i]),
            ),
    );
  }
}

/// Lazily scrolls through the ENTIRE local mirror (loads a page at a time) so
/// every one of the ~22.5k drugs is reachable without decoding them all at once.
class _BrowseAllList extends ConsumerStatefulWidget {
  const _BrowseAllList();

  @override
  ConsumerState<_BrowseAllList> createState() => _BrowseAllListState();
}

class _BrowseAllListState extends ConsumerState<_BrowseAllList> {
  static const int _pageSize = 200;
  final _scroll = ScrollController();
  final List<CatalogItem> _items = [];
  bool _loading = false;
  bool _done = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _done) return;
    setState(() => _loading = true);
    final rows = await ref
        .read(catalogLocalDataSourceProvider)
        .page(limit: _pageSize, offset: _items.length);
    if (!mounted) return;
    setState(() {
      _items.addAll(rows);
      if (rows.length < _pageSize) _done = true;
      _loading = false;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const LoadingState();
    if (_items.isEmpty) {
      return const EmptyState(
        icon: Icons.cloud_download_outlined,
        message: 'لم يُحمّل الكاتلوغ محلياً بعد — اضغط «تحديث البيانات محلياً» أعلى الصفحة',
      );
    }
    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
      itemCount: _items.length + (_done ? 0 : 1),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) {
        if (i >= _items.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _CatalogTile(item: _items[i]);
      },
    );
  }
}

class _CompaniesTab extends ConsumerStatefulWidget {
  const _CompaniesTab();

  @override
  ConsumerState<_CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends ConsumerState<_CompaniesTab> {
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
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (_, i) => _CatalogTile(item: items[i]),
              ),
      ),
    );
  }
}

/// One catalog row — name, company, price (SYP). Opens the detail page.
class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.item});
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadius.brMd,
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: AppRadius.brMd, side: BorderSide(color: semantic.border)),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.medication_rounded, color: theme.colorScheme.primary),
        ),
        title: Text(item.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          [
            if (item.manufacturerName.isNotEmpty) item.manufacturerName,
            if (item.genericName.isNotEmpty) item.genericName,
          ].join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: semantic.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.pricePublic > 0
                  ? Formatters.money(item.pricePublic, item.currencySymbol)
                  : '—',
              style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'إضافة للمخزون',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_business_outlined),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => AddCatalogToStockPage(item: item))),
            ),
          ],
        ),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => CatalogDetailPage(item: item))),
      ),
    );
  }
}
