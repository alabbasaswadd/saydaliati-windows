import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/medicines/domain/entities/medicine.dart';
import 'package:saydaliati/features/medicines/presentation/providers/medicines_provider.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/medicine_picker_field.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_create_page.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_detail_page.dart';
import 'package:saydaliati/features/purchases/purchase_providers.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/shared/widgets/cards/invoice_card.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// فواتير المشتريات — نفس بناء [SalesListPage] حرفياً: شريط علوي بزرّ فلاتر،
/// لوحة فلاتر جانبية، وشبكة بطاقات. زرّ التعديل يفتح شاشة الإنشاء نفسها مملوءة
/// بالفاتورة، فالتعديل يجري بالأسلوب الذي أُنشئت به.
///
/// الفلترة هنا محلّية (نقطة `purchasesList` لا تقبل معاملات) — والنتيجة للمستخدم
/// واحدة.
class PurchasesListPage extends ConsumerStatefulWidget {
  const PurchasesListPage({super.key});

  @override
  ConsumerState<PurchasesListPage> createState() => _PurchasesListPageState();
}

class _PurchasesListPageState extends ConsumerState<PurchasesListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ReportPeriod? _period;
  String? _medicineId;

  bool get _hasFilters => _period != null || _medicineId != null;

  void _clear() => setState(() {
        _period = null;
        _medicineId = null;
      });

  Future<void> _edit(Purchase purchase) =>
      _open(PurchaseCreatePage(purchaseToEdit: purchase));

  Future<void> _open(Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    if (!mounted) return;
    // العودة من التعديل تُحدِّث القائمة بلا تدخّل المستخدم.
    ref.invalidate(purchasesListProvider);
  }

  bool _matches(Purchase p) {
    final period = _period;
    if (period != null) {
      final d = p.purchaseDate;
      if (d.isBefore(period.start) || !d.isBefore(period.end)) return false;
    }
    final medicineId = _medicineId;
    if (medicineId != null &&
        !p.items.any((i) => i.medicineId == medicineId)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(purchasesListProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('فواتير المشتريات'),
        actions: [
          IconButton(
            tooltip: AppStrings.refreshData,
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(purchasesListProvider),
          ),
          IconButton(
            tooltip: AppStrings.filters,
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Badge(
              isLabelVisible: _hasFilters,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      endDrawer: _FilterDrawer(
        period: _period,
        medicineId: _medicineId,
        onClear: _hasFilters ? _clear : null,
        onPeriod: (p) => setState(() => _period = p),
        onMedicine: (v) => setState(() => _medicineId = v),
      ),
      // بطاقات: كل فاتورة تُقرأ بلمحة (الرقم، التاريخ، أصنافها، مبلغها) وفيها
      // زر التعديل صريحاً.
      body: async.when(
        loading: () => const LoadingState(message: AppStrings.loading),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(purchasesListProvider),
        ),
        data: (purchases) {
          final items = purchases.where(_matches).toList();
          if (items.isEmpty) {
            return EmptyState(
              message: _hasFilters
                  ? 'لا توجد فاتورة مطابقة'
                  : AppStrings.noPurchases,
              icon: Icons.local_shipping_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(purchasesListProvider),
            child: InvoiceCardsGrid(
              children: [for (final p in items) _card(p)],
            ),
          );
        },
      ),
    );
  }

  Widget _card(Purchase purchase) {
    return InvoiceCard(
      icon: Icons.local_shipping_outlined,
      invoiceNumber: purchase.invoiceNumber,
      dateLabel: AppDate.ymd(purchase.purchaseDate),
      itemsCount: purchase.items.length,
      itemsPreview: _preview(purchase.items.map((e) => e.medicineName)),
      amount: purchase.totalAmount,
      currencyCode: '',
      onTap: () => _open(PurchaseDetailPage(purchase: purchase)),
      onEdit: () => _edit(purchase),
      // لا حذف لفواتير الشراء: الخادم لا يوفّر نقطة حذف (التعديل يعكس المخزون
      // ويعيد تطبيقه، أما الحذف فغير مدعوم).
    );
  }

  /// أول صنفين وعدد الباقي — يكفي للتعرّف على الفاتورة بلا فتحها.
  static String _preview(Iterable<String> names) {
    final list = names.where((n) => n.isNotEmpty).toList();
    if (list.isEmpty) return '';
    final shown = list.take(2).join('، ');
    final extra = list.length - 2;
    return extra > 0 ? '$shown +$extra' : shown;
  }
}

/// لوحة فلاتر المشتريات — نفس أسلوب لوحة المبيعات: تقرأ مصادرها بنفسها وتُبلّغ
/// الصفحة بكل تغيير عبر `on*`.
class _FilterDrawer extends ConsumerWidget {
  const _FilterDrawer({
    required this.period,
    required this.medicineId,
    required this.onClear,
    required this.onPeriod,
    required this.onMedicine,
  });

  final ReportPeriod? period;
  final String? medicineId;
  final VoidCallback? onClear;
  final ValueChanged<ReportPeriod?> onPeriod;
  final ValueChanged<String?> onMedicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalog =
        ref.watch(medicineCatalogProvider).value ?? const <Medicine>[];
    final selectedMed = catalog.where((m) => m.id == medicineId).firstOrNull;

    return FilterSideSheet(
      onClear: onClear,
      children: [
        Text(AppStrings.period, style: theme.textTheme.labelLarge),
        PeriodFilterList(period: period, onChanged: onPeriod),
        const Divider(),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.filterByMedicine, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        medicineId == null
            ? MedicinePickerField(
                medicines: catalog,
                hint: AppStrings.filterByMedicine,
                onSelected: (m) => onMedicine(m.id),
              )
            : InputChip(
                label: Text(selectedMed?.displayName ?? '—',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                avatar: const Icon(Icons.medication_outlined, size: 18),
                onDeleted: () => onMedicine(null),
              ),
      ],
    );
  }
}
