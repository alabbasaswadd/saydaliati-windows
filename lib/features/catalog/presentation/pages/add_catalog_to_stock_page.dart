import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Copies a global-catalog item into the pharmacy's own stock. The pharmacist
/// sets quantity + purchase price + sale price (+ expiry); on save the backend
/// creates (or reuses — no duplication) a pharmacy medicine from the catalog
/// fields plus an initial stock batch. Prices are in Syrian Pounds.
///
/// Pops with `true` on success so the caller can refresh.
class AddCatalogToStockPage extends ConsumerStatefulWidget {
  const AddCatalogToStockPage({required this.item, super.key});

  final CatalogItem item;

  @override
  ConsumerState<AddCatalogToStockPage> createState() => _AddCatalogToStockPageState();
}

class _AddCatalogToStockPageState extends ConsumerState<AddCatalogToStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _qty = TextEditingController(text: '1');
  final _purchase = TextEditingController();
  final _sale = TextEditingController();
  late DateTime _expiry = DateTime.now().add(const Duration(days: 365 * 3));
  bool _busy = false;
  // العملة التي يُدخَل بها سعر الشراء (افتراضياً العملة الأساسية = ل.س).
  Currency? _purchaseCurrency;
  // المورّد (اختياري).
  String? _supplierId;

  @override
  void initState() {
    super.initState();
    // Seed the sale price from the catalog's public price (editable), CONVERTED
    // into the base currency: the catalog price may be in another currency (e.g.
    // ريفافارما بالدولار), while the sale price here is always in ل.س.
    if (widget.item.pricePublic > 0) {
      final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
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
      _sale.text = Formatters.number(seed);
    }
    // Re-render the live "≈ X ل.س" preview as the purchase price is typed.
    _purchase.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _qty.dispose();
    _purchase.dispose();
    _sale.dispose();
    super.dispose();
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // سعر الشراء قد يكون بعملة غير الليرة → نحوّله إلى الليرة بسعر الصرف من الباكند.
    final currencies = ref.read(currenciesProvider).value ?? const <Currency>[];
    final base = _baseOf(currencies);
    final selected = _purchaseCurrency ?? base;
    final enteredPurchase = double.parse(_purchase.text.trim());

    var purchaseSyp = enteredPurchase;
    if (selected != null && base != null && selected.id != base.id) {
      if (selected.exchangeRate <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            'لم يُحدَّد سعر صرف لعملة ${selected.code}. حدّده من شاشة العملات، '
            'أو اختر «الليرة السورية» وأدخل السعر بها.')),
        );
        return;
      }
      purchaseSyp = convertToBase(enteredPurchase, base, selected);
    }

    setState(() => _busy = true);
    try {
      final medId = await ref.read(catalogRemoteDataSourceProvider).addToStock(
            catalogId: widget.item.id,
            quantity: double.parse(_qty.text.trim()),
            purchasePrice: purchaseSyp,
            salePrice: double.parse(_sale.text.trim()),
            expiryDate: _expiry,
            barcode: widget.item.barcode,
            supplierId: _supplierId,
          );
      // حفظ الدواء المُنشأ مباشرةً في الكاش وإدراجه في قائمة الأدوية/المبيعات في
      // الذاكرة بلا رفرش يدوي: insertNew يجلب الدواء، يكتبه في الكاش المحلي،
      // ويضيفه للقائمة — فيُوجَد فوراً عند إعادة مسح الباركود في المبيعات.
      if (medId.isNotEmpty) {
        try {
          await ref.read(medicineCatalogProvider.notifier).insertNew(medId);
        } catch (_) {/* أفضل جهد — لا يُفشل الإضافة */}
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت الإضافة إلى مخزونك')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذّرت الإضافة: $e')),
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = _baseOf(currencies);
    final selected = _purchaseCurrency ?? base;
    final currencyLabel = selected?.symbol ?? 'ل.س';
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة إلى مخزوني')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(item.displayName,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (item.manufacturerName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(item.manufacturerName, style: theme.textTheme.bodySmall),
              ),
            const SizedBox(height: AppSpacing.lg),
            _num(_qty, 'الكمية', required: true),
            const SizedBox(height: AppSpacing.md),
            _num(_purchase, 'سعر الشراء ($currencyLabel)', required: true),
            if (currencies.length > 1) ...[
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<Currency>(
                initialValue: selected,
                decoration: const InputDecoration(
                  labelText: 'عملة سعر الشراء',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                items: [
                  for (final c in currencies)
                    DropdownMenuItem(value: c, child: Text('${c.name} (${c.code})')),
                ],
                onChanged: (v) => setState(() => _purchaseCurrency = v),
              ),
              if (selected != null && base != null && selected.id != base.id)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    selected.exchangeRate > 0
                        ? 'سيُحوّل سعر الشراء إلى الليرة السورية تلقائياً بسعر الصرف المحفوظ.'
                        : '⚠️ لا يوجد سعر صرف محفوظ لهذه العملة — حدّده من شاشة العملات أو اختر الليرة.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
            ],
            // معاينة حيّة للتكلفة بالعملة الأساسية قبل الحفظ (تكشف أي خطأ بالسعر/العملة).
            Builder(builder: (_) {
              final entered = double.tryParse(_purchase.text.trim());
              if (selected == null ||
                  base == null ||
                  selected.id == base.id ||
                  selected.exchangeRate <= 0 ||
                  entered == null ||
                  entered <= 0) {
                return const SizedBox.shrink();
              }
              final inBase = convertToBase(entered, base, selected);
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(Icons.calculate_outlined,
                        size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'التكلفة بالعملة الأساسية ≈ ${Formatters.money(inBase, base.symbol)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.md),
            _num(_sale, 'سعر المبيع (ل.س)', required: true),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              onTap: _pickExpiry,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'تاريخ انتهاء الصلاحية',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                child: Text(
                    '${_expiry.year}-${_expiry.month.toString().padLeft(2, '0')}-${_expiry.day.toString().padLeft(2, '0')}'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // المورّد (اختياري) — يظهر فقط إن وُجد موردون.
            Builder(builder: (_) {
              final suppliers =
                  ref.watch(suppliersProvider).value ?? const <Supplier>[];
              if (suppliers.isEmpty) return const SizedBox.shrink();
              return DropdownButtonFormField<String?>(
                initialValue: _supplierId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'المورّد (اختياري)',
                  prefixIcon: Icon(Icons.local_shipping_outlined),
                ),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('— بلا مورّد —')),
                  for (final s in suppliers)
                    DropdownMenuItem<String?>(value: s.id, child: Text(s.name)),
                ],
                onChanged: (v) => setState(() => _supplierId = v),
              );
            }),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: _busy
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.add_business_outlined),
              label: const Text('حفظ وإضافة للمخزون'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _num(TextEditingController c, String label, {bool required = false}) => TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        decoration: InputDecoration(labelText: label),
        validator: (v) {
          final s = (v ?? '').trim();
          if (s.isEmpty) return required ? 'مطلوب' : null;
          final d = double.tryParse(s);
          if (d == null || d < 0) return 'قيمة غير صحيحة';
          return null;
        },
      );
}
