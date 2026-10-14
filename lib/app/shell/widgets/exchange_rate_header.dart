import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/currency_providers.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';

/// أسعار صرف العملات الرئيسية (غير الأساسية) — مثبّتة بأعلى يمين الشاشة
/// دوماً (بشريط العنوان، يظهر على كل الصفحات)، مع إمكانية تعديلها بالنقر
/// وتأكيد قبل الحفظ الفعلي (يؤثر مباشرة بتسعير المبيعات/المشتريات الجديدة).
class ExchangeRateHeader extends ConsumerWidget {
  const ExchangeRateHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);
    final foreign = currencies
        .where((c) => !c.isBaseCurrency && c.isActive && c.exchangeRate > 0)
        .toList();
    if (base == null || foreign.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in foreign)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
            child: _RateChip(currency: c, base: base),
          ),
      ],
    );
  }
}

class _RateChip extends StatelessWidget {
  const _RateChip({required this.currency, required this.base});

  final Currency currency;
  final Currency base;

  /// كم من الأساسية يساوي 1 من هذه العملة — الاتجاه المألوف للمستخدم
  /// (exchangeRate المخزَّن هو مقلوبها: وحدات هذه العملة لكل 1 أساسية).
  double get _perForeign => 1 / currency.exchangeRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppRadius.brSm,
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _RateEditDialog(currency: currency, base: base),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.brSm,
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.currency_exchange, size: 13, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '1 ${currency.code} = ${Formatters.number(_perForeign)} ${base.code}',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// حوار تعديل سعر الصرف — بأسلوب نوافذ ويندوز الموحَّد بالتطبيق: رأس بأيقونة
/// + عنوان + إغلاق، معاينة فورية للفرق بين القديم والجديد، وتأكيد إضافي قبل
/// الحفظ الفعلي (التغيير يؤثر مباشرة بتسعير العمليات الجديدة).
class _RateEditDialog extends ConsumerStatefulWidget {
  const _RateEditDialog({required this.currency, required this.base});

  final Currency currency;
  final Currency base;

  @override
  ConsumerState<_RateEditDialog> createState() => _RateEditDialogState();
}

class _RateEditDialogState extends ConsumerState<_RateEditDialog> {
  late final double _oldRate = 1 / widget.currency.exchangeRate;
  late final _controller =
      TextEditingController(text: Formatters.number(_oldRate));
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  double? get _entered => double.tryParse(_controller.text.trim());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final entered = _entered;
    if (entered == null || entered <= 0) return;
    if (entered == _oldRate) {
      Navigator.of(context).pop();
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'تأكيد تغيير سعر الصرف',
      message: 'سيتغيّر سعر صرف ${widget.currency.code} من '
          '${Formatters.number(_oldRate)} إلى ${Formatters.number(entered)} '
          '${widget.base.code}.\nهذا يؤثر فوراً على تسعير العمليات الجديدة. متابعة؟',
      confirmLabel: AppStrings.confirm,
      icon: Icons.currency_exchange,
    );
    if (!confirmed || !mounted) return;

    setState(() => _saving = true);
    // exchangeRate المخزَّن = وحدات هذه العملة لكل 1 أساسية، أي مقلوب القيمة
    // البشرية المُدخَلة هنا.
    final result = await ref
        .read(currencyRepositoryProvider)
        .setExchangeRate(widget.currency.id, 1 / entered);
    if (!mounted) return;

    result.fold(
      (_) {
        ref.invalidate(currenciesProvider);
        AppSnackbar.success(context, AppStrings.updatedSuccess);
        Navigator.of(context).pop();
      },
      (failure) {
        setState(() => _saving = false);
        showFailureSnackbar(context, failure);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entered = _entered;
    final changed = entered != null && entered > 0 && entered != _oldRate;

    return PopScope(
      canPop: !_saving,
      child: Dialog(
        backgroundColor: theme.colorScheme.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 18),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.currency_exchange,
                          color: theme.colorScheme.primary, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('سعر صرف ${widget.currency.code}',
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
                  Text(
                    'السعر الحالي: 1 ${widget.currency.code} = '
                    '${Formatters.number(_oldRate)} ${widget.base.code}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _controller,
                    autofocus: true,
                    enabled: !_saving,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: '1 ${widget.currency.code} = ؟ ${widget.base.code}',
                      prefixIcon: const Icon(Icons.price_change_outlined),
                    ),
                    validator: (v) {
                      final n = double.tryParse((v ?? '').trim());
                      return (n == null || n <= 0) ? AppStrings.requiredField : null;
                    },
                  ),
                  if (changed) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: AppRadius.brSm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            entered! > _oldRate
                                ? Icons.trending_up
                                : Icons.trending_down,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${Formatters.number(_oldRate)} ← ${Formatters.number(entered)} ${widget.base.code}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
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
                                  width: 16,
                                  height: 16,
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
        ),
      ),
    );
  }
}
