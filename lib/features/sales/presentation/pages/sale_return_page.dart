import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/sales/domain/entities/sale_return.dart';
import 'package:saydaliati/features/sales/sale_providers.dart';
import 'package:saydaliati/features/shortcuts/domain/shortcut_action.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcuts_scope.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/grids/grid_line_focus.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// مرتجع مبيعات جزئي — مستند مستقل عن الفاتورة الأصلية (لا يُعدّلها)؛ يعيد
/// الكمية المُرتجَعة للمخزون ويُصحّح ذمّة العميل تلقائياً إن كانت الفاتورة
/// آجلة. أسطر الفاتورة القابلة للإرجاع بنفس غريد التطبيق الموحّد (AppGrid) —
/// خلية «الكمية المرتجعة» وحدها قابلة للتحرير.
class SaleReturnPage extends ConsumerStatefulWidget {
  const SaleReturnPage({required this.saleId, required this.invoiceNumber, super.key});

  final String saleId;
  final int invoiceNumber;

  @override
  ConsumerState<SaleReturnPage> createState() => _SaleReturnPageState();
}

class _SaleReturnPageState extends ConsumerState<SaleReturnPage> {
  static const _fId = 'saleItemId';
  static const _fMed = 'medicine';
  static const _fUnit = 'unit';
  static const _fPrice = 'price';
  static const _fSold = 'sold';
  static const _fRemaining = 'remaining';
  static const _fQty = 'qty';
  static const _fTotal = 'total';

  final _reason = TextEditingController();

  /// الكمية المدخَلة للإرجاع، مفهرسة بمعرّف سطر الفاتورة الأصلي.
  final Map<String, double> _quantities = {};

  /// مُعرّفات الأسطر المعروضة — تُحدَّث عند بناء الشبكة، فيقرأها
  /// [GridLineFocus] ليعرف «آخر سطر».
  List<String> _rowIds = const [];

  /// تتبُّع السطر النشِط: بلا تحديد يكون **آخر سطر** هو النشِط، فيعمل
  /// اختصار الكمية بلا نقرة — كما في فاتورة المبيعات.
  late final GridLineFocus _focus = GridLineFocus(
    idField: _fId,
    qtyField: _fQty,
    rowIds: () => _rowIds,
    isMounted: () => mounted,
  );

  late final ShortcutRegistration _shortcuts = ShortcutRegistration(ref, this);

  @override
  void initState() {
    super.initState();
    _shortcuts.bind({
      ShortcutAction.invoiceEditQty: _editCurrentQuantity,
      // «حذف السطر» في المرتجع = تصفير كميته: الأسطر تأتي من الفاتورة
      // الأصلية فلا تُحذَف، والمقصود إلغاء إرجاعها.
      ShortcutAction.invoiceDeleteLine: _clearCurrentQuantity,
    });
  }

  void _editCurrentQuantity() {
    if (_rowIds.isEmpty) return;
    _focus.focusQty(startEditing: true);
  }

  void _clearCurrentQuantity() {
    final id = _focus.currentId;
    if (id == null) return;
    setState(() => _quantities.remove(id));
  }

  @override
  void dispose() {
    _focus.dispose();
    _shortcuts.dispose();
    _reason.dispose();
    super.dispose();
  }

  double _totalFor(List<SaleReturnableLine> lines) {
    var total = 0.0;
    for (final line in lines) {
      total += (_quantities[line.saleItemId] ?? 0) * line.unitPrice;
    }
    return total;
  }

  Future<void> _submit(List<SaleReturnableLine> lines) async {
    if (_submitting) return;

    final returnLines = <SaleReturnLineInput>[];
    for (final line in lines) {
      final qty = _quantities[line.saleItemId] ?? 0;
      if (qty <= 0) continue;
      returnLines.add(SaleReturnLineInput(saleItemId: line.saleItemId, quantity: qty));
    }

    if (returnLines.isEmpty) {
      AppSnackbar.error(context, 'حدّد كمية صنف واحد على الأقل لإرجاعه');
      return;
    }

    setState(() => _submitting = true);
    final result = await ref.read(saleReturnRepositoryProvider).createReturn(
          CreateSaleReturnInput(
            saleId: widget.saleId,
            reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
            lines: returnLines,
          ),
        );
    if (!mounted) return;
    result.fold(
      (_) {
        AppSnackbar.success(context, 'تم تسجيل مرتجع المبيعات بنجاح');
        Navigator.of(context).pop(true);
      },
      (failure) {
        setState(() => _submitting = false);
        showFailureSnackbar(context, failure);
      },
    );
  }

  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(saleReturnableLinesProvider(widget.saleId));

