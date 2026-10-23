import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/stocks/domain/stock_adjustment.dart';
import 'package:saydaliati/features/stocks/stock_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';

/// حوار تسوية جرد دفعة واحدة — يضبط الكمية المتوفّرة إلى العدد الفعليّ.
/// الفرق (+/-) يُنشئ تلقائياً بالخادم حركة إدخال أو إخراج وقيداً محاسبياً
/// («فروق وتسويات المخزون») — لا شيء يُحسب أو يُرسَل من الواجهة غير الكمية
/// الفعلية الجديدة.
Future<bool> showAdjustStockDialog(
  BuildContext context, {
  required String medicineId,
  required String medicineName,
  required String warehouseId,
  required String warehouseName,
  required DateTime? expiryDate,
  required double currentQuantity,
}) async {
  final done = await showDialog<bool>(
    context: context,
    builder: (_) => _AdjustStockDialog(
      medicineId: medicineId,
      medicineName: medicineName,
      warehouseId: warehouseId,
      warehouseName: warehouseName,
      expiryDate: expiryDate,
      currentQuantity: currentQuantity,
    ),
  );
  return done ?? false;
}

class _AdjustStockDialog extends ConsumerStatefulWidget {
  const _AdjustStockDialog({
    required this.medicineId,
    required this.medicineName,
    required this.warehouseId,
    required this.warehouseName,
    required this.expiryDate,
    required this.currentQuantity,
  });

  final String medicineId;
  final String medicineName;
  final String warehouseId;
  final String warehouseName;
  final DateTime? expiryDate;
  final double currentQuantity;

  @override
  ConsumerState<_AdjustStockDialog> createState() => _AdjustStockDialogState();
}

class _AdjustStockDialogState extends ConsumerState<_AdjustStockDialog> {
  late final TextEditingController _qty =
      TextEditingController(text: Formatters.number(widget.currentQuantity));
  final _note = TextEditingController();
  bool _saving = false;
  String? _qtyError;

  @override
  void dispose() {
    _qty.dispose();
    _note.dispose();
    super.dispose();
  }

  double? get _parsedQty {
    final v = double.tryParse(_qty.text.trim().replaceAll(',', ''));
    if (v == null || v < 0) return null;
    return v;
  }

  double get _delta => (_parsedQty ?? widget.currentQuantity) - widget.currentQuantity;

  Future<void> _submit() async {
    final newQty = _parsedQty;
    if (newQty == null) {
      setState(() => _qtyError = 'أدخل كميةً صحيحة (صفر أو أكبر)');
      return;
    }
    if (newQty == widget.currentQuantity) {
      setState(() => _qtyError = 'الكمية لم تتغيّر — لا داعي للتسوية');
      return;
    }

    setState(() {
      _saving = true;
      _qtyError = null;
    });

    try {
      final adjust = ref.read(adjustStockProvider);
      final result = await adjust(AdjustStockInput(
        medicineId: widget.medicineId,
        warehouseId: widget.warehouseId,
        expiryDate: widget.expiryDate,
        newQuantity: newQty,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ));

      if (!mounted) return;
      Navigator.of(context).pop(true);
      final up = result.delta > 0;
      AppSnackbar.success(
        context,
        '${up ? 'إدخال' : 'إخراج'} تسوية بمقدار '
        '${Formatters.number(result.delta.abs())} — الكمية الآن '
        '${Formatters.number(result.newQuantity)}',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showFailureSnackbar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delta = _delta;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.fact_check_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Text('تسوية جرد',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BatchSummary(
              medicineName: widget.medicineName,
              warehouseName: widget.warehouseName,
              expiryDate: widget.expiryDate,
              currentQuantity: widget.currentQuantity,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _qty,
              label: 'الكمية الفعلية بعد الجرد',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              errorText: _qtyError,
              onChanged: (_) {
                if (_qtyError != null) setState(() => _qtyError = null);
                setState(() {}); // يحدّث سطر الفرق فوراً
              },
            ),
            if (delta != 0) ...[
              const SizedBox(height: AppSpacing.xs),
              _DeltaLine(delta: delta),
            ],
            const SizedBox(height: AppSpacing.sm),
            AppTextField(controller: _note, label: AppStrings.notes),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('تسوية'),
        ),
      ],
    );
  }
}

class _BatchSummary extends StatelessWidget {
  const _BatchSummary({
    required this.medicineName,
    required this.warehouseName,
    required this.expiryDate,
    required this.currentQuantity,
  });

  final String medicineName;
  final String warehouseName;
  final DateTime? expiryDate;
  final double currentQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppRadius.brSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(medicineName,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            [
              warehouseName,
              expiryDate != null
                  ? 'صلاحية ${AppDate.ymd(expiryDate!)}'
                  : AppStrings.notSet,
            ].where((s) => s.isNotEmpty).join(' · '),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text('الكمية الحالية: ${Formatters.number(currentQuantity)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DeltaLine extends StatelessWidget {
  const _DeltaLine({required this.delta});

  final double delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final up = delta > 0;
    final color = up ? Colors.green.shade700 : theme.colorScheme.error;
    return Row(
      children: [
        Icon(up ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            up
                ? 'سطر إدخال بمقدار ${Formatters.number(delta)}'
                : 'سطر إخراج بمقدار ${Formatters.number(delta.abs())}',
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
