import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/suppliers/domain/entities/supplier.dart';
import 'package:saydaliati/features/suppliers/supplier_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// Copies a global-catalog item into the pharmacy's own stock — grid-style
/// entry (نفس أسلوب غريدات المشروع): one editable row whose cells are the
/// quantity, purchase price (+currency), sale price, expiry and supplier;
/// a compact save button commits it as a NEW stock batch.
///
/// Pops with `true` on success so the caller can refresh.
class AddCatalogToStockPage extends ConsumerStatefulWidget {
  const AddCatalogToStockPage({required this.item, super.key});

  final CatalogItem item;

  @override
  ConsumerState<AddCatalogToStockPage> createState() =>
      _AddCatalogToStockPageState();
}

class _AddCatalogToStockPageState extends ConsumerState<AddCatalogToStockPage> {
  double _qty = 1;
  double _purchase = 0;
  double _sale = 0;
  late DateTime _expiry = DateTime.now().add(const Duration(days: 365 * 3));
  bool _busy = false;
  // العملة التي يُدخَل بها سعر الشراء (افتراضياً العملة الأساسية = ل.س).
  Currency? _purchaseCurrency;
  // المورّد (اختياري).
  String? _supplierId;

  static const _fQty = 'qty';
  static const _fPurchase = 'purchase';
  static const _fCurrency = 'currency';
  static const _fSale = 'sale';
  static const _fExpiry = 'expiry';
  static const _fSupplier = 'supplier';

