import 'package:flutter/material.dart';
import 'package:saydaliati/features/tutorials/presentation/tutorial_help.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/currencies/currency_providers.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/adaptive_modal.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';
import 'package:trina_grid/trina_grid.dart';

/// "1 {code} = {X} {base}" — the natural human direction (e.g. 1 USD = 135 ل.س).
/// Internally `exchangeRate` is stored as foreign-units-per-1-base, so the
/// displayed per-foreign value is its reciprocal.
String _rateLine(Currency c, String? baseCode) {
  if (c.isBaseCurrency) return 'العملة الأساسية';
  if (c.exchangeRate <= 0) return 'سعر الصرف غير محدّد';
  final perForeign = 1 / c.exchangeRate; // كم من الأساسية تساوي 1 من هذه العملة
  return '1 ${c.code} = ${Formatters.number(perForeign)} ${baseCode ?? ''}'.trim();
}

/// Currencies management — the project-standard grid. The exchange-rate cell
/// edits IN PLACE: it renders as an editable field, and committing a new value
/// (leaving the cell / Enter) opens a confirmation popup before saving via the
/// dedicated exchange-rate endpoint.
class CurrenciesPage extends ConsumerStatefulWidget {
  const CurrenciesPage({super.key});

  @override
  ConsumerState<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends ConsumerState<CurrenciesPage> {
  TrinaGridStateManager? _gridManager;

  static const _fId = 'id';
  static const _fName = 'name';
  static const _fSymbol = 'symbol';
  static const _fRate = 'rate';
  static const _fEquation = 'equation';
  static const _fUpdated = 'updated';
  static const _fActions = 'actions';
  static const _fIsBase = 'isBase';

  void _refresh(WidgetRef ref) => ref.invalidate(currenciesProvider);

  /// تأكيد ثم حفظ سعر الصرف المعدَّل من الخلية؛ الإلغاء يعيد القيمة القديمة.
  ///
  /// تُقبل خليتان: «سعر الصرف» مباشرةً، أو «المعادلة» (1 {code} = X {أساسية})
  /// فتُحسب محلياً كمقلوبها (exchangeRate = 1 ÷ X) ثم تُرسل للسيرفر عبر نفس
  /// نقطة سعر الصرف المخصّصة.
  Future<void> _onRateCellChanged(
      TrinaGridOnChangedEvent event, Map<String, Currency> byId) async {
    final field = event.column.field;
    if (field != _fRate && field != _fEquation) return;
    final c = byId[event.row.cells[_fId]?.value];
    final entered = event.value is num
        ? (event.value as num).toDouble()
        : double.tryParse(event.value?.toString() ?? '');
    final oldValue = event.oldValue;

    void revert() {
      final cell = event.row.cells[field];
      if (cell != null && _gridManager != null) {
        _gridManager!.changeCellValue(cell, oldValue,
            force: true, callOnChangedEvent: false, notify: true);
      }
    }

    if (c == null || c.isBaseCurrency || entered == null || entered <= 0) {
      revert();
      return;
    }
    // المعادلة تُحوَّل محلياً إلى سعر الصرف المخزَّن (مقلوبها)، ويُحفظ
    // مباشرة من الخلية بلا نافذة تأكيد.
    final newRate = field == _fEquation ? 1 / entered : entered;
    if (newRate == c.exchangeRate) return;
    final result =
        await ref.read(currencyRepositoryProvider).setExchangeRate(c.id, newRate);
    if (!mounted) return;
    result.fold(
      (_) {
        _refresh(ref);
        ref.invalidate(currencyRateHistoryProvider(c.id));
        AppSnackbar.success(context, AppStrings.updatedSuccess);
      },
      (failure) {
        revert();
        showFailureSnackbar(context, failure);
      },
    );
  }

  Future<void> _addOrEdit(BuildContext context, WidgetRef ref,
      [Currency? existing]) async {
    final baseCode = ref.read(baseCurrencyProvider)?.code ?? '';
    final draft = await showDialog<_CurrencyDraft>(
      context: context,
      builder: (_) => _CurrencyFormDialog(existing: existing, baseCode: baseCode),
    );
    if (draft == null || !context.mounted) return;

    final repo = ref.read(currencyRepositoryProvider);
    final result = existing == null
        ? await repo.create(
            code: draft.code,
            name: draft.name,
            symbol: draft.symbol,
            exchangeRate: draft.rate,
            isBaseCurrency: draft.isBase,
            isActive: true,
          )
        : await repo.update(
            id: existing.id,
            code: draft.code,
            name: draft.name,
            symbol: draft.symbol,
            exchangeRate: draft.rate,
            isBaseCurrency: draft.isBase,
            isActive: existing.isActive,
          );
    if (!context.mounted) return;
    result.fold(
      (_) {
        _refresh(ref);
        AppSnackbar.success(context,
            existing == null ? AppStrings.createdSuccess : AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  /// Shows the rate-change history (rate + date) for a currency.
  Future<void> _showHistory(BuildContext context, WidgetRef ref, Currency c) async {
    final baseCode = ref.read(baseCurrencyProvider)?.code ?? '';
    await showAdaptiveModal<void>(
      context,
      builder: (_) => _RateHistorySheet(currency: c, baseCode: baseCode),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Currency c) async {
    final ok = await showDeleteConfirmationDialog(context, itemName: c.name);
    if (!ok || !context.mounted) return;
    final result = await ref.read(currencyRepositoryProvider).delete(c.id);
    if (!context.mounted) return;
    result.fold(
      (_) {
        _refresh(ref);
        AppSnackbar.success(context, AppStrings.deletedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(currenciesProvider);
    final baseCode = async.value
        ?.where((x) => x.isBaseCurrency)
        .map((x) => x.code)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.currenciesList),
        actions: [
          AppGridColumnsButton(managerGetter: () => _gridManager),
          IconButton(
            tooltip: AppStrings.addNew,
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEdit(context, ref),
          ),
          const TutorialHelpButton(TutorialTopic.currencies),
        ],
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            ErrorState.fromError(e, onRetry: () => _refresh(ref)),
        data: (currencies) {
          if (currencies.isEmpty) {
            return const EmptyState(message: AppStrings.noCurrencies);
          }
          final byId = {for (final c in currencies) c.id: c};
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppGrid(
              key: ValueKey(currencies.length ^ currencies.hashCode),
              columns: _columns(byId, baseCode),
              rows: [for (final c in currencies) _row(c, baseCode)],
              onLoaded: (m) => _gridManager = m,
              onChanged: (e) => _onRateCellChanged(e, byId),
              // لا فتح للنافذة بالنقر المزدوج: كان يتعارض مع تحرير خلية
              // سعر الصرف — التعديل الكامل من زر القلم في عمود الإجراءات.
            ),
          );
        },
      ),
    );
  }

  List<TrinaColumn> _columns(Map<String, Currency> byId, String? baseCode) {
    return [
      TrinaColumn(
        title: AppStrings.currenciesList,
        field: _fName,
        type: TrinaColumnType.text(),
        width: 200,
        enableEditingMode: false,
        renderer: (ctx) {
          final isBase = ctx.row.cells[_fIsBase]?.value == 'true';
          return Row(
            children: [
              Flexible(
                child: Text(ctx.cell.value?.toString() ?? '',
                    overflow: TextOverflow.ellipsis),
              ),
              if (isBase) ...[
                const SizedBox(width: AppSpacing.sm),
                _BaseBadge(),
              ],
            ],
          );
        },
      ),
      appGridTextColumn('الرمز', _fSymbol,
          width: 80, hide: true, textAlign: TrinaColumnTextAlign.center),
      // سعر الصرف — الخلية الوحيدة القابلة للتعديل: تُفتح بالنقر، وعند الخروج
      // منها بقيمة جديدة يظهر بوب أب تأكيد قبل الحفظ.
      TrinaColumn(
        title: AppStrings.editRate,
        field: _fRate,
        type: TrinaColumnType.number(
          format: '#,##0.####',
          locale: 'en',
          applyFormatOnInit: false,
        ),
        width: 130,
        textAlign: TrinaColumnTextAlign.center,
        enableEditingMode: true,
        // العملة الأساسية بلا سعر صرف — خليتها للقراءة فقط.
        checkReadOnly: (row, cell) =>
            row.cells[_fIsBase]?.value == 'true',
        renderer: (ctx) {
          final isBase = ctx.row.cells[_fIsBase]?.value == 'true';
          if (isBase) {
            return Text(AppStrings.baseCurrencyLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall);
          }
          final v = ctx.cell.value;
          final n = v is num ? v.toDouble() : 0.0;
          // تبدو قابلة للتغيير: قيمة بخط مميز + أيقونة قلم صغيرة.
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  n > 0 ? Formatters.number(n) : '—',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.edit_outlined, size: 13),
            ],
          );
        },
      ),
      // المعادلة — قابلة للتعديل أيضاً: أدخل كم تساوي 1 من هذه العملة
      // بالأساسية، ويُحسب سعر الصرف المخزَّن محلياً (المقلوب) قبل الإرسال.
      TrinaColumn(
        title: 'المعادلة',
        field: _fEquation,
        type: TrinaColumnType.number(
          format: '#,##0.####',
          locale: 'en',
          applyFormatOnInit: false,
        ),
        width: 200,
        textAlign: TrinaColumnTextAlign.center,
        enableEditingMode: true,
        checkReadOnly: (row, cell) => row.cells[_fIsBase]?.value == 'true',
        renderer: (ctx) {
          final isBase = ctx.row.cells[_fIsBase]?.value == 'true';
          if (isBase) return const SizedBox.shrink();
          final c = byId[ctx.row.cells[_fId]?.value];
          if (c == null) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _rateLine(c, baseCode),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.edit_outlined,
                  size: 13, color: Theme.of(context).hintColor),
            ],
          );
        },
      ),
      appGridTextColumn(AppStrings.lastUpdated, _fUpdated,
          width: 110, hide: true, textAlign: TrinaColumnTextAlign.center),
      TrinaColumn(
        title: '',
        field: _fActions,
        type: TrinaColumnType.text(),
        width: 120,
        enableEditingMode: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableSorting: false,
        renderer: (ctx) {
          final c = byId[ctx.row.cells[_fId]?.value];
          if (c == null) return const SizedBox.shrink();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.history, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.rateHistory,
                onPressed: () => _showHistory(context, ref, c),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.edit,
                onPressed: () => _addOrEdit(context, ref, c),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 16, color: Theme.of(context).colorScheme.error),
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.delete,
                onPressed: () => _delete(context, ref, c),
              ),
            ],
          );
        },
      ),
      TrinaColumn(
          title: '', field: _fId, type: TrinaColumnType.text(), hide: true),
      TrinaColumn(
          title: '', field: _fIsBase, type: TrinaColumnType.text(), hide: true),
    ];
  }

  TrinaRow<dynamic> _row(Currency c, String? baseCode) {
    return TrinaRow(
      cells: {
        _fId: TrinaCell(value: c.id),
        _fIsBase: TrinaCell(value: c.isBaseCurrency.toString()),
        _fName: TrinaCell(value: '${c.name} (${c.code})'),
        _fSymbol: TrinaCell(value: c.symbol),
        _fRate: TrinaCell(value: c.isBaseCurrency ? '' : c.exchangeRate),
        // قيمة رقمية (1 عملة = X أساسية) للتحرير؛ الرندرر يعرض نص المعادلة.
        _fEquation: TrinaCell(
            value: c.isBaseCurrency || c.exchangeRate <= 0
                ? ''
                : 1 / c.exchangeRate),
        _fUpdated: TrinaCell(
            value: c.rateUpdatedOn != null ? AppDate.ymd(c.rateUpdatedOn!) : ''),
      },
    );
  }
}

