import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/stock/domain/entities/stock.dart';
import 'package:saydaliati/features/stock/presentation/pages/add_stock_page.dart';
import 'package:saydaliati/features/stock/stock_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_search_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// المخزون — دفعات الأدوية (الكمية، الصلاحية، أسعار الشراء/البيع) بنفس أسلوب
/// الغريد المعتمد في المشروع. إضافة دفعة من زر «استلام مخزون» بجانب البحث.
class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  TrinaGridStateManager? _gridManager;
  String _query = '';

  /// تعديل دفعة مخزون موجودة — بوب أب بأسلوب سطح المكتب (لا صفحة كاملة)، لأن
  /// الحقول قليلة (الكمية/سعر الشراء/الصلاحية) والدواء نفسه ثابت.
  Future<void> _editStock(Stock s) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _EditStockDialog(stock: s),
    );
    if (saved == true && mounted) {
      ref.invalidate(stockListProvider);
      AppSnackbar.success(context, AppStrings.stockSavedSuccess);
    }
  }

  Future<void> _delete(Stock s) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: s.medicineName);
    if (!ok || !mounted) return;
    final result = await ref.read(stockRepositoryProvider).delete(s.id);
    if (!mounted) return;
    result.fold(
      (_) {
        ref.invalidate(stockListProvider);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  List<Stock> _filter(List<Stock> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((s) => s.medicineName.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(stockListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stockTitle),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: AppSearchField(
                    hint: AppStrings.searchMedicineHint,
                    debounce: const Duration(milliseconds: 250),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AddStockPage()),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(AppStrings.receiveStock),
                ),
              ],
            ),
          ),
        ),
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => ref.invalidate(stockListProvider)),
        data: (all) {
          final items = _filter(all);
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              message: AppStrings.noStock,
            );
          }
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _grid(items),
          );
        },
      ),
    );
  }

  // ─── الغريد المعتمد ────────────────────────────────────────────────────────

  static const _fId = 'id';
  static const _fName = 'name';
  static const _fQty = 'qty';
  static const _fPurchase = 'purchase';
  static const _fSelling = 'selling';
  static const _fExpiry = 'expiry';
  static const _fReceived = 'received';
  static const _fActions = 'actions';

  Widget _grid(List<Stock> items) {
    final byId = {for (final s in items) s.id: s};
    return AppGrid(
      key: ValueKey(items.length ^ items.hashCode),
      columns: _columns(byId),
      rows: [for (final s in items) _row(s)],
      onLoaded: (m) => _gridManager = m,
      onRowDoubleTap: (e) {
        final s = byId[e.row.cells[_fId]?.value];
        if (s != null) _editStock(s);
      },
      // دفعة منتهية الصلاحية أو نفدت كميتها → تظليل تحذيري لكامل السطر.
      rowColorCallback: (ctx) {
        final s = byId[ctx.row.cells[_fId]?.value];
        if (s == null) return Colors.transparent;
        final expired =
            s.expiryDate != null && s.expiryDate!.isBefore(DateTime.now());
        if (expired || s.quantityAvailable <= 0) {
          return context.semantic.warning.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      },
    );
  }

  List<TrinaColumn> _columns(Map<String, Stock> byId) {
    return [
      appGridTextColumn(AppStrings.medicineName, _fName, width: 240, flexible: true),
      appGridNumberColumn(AppStrings.quantity, _fQty,
          width: 110, zeroAsBlank: false, renderer: (ctx) => _qtyCell(ctx, byId)),
      appGridNumberColumn(AppStrings.purchasePrice, _fPurchase, width: 120),
      appGridNumberColumn('سعر البيع', _fSelling, width: 120, hide: true),
      appGridTextColumn(AppStrings.expiryDateLabel, _fExpiry,
          width: 125,
          textAlign: TrinaColumnTextAlign.center,
          renderer: (ctx) => _expiryCell(ctx, byId)),
      appGridTextColumn('تاريخ الاستلام', _fReceived,
          width: 125, hide: true, textAlign: TrinaColumnTextAlign.center),
      TrinaColumn(
        title: '',
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 100,
        enableEditingMode: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableSorting: false,
        renderer: (ctx) {
          final s = byId[ctx.row.cells[_fId]?.value];
          if (s == null) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.edit,
                onPressed: () => _editStock(s),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 16, color: Theme.of(context).colorScheme.error),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.delete,
                onPressed: () => _delete(s),
              ),
            ],
          );
        },
      ),
      TrinaColumn(
          title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
    ];
  }

  Widget _qtyCell(TrinaColumnRendererContext ctx, Map<String, Stock> byId) {
    final s = byId[ctx.row.cells[_fId]?.value];
    final v = ctx.cell.value;
    final n = v is num ? v.toDouble() : 0.0;
    final low = s != null && s.quantityAvailable <= 0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        Formatters.qty(n),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: low
              ? Theme.of(context).colorScheme.error
              : context.semantic.success,
        ),
      ),
    );
  }

  Widget _expiryCell(TrinaColumnRendererContext ctx, Map<String, Stock> byId) {
    final s = byId[ctx.row.cells[_fId]?.value];
    if (s?.expiryDate == null) {
      return Text('—', style: TextStyle(color: Theme.of(context).hintColor));
    }
    final expired = s!.expiryDate!.isBefore(DateTime.now());
    return Text(
      AppDate.ymd(s.expiryDate!),
      textAlign: TextAlign.center,
      style: expired
          ? TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600)
          : null,
    );
  }

  TrinaRow<dynamic> _row(Stock s) {
    return TrinaRow(cells: {
      _fId: TrinaCell(value: s.id),
      _fName: TrinaCell(value: s.medicineName.isEmpty ? '—' : s.medicineName),
      _fQty: TrinaCell(value: s.quantityAvailable),
      _fPurchase: TrinaCell(value: s.purchasePrice),
      _fSelling: TrinaCell(value: s.sellingPrice),
      _fExpiry: TrinaCell(value: s.expiryDate != null ? AppDate.ymd(s.expiryDate!) : ''),
      _fReceived: TrinaCell(
          value: s.dateReceived != null ? AppDate.ymd(s.dateReceived!) : ''),
    });
  }
}