  @override
  void initState() {
    super.initState();
    // Seed the sale price from the catalog's public price (editable), CONVERTED
    // into the base currency: the catalog price may be in another currency (e.g.
    // ريفافارما بالدولار), while the sale price here is always in ل.س.
    if (widget.item.pricePublic > 0) {
      final currencies =
          ref.read(currenciesProvider).value ?? const <Currency>[];
      final base = _baseOf(currencies);
      Currency? itemCur;
      for (final c in currencies) {
        if (c.code == widget.item.currency) {
          itemCur = c;
          break;
        }
      }
      var seed = widget.item.pricePublic;
      if (itemCur != null &&
          base != null &&
          itemCur.id != base.id &&
          itemCur.exchangeRate > 0) {
        seed = convertToBase(widget.item.pricePublic, base, itemCur);
      }
      _sale = seed;
    }
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 15)),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_qty <= 0 || _purchase <= 0 || _sale <= 0) {
      messenger.showSnackBar(const SnackBar(
          content: Text('أدخل الكمية وسعر الشراء وسعر المبيع (قيم موجبة)')));
      return;
    }

    // سعر الشراء قد يكون بعملة غير الليرة → نحوّله إلى الليرة بسعر الصرف.
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final base = _baseOf(currencies);
    final selected = _purchaseCurrency ?? base;

    var purchaseSyp = _purchase;
    if (selected != null && base != null && selected.id != base.id) {
      if (selected.exchangeRate <= 0) {
        messenger.showSnackBar(SnackBar(
            content: Text(
                'لم يُحدَّد سعر صرف لعملة ${selected.code}. حدّده من شاشة العملات، '
                'أو اختر «الليرة السورية» وأدخل السعر بها.')));
        return;
      }
      purchaseSyp = convertToBase(_purchase, base, selected);
    }

    setState(() => _busy = true);
    try {
      final medId = await ref.read(catalogRemoteDataSourceProvider).addToStock(
            catalogId: widget.item.id,
            quantity: _qty,
            purchasePrice: purchaseSyp,
            salePrice: _sale,
            expiryDate: _expiry,
            barcode: widget.item.barcode,
            supplierId: _supplierId,
          );
      // حفظ الدواء المُنشأ مباشرةً في الكاش وإدراجه في قائمة الأدوية/المبيعات في
      // الذاكرة بلا رفرش يدوي.
      if (medId.isNotEmpty) {
        try {
          await ref.read(medicineCatalogProvider.notifier).insertNew(medId);
        } catch (_) {/* أفضل جهد — لا يُفشل الإضافة */}
      }
      if (!mounted) return;
      messenger.showSnackBar(
          const SnackBar(content: Text('تمت الإضافة إلى مخزونك')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('تعذّرت الإضافة: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Currency? _baseOf(List<Currency> cs) {
    for (final c in cs) {
      if (c.isBaseCurrency) return c;
    }
    return cs.isNotEmpty ? cs.first : null;
  }

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = _baseOf(currencies);
    final selected = _purchaseCurrency ?? base;
    final suppliers = ref.watch(suppliersProvider).value ?? const <Supplier>[];
    final supplierName = suppliers
            .where((s) => s.id == _supplierId)
            .map((s) => s.name)
            .firstOrNull ??
        '— بلا مورّد —';

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة إلى مخزوني')),
      body: ConstrainedContent(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ترويسة الدواء: اسم + الشركة + السعر العام للمرجع.
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Icon(Icons.medication_rounded,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.displayName,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        if (item.manufacturerName.isNotEmpty)
                          Text(item.manufacturerName,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.hintColor)),
                      ],
                    ),
                  ),
                  if (item.pricePublic > 0)
                    Text(
                      Formatters.money(item.pricePublic, item.currencySymbol),
                      style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // صف الإدخال كغريد: الكمية/الأسعار خلايا تُحرَّر في مكانها،
              // والعملة/الصلاحية/المورّد قوائم داخل الخلية.
              SizedBox(height: 132, child: _entryGrid(currencies, base, suppliers, supplierName)),
              // معاينة حيّة للتكلفة بالعملة الأساسية (تكشف أي خطأ بالسعر/العملة).
              if (selected != null &&
                  base != null &&
                  selected.id != base.id) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  selected.exchangeRate > 0
                      ? (_purchase > 0
                          ? 'التكلفة بالعملة الأساسية ≈ ${Formatters.money(convertToBase(_purchase, base, selected), base.symbol)}'
                          : 'سيُحوّل سعر الشراء إلى الليرة السورية تلقائياً بسعر الصرف المحفوظ.')
                      : '⚠️ لا يوجد سعر صرف محفوظ لهذه العملة — حدّده من شاشة العملات أو اختر الليرة.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
              ],
              const Spacer(),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _save,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.add_business_outlined),
                  label: const Text('حفظ وإضافة للمخزون'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryGrid(List<Currency> currencies, Currency? base,
      List<Supplier> suppliers, String supplierName) {
    final theme = Theme.of(context);
    final selected = _purchaseCurrency ?? base;

    Widget menuCell({
      required String text,
      required List<PopupMenuEntry<Object?>> items,
      required ValueChanged<Object?> onSelected,
      VoidCallback? onTap,
    }) {
      final child = Row(
        children: [
          Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
          Icon(Icons.arrow_drop_down, size: 16, color: theme.hintColor),
        ],
      );
      if (onTap != null) return InkWell(onTap: onTap, child: child);
      return PopupMenuButton<Object?>(
        onSelected: onSelected,
        itemBuilder: (_) => items,
        child: child,
      );
    }

    return AppGrid(
      key: ValueKey(Object.hash(
          selected?.id, _expiry, _supplierId, _qty, _purchase, _sale)),
      showColumnFilter: false,
      columns: [
        TrinaColumn(
          title: 'الكمية',
          field: _fQty,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 90,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
        ),
        TrinaColumn(
          title: 'سعر الشراء (${selected?.symbol ?? 'ل.س'})',
          field: _fPurchase,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 140,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
        ),
        if (currencies.length > 1)
          TrinaColumn(
            title: 'عملة الشراء',
            field: _fCurrency,
            type: TrinaColumnType.text(),
            width: 120,
            enableEditingMode: false,
            renderer: (ctx) => menuCell(
              text: ctx.cell.value?.toString() ?? '',
              items: [
                for (final c in currencies)
                  PopupMenuItem<Object?>(
                      value: c, child: Text('${c.name} (${c.code})')),
              ],
              onSelected: (v) =>
                  setState(() => _purchaseCurrency = v as Currency?),
            ),
          ),
        TrinaColumn(
          title: 'سعر المبيع (ل.س)',
          field: _fSale,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 140,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
        ),
        TrinaColumn(
          title: 'تاريخ الصلاحية',
          field: _fExpiry,
          type: TrinaColumnType.text(),
          width: 130,
          enableEditingMode: false,
          renderer: (ctx) => menuCell(
            text: ctx.cell.value?.toString() ?? '',
            items: const [],
            onSelected: (_) {},
            onTap: _pickExpiry,
          ),
        ),
        if (suppliers.isNotEmpty)
          TrinaColumn(
            title: 'المورّد',
            field: _fSupplier,
            type: TrinaColumnType.text(),
            width: 150,
            enableEditingMode: false,
            renderer: (ctx) => menuCell(
              text: ctx.cell.value?.toString() ?? '',
              items: [
                const PopupMenuItem<Object?>(
                    value: '', child: Text('— بلا مورّد —')),
                for (final s in suppliers)
                  PopupMenuItem<Object?>(value: s.id, child: Text(s.name)),
              ],
              onSelected: (v) => setState(() =>
                  _supplierId = (v as String?)?.isEmpty ?? true ? null : v as String),
            ),
          ),
      ],
      rows: [
        TrinaRow(cells: {
          _fQty: TrinaCell(value: _qty),
          _fPurchase: TrinaCell(value: _purchase > 0 ? _purchase : ''),
          if (currencies.length > 1)
            _fCurrency: TrinaCell(
                value: selected != null
                    ? '${selected.name} (${selected.code})'
                    : ''),
          _fSale: TrinaCell(value: _sale > 0 ? _sale : ''),
          _fExpiry: TrinaCell(value: _ymd(_expiry)),
          if (suppliers.isNotEmpty)
            _fSupplier: TrinaCell(value: supplierName),
        }),
      ],
      onChanged: (e) {
        final v = e.value is num
            ? (e.value as num).toDouble()
            : double.tryParse(e.value?.toString() ?? '');
        if (v == null || v < 0) {
          setState(() {}); // البصمة تعيد البناء بالقيمة القديمة
          return;
        }
        setState(() {
          switch (e.column.field) {
            case _fQty:
              _qty = v;
            case _fPurchase:
              _purchase = v;
            case _fSale:
              _sale = v;
          }
        });
      },
    );
  }
}