class _BaseBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = context.semantic.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(AppStrings.baseBadge,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
    );
  }
}

class _CurrencyDraft {
  const _CurrencyDraft(this.code, this.name, this.symbol, this.rate, this.isBase);
  final String code;
  final String name;
  final String symbol;
  final double rate;
  final bool isBase;
}

class _CurrencyFormDialog extends StatefulWidget {
  const _CurrencyFormDialog({this.existing, this.baseCode = ''});

  final Currency? existing;
  final String baseCode;

  @override
  State<_CurrencyFormDialog> createState() => _CurrencyFormDialogState();
}

class _CurrencyFormDialogState extends State<_CurrencyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.existing?.code ?? '');
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _symbol = TextEditingController(text: widget.existing?.symbol ?? '');
  // The base currency is fixed (set at registration) and can't be toggled here.
  late final bool _isBase = widget.existing?.isBaseCurrency ?? false;
  late double? _rate = widget.existing?.exchangeRate;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _symbol.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isBase && (_rate == null || _rate! <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.rateEnterPositive)),
      );
      return;
    }
    Navigator.of(context).pop(_CurrencyDraft(
      _code.text.trim(),
      _name.text.trim(),
      _symbol.text.trim(),
      _isBase ? 1 : (_rate ?? 1),
      _isBase,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 18),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس بأسلوب نوافذ ويندوز: أيقونة + عنوان + زر إغلاق صغير.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.currency_exchange_outlined,
                        color: theme.colorScheme.primary, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                            widget.existing == null
                                ? AppStrings.addCurrency
                                : AppStrings.editCurrency,
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextField(
                          controller: _name,
                          label: AppStrings.currencyName,
                          isRequired: true,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? AppStrings.requiredField
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                            controller: _code, label: AppStrings.currencyCode),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                            controller: _symbol,
                            label: AppStrings.currencySymbol),
                        const SizedBox(height: AppSpacing.md),
                        if (!_isBase)
                          _RateEntry(
                            code: widget.existing?.code ?? _code.text,
                            baseCode: widget.baseCode,
                            initialRate: widget.existing?.exchangeRate ?? 0,
                            onChanged: (r) => _rate = r,
                          )
                        else
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(AppStrings.baseCurrencyFixedNote,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: theme.hintColor)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
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
                        onPressed: () => Navigator.of(context).pop(),
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
                        onPressed: _submit,
                        child: const Text(AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bidirectional exchange-rate entry. The stored rate is always "how many units
/// of THIS currency equal 1 base". The user may type in either direction — handy
/// when the base is the smaller-valued currency (e.g. base SYP, 1 USD = 15000
/// SYP) so they type the big natural number and the tiny inverse is derived.
class _RateEntry extends StatefulWidget {
  const _RateEntry({
    required this.code,
    required this.baseCode,
    required this.initialRate,
    required this.onChanged,
  });

  final String code;
  final String baseCode;
  final double initialRate;
  final ValueChanged<double?> onChanged;

  @override
  State<_RateEntry> createState() => _RateEntryState();
}

class _RateEntryState extends State<_RateEntry> {
  // false → "1 base = X code" (X entered = stored rate).
  // true  → "1 code = X base" (stored rate = 1 / X).
  // Default to the natural direction «1 code = X base» (e.g. 1 دولار = 135 ل.س)
  // so typing 135 stores the correct 1/135 and the cost conversion isn't inverted.
  bool _inverse = true;
  late final TextEditingController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(
        text: widget.initialRate > 0
            ? _fmt(_inverse ? 1 / widget.initialRate : widget.initialRate)
            : '');
    _ctl.addListener(_emit);
  }

  @override
  void dispose() {
    _ctl.removeListener(_emit);
    _ctl.dispose();
    super.dispose();
  }

  double? get _rate {
    final v = double.tryParse(_ctl.text.trim());
    if (v == null || v <= 0) return null;
    return _inverse ? 1 / v : v;
  }

  void _emit() {
    widget.onChanged(_rate);
    if (mounted) setState(() {});
  }

  void _toggle(bool inverse) {
    if (inverse == _inverse) return;
    final r = _rate; // keep the same underlying rate; just flip the shown value
    setState(() {
      _inverse = inverse;
      if (r != null && r > 0) _ctl.text = _fmt(inverse ? 1 / r : r);
    });
    _emit();
  }

  // Adaptive formatting so tiny inverse rates (e.g. 0.0000667) stay readable.
  static String _fmt(double v) {
    if (v == 0) return '0';
    if (v.abs() >= 1) return Formatters.number(v);
    var s = v.toStringAsFixed(8);
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = widget.code.trim().isEmpty ? 'العملة' : widget.code.trim();
    final base = widget.baseCode.trim().isEmpty ? 'الأساسية' : widget.baseCode.trim();
    final r = _rate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text('١ $base = $code')),
            ButtonSegment(value: true, label: Text('١ $code = $base')),
          ],
          selected: {_inverse},
          onSelectionChanged: (s) => _toggle(s.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppNumberField(
          controller: _ctl,
          label: _inverse ? 'كم $base تساوي 1 $code؟' : 'كم $code تساوي 1 $base؟',
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          r == null
              ? AppStrings.rateEnterPositive
              : '١ $base = ${_fmt(r)} $code   •   ١ $code = ${_fmt(1 / r)} $base',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

/// Bottom sheet listing a currency's exchange-rate history (newest first).
class _RateHistorySheet extends ConsumerWidget {
  const _RateHistorySheet({required this.currency, required this.baseCode});

  final Currency currency;
  final String baseCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(currencyRateHistoryProvider(currency.id));
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${AppStrings.rateHistory} — ${currency.code}',
              style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: async.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: LoadingState(),
              ),
              error: (e, _) => ErrorState.fromError(
                e,
                onRetry: () =>
                    ref.invalidate(currencyRateHistoryProvider(currency.id)),
              ),
              data: (list) => list.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(AppStrings.noRateHistory,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor)),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final e = list[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.history),
                          title: Text(
                              '1 $baseCode = ${Formatters.number(e.rate)} ${currency.code}'
                                  .trim()),
                          subtitle: Text(AppDate.ymdHm(e.effectiveDate)),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
