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
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/buttons/app_button.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// "1 {code} = {X} {base}" — the natural human direction (e.g. 1 USD = 135 ل.س).
/// Internally `exchangeRate` is stored as foreign-units-per-1-base, so the
/// displayed per-foreign value is its reciprocal.
String _rateLine(Currency c, String? baseCode) {
  if (c.isBaseCurrency) return 'العملة الأساسية';
  if (c.exchangeRate <= 0) return 'سعر الصرف غير محدّد';
  final perForeign = 1 / c.exchangeRate; // كم من الأساسية تساوي 1 من هذه العملة
  return '1 ${c.code} = ${Formatters.number(perForeign)} ${baseCode ?? ''}'.trim();
}

/// Currencies management — list + add/edit/delete (base is fixed at registration).
class CurrenciesPage extends ConsumerWidget {
  const CurrenciesPage({super.key});

  void _refresh(WidgetRef ref) => ref.invalidate(currenciesProvider);

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

  /// Quick action: edit only the exchange rate. Uses the dedicated exchange-rate
  /// endpoint (the generic update preserves the rate on the backend), which also
  /// records a history entry.
  Future<void> _editRate(BuildContext context, WidgetRef ref, Currency c) async {
    final baseCode = ref.read(baseCurrencyProvider)?.code ?? '';
    final newRate = await showDialog<double>(
      context: context,
      builder: (_) => _RateDialog(code: c.code, baseCode: baseCode, initial: c.exchangeRate),
    );
    if (newRate == null || !context.mounted) return;

    final result =
        await ref.read(currencyRepositoryProvider).setExchangeRate(c.id, newRate);
    if (!context.mounted) return;
    result.fold(
      (_) {
        _refresh(ref);
        ref.invalidate(currencyRateHistoryProvider(c.id));
        AppSnackbar.success(context, AppStrings.updatedSuccess);
      },
      (failure) => showFailureSnackbar(context, failure),
    );
  }

  /// Shows the rate-change history (rate + date) for a currency.
  Future<void> _showHistory(BuildContext context, WidgetRef ref, Currency c) async {
    final baseCode = ref.read(baseCurrencyProvider)?.code ?? '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(currenciesProvider);
    final baseCode = async.value
        ?.where((x) => x.isBaseCurrency)
        .map((x) => x.code)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.currenciesList),
          actions: const [TutorialHelpButton(TutorialTopic.currencies)]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(context, ref),
        child: const Icon(Icons.add),
      ),
      body: AsyncListView<Currency>(
        value: async,
        emptyMessage: AppStrings.noCurrencies,
        onRefresh: () => ref.refresh(currenciesProvider.future),
        itemBuilder: (context, c) => ListTile(
          leading: const Icon(Icons.attach_money),
          title: Row(
            children: [
              Flexible(child: Text('${c.name} (${c.code})',
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (c.isBaseCurrency) ...[
                const SizedBox(width: AppSpacing.sm),
                _BaseBadge(),
              ],
            ],
          ),
          isThreeLine: !c.isBaseCurrency && c.rateUpdatedOn != null,
          subtitle: Text(
            c.isBaseCurrency
                ? AppStrings.baseCurrencyLabel
                : c.rateUpdatedOn == null
                    ? _rateLine(c, baseCode)
                    : '${_rateLine(c, baseCode)}\n${AppStrings.lastUpdated}: ${AppDate.ymd(c.rateUpdatedOn!)}',
          ),
          onTap: () => _addOrEdit(context, ref, c),
          trailing: PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'rate') _editRate(context, ref, c);
              if (v == 'history') _showHistory(context, ref, c);
              if (v == 'delete') _delete(context, ref, c);
            },
            itemBuilder: (_) => [
              if (!c.isBaseCurrency)
                const PopupMenuItem(value: 'rate', child: Text(AppStrings.editRate)),
              const PopupMenuItem(value: 'history', child: Text(AppStrings.rateHistory)),
              const PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
            ],
          ),
        ),
      ),
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
    return AlertDialog(
      scrollable: true,
      title: Text(widget.existing == null
          ? AppStrings.addCurrency
          : AppStrings.editCurrency),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _name,
              label: AppStrings.currencyName,
              isRequired: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(controller: _code, label: AppStrings.currencyCode),
            const SizedBox(height: AppSpacing.md),
            AppTextField(controller: _symbol, label: AppStrings.currencySymbol),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor)),
              ),
          ],
        ),
      ),
      actions: [
        AppButton.text(
            label: AppStrings.cancel, onPressed: () => Navigator.of(context).pop()),
        AppButton.primary(
            label: AppStrings.save, fullWidth: false, onPressed: _submit),
      ],
    );
  }
}

/// Quick rate-edit dialog that owns its controller. Returns the parsed rate or
/// null on cancel. Shows a clear direction hint ("كم وحدة من X تساوي 1 BASE").
class _RateDialog extends StatefulWidget {
  const _RateDialog(
      {required this.code, required this.baseCode, required this.initial});

  final String code;
  final String baseCode;
  final double initial;

  @override
  State<_RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<_RateDialog> {
  double? _rate;

  @override
  void initState() {
    super.initState();
    _rate = widget.initial > 0 ? widget.initial : null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.editRate),
      content: _RateEntry(
        code: widget.code,
        baseCode: widget.baseCode,
        initialRate: widget.initial,
        onChanged: (r) => _rate = r,
      ),
      actions: [
        AppButton.text(
            label: AppStrings.cancel,
            onPressed: () => Navigator.of(context).pop()),
        AppButton.primary(
            label: AppStrings.save,
            fullWidth: false,
            onPressed: () => Navigator.of(context).pop(_rate)),
      ],
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