    return Scaffold(
      appBar: AppBar(
        title: Text('مرتجع مبيعات — ${AppStrings.invoiceLabel} #${widget.invoiceNumber}'),
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(saleReturnableLinesProvider(widget.saleId))),
        data: (lines) => _content(context, lines),
      ),
    );
  }

  Widget _content(BuildContext context, List<SaleReturnableLine> allLines) {
    // أسطر نفدت فرصة إرجاعها بالكامل لا تُعرض — لا شيء لإرجاعه منها.
    final lines = allLines.where((l) => l.remainingQuantity > 0).toList();

    if (lines.isEmpty) {
      return const EmptyState(
        icon: Icons.assignment_return_outlined,
        message: 'كل أصناف هذه الفاتورة أُرجعت بالكامل مسبقاً',
      );
    }

    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _grid(lines),
          ),
        ),
        _bottomBar(theme, lines),
      ],
    );
  }

  Widget _grid(List<SaleReturnableLine> lines) {
    _rowIds = [for (final l in lines) l.saleItemId];

    return AppGrid(
      onLoaded: _focus.attach,
      showColumnFilter: false,
      columns: [
        TrinaColumn(title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
        appGridTextColumn('الدواء', _fMed, width: 220, flexible: true),
        appGridTextColumn('الوحدة', _fUnit, width: 90),
        appGridNumberColumn('سعر الوحدة', _fPrice, width: 100),
        appGridNumberColumn('الكمية المباعة', _fSold, width: 110),
        appGridNumberColumn('المتبقّي القابل للإرجاع', _fRemaining, width: 150),
        TrinaColumn(
          title: 'الكمية المرتجعة',
          field: _fQty,
          type: TrinaColumnType.number(
              format: '#,##0.##', locale: 'en', applyFormatOnInit: false),
          width: 130,
          textAlign: TrinaColumnTextAlign.center,
          enableEditingMode: true,
        ),
        appGridNumberColumn('الإجمالي', _fTotal, width: 120,
            renderer: (ctx) {
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          if (n == 0) return const SizedBox.shrink();
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              Formatters.number(n),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700),
            ),
          );
        }),
      ],
      rows: [
        for (final l in lines)
          TrinaRow(cells: {
            _fId: TrinaCell(value: l.saleItemId),
            _fMed: TrinaCell(value: l.medicineName),
            _fUnit: TrinaCell(value: l.unitName),
            _fPrice: TrinaCell(value: l.unitPrice),
            _fSold: TrinaCell(value: l.originalQuantity),
            _fRemaining: TrinaCell(value: l.remainingQuantity),
            _fQty: TrinaCell(value: _quantities[l.saleItemId] ?? ''),
            _fTotal: TrinaCell(value: (_quantities[l.saleItemId] ?? 0) * l.unitPrice),
          }),
      ],
      onChanged: (e) {
        if (e.column.field != _fQty) return;
        final id = e.row.cells[_fId]?.value?.toString();
        if (id == null) return;
        SaleReturnableLine? line;
        for (final l in lines) {
          if (l.saleItemId == id) {
            line = l;
            break;
          }
        }
        if (line == null) return;

        final v = e.value is num
            ? (e.value as num).toDouble()
            : double.tryParse(e.value?.toString() ?? '');
        if (v == null || v < 0 || v > line.remainingQuantity) {
          AppSnackbar.error(context,
              'الكمية المدخلة لـ ${line.medicineName} يجب ألا تتجاوز المتبقّي (${Formatters.qty(line.remainingQuantity)})');
          return;
        }
        setState(() => _quantities[id] = v);
      },
    );
  }

  Widget _bottomBar(ThemeData theme, List<SaleReturnableLine> lines) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AppTextField(controller: _reason, label: 'سبب الإرجاع (اختياري)'),
          ),
          const SizedBox(width: AppSpacing.lg),
          Text('الإجمالي: ', style: theme.textTheme.bodyMedium),
          Text(
            Formatters.money(_totalFor(lines)),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: AppSpacing.lg),
          SizedBox(
            width: 180,
            child: AppButton.primary(
              label: _submitting ? AppStrings.saving : 'تأكيد المرتجع',
              icon: Icons.assignment_return_outlined,
              isLoading: _submitting,
              onPressed: () => _submit(lines),
            ),
          ),
        ],
      ),
    );
  }
}
