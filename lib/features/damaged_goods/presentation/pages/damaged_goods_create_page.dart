import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/damaged_goods/damaged_goods_providers.dart';
import 'package:saydaliati/features/damaged_goods/domain/entities/create_damaged_goods_input.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/feedback/failure_snackbar.dart';
import 'package:saydaliati/shared/widgets/inputs/app_date_picker.dart';
import 'package:saydaliati/shared/widgets/inputs/app_number_field.dart';
import 'package:saydaliati/shared/widgets/inputs/app_text_field.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// صنف مؤقّت يمثّل سطراً واحداً في نموذج تسجيل البضاعة التالفة.
class _DamagedLine {
  _DamagedLine({required this.medicine}) {
    qty.text = '1';
  }

  final Medicine medicine;
  final qty = TextEditingController();
  final note = TextEditingController();

  void dispose() {
    qty.dispose();
    note.dispose();
  }
}

/// شاشة تسجيل بضاعة تالفة.
///
/// يختار المستخدم التاريخ وملاحظة عامة، ثم يضيف أسطراً: كل سطر يحدد دواءً وكمية
/// (وملاحظة اختيارية على السطر). عند الحفظ يُرسَل الطلب للخادم الذي يطبّق FEFO
/// داخلياً لتحديد أي الدفعات تُستنزَف.
class DamagedGoodsCreatePage extends ConsumerStatefulWidget {
  const DamagedGoodsCreatePage({super.key});

  @override
  ConsumerState<DamagedGoodsCreatePage> createState() =>
      _DamagedGoodsCreatePageState();
}

class _DamagedGoodsCreatePageState
    extends ConsumerState<DamagedGoodsCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  final List<_DamagedLine> _lines = [];
  bool _saving = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  void _addLine(Medicine medicine) {
    // منع تكرار نفس الدواء في السطر نفسه (يمكن دمج الكميات)
    setState(() => _lines.add(_DamagedLine(medicine: medicine)));
  }

  void _removeLine(int index) {
    final line = _lines.removeAt(index);
    line.dispose();
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      AppSnackbar.error(context, 'يجب إضافة صنف واحد على الأقل');
      return;
    }

    setState(() => _saving = true);
    try {
      final items = _lines.map((l) {
        final qty = double.tryParse(l.qty.text.trim()) ?? 0;
        return DamagedGoodsItemInput(
          medicineId: l.medicine.id,
          quantity: qty,
          note: l.note.text.trim().isEmpty ? null : l.note.text.trim(),
        );
      }).toList();

      final input = CreateDamagedGoodsInput(
        date: _date,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        items: items,
      );

      final result =
          await ref.read(damagedGoodsRepositoryProvider).create(input);

      if (!mounted) return;
      result.fold(
        (_) {
          AppSnackbar.success(context, 'تم تسجيل البضاعة التالفة بنجاح');
          Navigator.of(context).pop(true);
        },
        (failure) => showFailureSnackbar(context, failure),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicinesAsync = ref.watch(medicineCatalogProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل بضاعة تالفة'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: SizedBox(
              height: 36,
              child: FilledButton.icon(
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_outlined, size: 18),
                label: const Text('حفظ'),
                onPressed: _saving ? null : _save,
              ),
            ),
          ),
        ],
      ),
      body: medicinesAsync.when(
        loading: () => const LoadingState(message: 'جار تحميل الأدوية...'),
        error: (e, _) => ErrorState.fromError(e,
            onRetry: () => ref.invalidate(medicineCatalogProvider)),
        data: (medicines) => _buildForm(context, theme, medicines),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, ThemeData theme, List<Medicine> medicines) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // ── رأس الوثيقة ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('بيانات الوثيقة',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.md),
                  AppDatePicker(
                    label: 'التاريخ',
                    value: _date,
                    lastDate: DateTime.now(),
                    onChanged: (d) => setState(() => _date = d),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _noteCtrl,
                    label: 'ملاحظة عامة',
                    hint: 'سبب الإتلاف أو أي تفصيل (اختياري)',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── أسطر البضاعة التالفة ─────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('الأصناف التالفة',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        '${_lines.length} صنف',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // أسطر مضافة
                  for (var i = 0; i < _lines.length; i++) ...[
                    _LineCard(
                      index: i,
                      line: _lines[i],
                      onRemove: () => _removeLine(i),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  // حقل إضافة صنف جديد
                  MedicinePickerField(
                    medicines: medicines,
                    hint: 'إضافة صنف تالف...',
                    onSelected: _addLine,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة سطر واحد في قائمة البضاعة التالفة.
class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.index,
    required this.line,
    required this.onRemove,
  });

  final int index;
  final _DamagedLine line;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
        borderRadius: AppRadius.brMd,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم الدواء + زر الحذف
          Row(
            children: [
              Icon(Icons.medication_outlined,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  line.medicine.displayName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'إزالة',
                visualDensity: VisualDensity.compact,
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كمية
              Expanded(
                child: AppNumberField(
                  controller: line.qty,
                  label: 'الكمية',
                  hint: '0',
                  isRequired: true,
                  validator: (v) {
                    final n = double.tryParse(v?.trim() ?? '');
                    if (n == null || n <= 0) return 'كمية غير صالحة';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // ملاحظة على السطر
              Expanded(
                flex: 2,
                child: AppTextField(
                  controller: line.note,
                  label: 'ملاحظة (اختياري)',
                  hint: 'سبب خاص بهذا الصنف',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
