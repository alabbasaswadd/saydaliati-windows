import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/customers/customer_providers.dart';
import 'package:saydaliati/features/customers/domain/entities/customer.dart';
import 'package:saydaliati/features/reports/domain/report_period.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';
import 'package:saydaliati/features/sales/presentation/providers/sales_provider.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/async_list_view.dart';
import 'package:saydaliati/shared/widgets/filters/filter_side_sheet.dart';
import 'package:saydaliati/shared/widgets/filters/period_filter_list.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';

/// Prescriptions report: sales flagged as medical prescriptions (كل وصفة لها
/// عميل). Filterable by period and customer from a right-side panel.
class PrescriptionsReportPage extends ConsumerStatefulWidget {
  const PrescriptionsReportPage({super.key});

  @override
  ConsumerState<PrescriptionsReportPage> createState() =>
      _PrescriptionsReportPageState();
}

class _PrescriptionsReportPageState
    extends ConsumerState<PrescriptionsReportPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ReportPeriod? _period;
  String? _customerId;

  bool get _hasFilters => _period != null || _customerId != null;

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider).value ?? const <Customer>[];
    String customerName(String id) => customers
        .where((c) => c.id == id)
        .map((c) => c.fullName)
        .firstOrNull ??
        '';

    final provider = salesListProvider(
      isPrescription: true,
      fromIso: _period?.startUtcIso,
      toIso: _period?.endUtcIso,
      customerId: _customerId,
    );
    final async = ref.watch(provider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(AppStrings.prescriptionsReport),
        actions: [
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
      endDrawer: FilterSideSheet(
        onClear: _hasFilters
            ? () => setState(() {
                  _period = null;
                  _customerId = null;
                })
            : null,
        children: [
          Text(AppStrings.period,
              style: Theme.of(context).textTheme.labelLarge),
          PeriodFilterList(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
          AppDropdown<String?>(
            label: AppStrings.filterByCustomer,
            value: _customerId,
            items: [
              const AppDropdownItem<String?>(value: null, label: AppStrings.all),
              for (final c in customers)
                AppDropdownItem<String?>(value: c.id, label: c.fullName),
            ],
            onChanged: (v) => setState(() => _customerId = v),
          ),
        ],
      ),
      body: AsyncListView<Sale>(
        value: async,
        emptyMessage: AppStrings.noPrescriptions,
        onRefresh: () => ref.refresh(provider.future),
        itemBuilder: (context, sale) {
          final name = customerName(sale.customerId);
          final theme = Theme.of(context);
          final code = sale.currencyCode;
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            child: ExpansionTile(
              leading: const CircleAvatar(
                  child: Icon(Icons.medical_services_outlined)),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                        '${AppStrings.invoiceLabel} #${sale.invoiceNumber}',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Text(Formatters.money(sale.totalAmount, code),
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              subtitle: Text(
                '${AppDate.ymdHm(sale.saleDate)}'
                '${name.isNotEmpty ? '  •  $name' : ''}',
                style: theme.textTheme.bodySmall,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العميل بوضوح
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        name.isNotEmpty ? name : AppStrings.notSet,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // الأدوية
                for (final line in sale.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(line.medicineName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                '${line.unitName}  •  '
                                '${Formatters.qty(line.quantity)} × ${Formatters.money(line.individual, code)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Text(Formatters.money(line.subTotal, code),
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
