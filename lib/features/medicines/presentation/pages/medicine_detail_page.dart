import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_breakpoints.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/alternatives/presentation/pages/alternatives_page.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/medicine_providers.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/reports/presentation/pages/medicine_report_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// Read-only medicine details + its priced units.
class MedicineDetailPage extends ConsumerWidget {
  const MedicineDetailPage({required this.medicine, super.key});

  final Medicine medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // عملة أسعار الدواء + العملة الأساسية (للعرض وحساب المعادل بالعملة الأساسية).
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final base = ref.watch(baseCurrencyProvider);
    Currency? medCurrency;
    for (final c in currencies) {
      if (c.code == medicine.currency) {
        medCurrency = c;
        break;
      }
    }
    final symbol = medCurrency?.symbol ?? base?.symbol ?? 'ل.س';

    // رقم سعري + العملة بجانبه، ومعادله بالعملة الأساسية إن اختلفت عنها.
    String priced(double v) {
      final native = Formatters.money(v, symbol);
      if (medCurrency != null &&
          base != null &&
          medCurrency.id != base.id &&
          medCurrency.exchangeRate > 0 &&
          base.exchangeRate > 0) {
        final inBase = convertToBase(v, base, medCurrency);
        return '$native  (≈ ${Formatters.money(inBase, base.symbol)})';
      }
      return native;
    }
    // بطاقة الدواء كغريد واحد (حقل/قيمة): واصفات الدواء كصفوف عادية، والوحدات
    // كصفّ أب «الوحدات» قابل للتوسيع يحمل كل وحدة وسعرها كأبناء — شجرة واحدة.
    final infoRows = <(String, String)>[
      (AppStrings.dosageForm, medicine.dosageForm.label),
      if (medicine.genericName.isNotEmpty)
        ('المادة الفعّالة', medicine.genericName),
      if (medicine.categoryName != null)
        (AppStrings.category, medicine.categoryName!),
      if (medicine.manufacturerName != null)
        (AppStrings.manufacturer, medicine.manufacturerName!),
      if (medicine.barcode.isNotEmpty) (AppStrings.barcode, medicine.barcode),
      if (medicine.purchaseCost > 0)
        (AppStrings.purchaseCostLabel, priced(medicine.purchaseCost)),
    ];

    final detailsGrid = AppGrid(
      tree: true,
      showColumnFilter: false,
      columns: [
        appGridTextColumn('الوصف', 'field', width: 200),
        appGridTextColumn('القيمة', 'value', width: 320, flexible: true),
      ],
      rows: [
        for (final (f, v) in infoRows)
          TrinaRow(cells: {
            'field': TrinaCell(value: f),
            'value': TrinaCell(value: v),
          }),
        if (medicine.units.isNotEmpty)
          TrinaRow(
            cells: {
              'field': TrinaCell(value: AppStrings.units),
              'value': TrinaCell(value: '${medicine.units.length}'),
            },
            type: TrinaRowType.group(
              children: FilteredList(
                initialList: [
                  for (final u in medicine.units)
                    TrinaRow(cells: {
                      'field': TrinaCell(value: u.unitName),
                      'value': TrinaCell(value: priced(u.salePrice)),
                    }),
                ],
              ),
            ),
          ),
      ],
    );

    // العمود الجانبي: مزامنة السعر (شيك بوكس) + بطاقة البدائل (بنفس أسلوب
    // بطاقة المزامنة، لا زر ممتد).
    final sidePanel = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AutoPriceSyncTile(medicine: medicine),
        const SizedBox(height: AppSpacing.md),
        _AlternativesTile(medicine: medicine),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.displayName,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: AppStrings.medicineReport,
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MedicineReportPage(medicineId: medicine.id),
              ),
            ),
          ),
        ],
      ),
      // SizedBox.expand يضمن وصول قيود عرض/ارتفاع محدَّدة (tight) إلى
      // LayoutBuilder — وإلا قد لا يتحوّل التخطيط إلى العريض على سطح المكتب،
      // ويتلقّى الغريد ارتفاعاً غير مضبوط فيظهر مصغّراً كأنه قياس هاتف.
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedContent(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= AppBreakpoints.medium;
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: detailsGrid),
                      const SizedBox(width: AppSpacing.lg),
                      SizedBox(width: 340, child: sidePanel),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sidePanel,
                    const SizedBox(height: AppSpacing.md),
                    Expanded(child: detailsGrid),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Per-medicine «تحديث السعر تلقائياً» switch. Default ON. Toggling persists to
/// the backend and patches the in-memory catalog so the state sticks.
class _AutoPriceSyncTile extends ConsumerStatefulWidget {
  const _AutoPriceSyncTile({required this.medicine});

  final Medicine medicine;

  @override
  ConsumerState<_AutoPriceSyncTile> createState() => _AutoPriceSyncTileState();
}

class _AutoPriceSyncTileState extends ConsumerState<_AutoPriceSyncTile> {
  late bool _enabled = widget.medicine.autoPriceSync;
  bool _busy = false;

  Future<void> _toggle(bool v) async {
    final previous = _enabled;
    setState(() {
      _enabled = v;
      _busy = true;
    });
    try {
      await ref.read(medicineRemoteDataSourceProvider).setAutoPriceSync(widget.medicine.id, v);
      // patch the in-memory catalog so the new value survives navigation.
      ref.read(medicineCatalogProvider.notifier)
          .upsert(widget.medicine.copyWith(autoPriceSync: v));
    } catch (e) {
      if (mounted) {
        setState(() => _enabled = previous); // revert on failure
        AppSnackbar.info(context, 'تعذّر حفظ الإعداد: $e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: CheckboxListTile(
        value: _enabled,
        onChanged: _busy ? null : (v) => _toggle(v ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        secondary: const Icon(Icons.price_change_outlined),
        title: const Text('تحديث السعر تلقائياً'),
        subtitle: Text(
          'عند مزامنة الأسعار، يُحدَّث سعر هذا الدواء من الكاتلوغ العام. أوقِفه للاحتفاظ بسعرك الخاص.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }
}

/// بطاقة «عرض البدائل» — بنفس أسلوب بطاقة مزامنة السعر (لا زر ممتد).
class _AlternativesTile extends StatelessWidget {
  const _AlternativesTile({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => AlternativesPage(medicine: medicine),
          ),
        ),
        leading: Icon(Icons.swap_horiz_rounded, color: theme.colorScheme.primary),
        title: const Text('عرض البدائل'),
        subtitle: Text(
          'أدوية أخرى بنفس المادة الفعّالة',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}