/// تعديل دفعة مخزون موجودة — بوب أب بأسلوب نوافذ ويندوز (رأس بأيقونة وعنوان
/// وزر إغلاق، وأزرار بحجم محتواها). الدواء ثابت؛ الحقول المعدَّلة: الكمية،
/// سعر الشراء، وتاريخ الصلاحية. يُغلق بـ true عند الحفظ بنجاح.
class _EditStockDialog extends ConsumerStatefulWidget {
  const _EditStockDialog({required this.stock});

  final Stock stock;

  @override
  ConsumerState<_EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends ConsumerState<_EditStockDialog> {
  late final _qty =
      TextEditingController(text: _plain(widget.stock.quantityAvailable));
  late final _purchase =
      TextEditingController(text: _plain(widget.stock.purchasePrice));
  late DateTime? _expiry = widget.stock.expiryDate;
  bool _saving = false;

  static String _plain(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _qty.dispose();
    _purchase.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qty.text.trim()) ?? 0;
    if (qty <= 0) {
      AppSnackbar.error(context, AppStrings.quantity);
      return;
    }
    setState(() => _saving = true);
    final s = widget.stock;
    final result = await ref.read(stockRepositoryProvider).update(
          s.id,
          UpdateStockInput(
            medicineId: s.medicineId,
            quantityAvailable: qty,
            purchasePrice: double.tryParse(_purchase.text.trim()) ?? 0,
            sellingPrice: s.sellingPrice,
            expiryDate: _expiry,
          ),
        );
    if (!mounted) return;
    result.fold(
      (_) => Navigator.of(context).pop(true),
      (failure) {
        setState(() => _saving = false);
        showFailureSnackbar(context, failure);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('تعديل المخزون',
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
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(widget.stock.medicineName,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.md),
              AppNumberField(
                controller: _qty,
                label: AppStrings.quantity,
                isRequired: true,
                enabled: !_saving,
              ),
              const SizedBox(height: AppSpacing.md),
              AppNumberField(
                controller: _purchase,
                label: AppStrings.purchasePrice,
                enabled: !_saving,
              ),
              const SizedBox(height: AppSpacing.md),
              AppDatePicker(
                label: AppStrings.expirationDate,
                value: _expiry,
                hint: AppStrings.expirationDate,
                enabled: !_saving,
                onChanged: (d) => setState(() => _expiry = d),
              ),
              const SizedBox(height: AppSpacing.md),
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
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
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
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(AppStrings.save),
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
