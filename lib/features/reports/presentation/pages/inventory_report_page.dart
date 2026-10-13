import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currencies_provider.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_hero_stat.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_list.dart';
import 'package:saydaliati/features/reports/presentation/widgets/report_scaffold.dart';
import 'package:saydaliati/features/reports/presentation/widgets/stat_tile.dart';
import 'package:saydaliati/features/reports/report_providers.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/inputs/app_dropdown.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Inventory report as a readable table, with a currency selector (default =
/// base currency) that converts the value column.
class InventoryReportPage extends ConsumerStatefulWidget {
  const InventoryReportPage({super.key});

  @override
  ConsumerState<InventoryReportPage> createState() =>
      _InventoryReportPageState();
}

class _InventoryReportPageState extends ConsumerState<InventoryReportPage> {
  String? _currencyId; // null => base currency

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(inventoryReportProvider);
    final base = ref.watch(baseCurrencyProvider);
    final currencies = ref.watch(currenciesProvider).value ?? const <Currency>[];
    final target = currencies.where((c) => c.id == (_currencyId ?? base?.id)).firstOrNull ?? base;
    final code = target?.code ?? '';

    return ReportScaffold(
      title: AppStrings.inventoryReport,
      onRefresh: () => ref.invalidate(inventoryReportProvider),
      body: async.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState.fromError(
          e,
          onRetry: () => ref.invalidate(inventoryReportProvider),
        ),
        data: (r) {
          double conv(double v) => convertFromBase(v, base, target);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              ReportHeroStat(
                label: AppStrings.stockValue,
                value: Formatters.money(conv(r.totalStockValue), code),
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: AppStrings.medicinesInStock,
                      value: Formatters.integer(r.medicinesInStock),
                      icon: Icons.medication_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: StatTile(
                      label: AppStrings.lowStockCount,
                      value: Formatters.integer(r.lowStockCount),
                      icon: Icons.warning_amber_outlined,
                      valueColor:
                          r.lowStockCount > 0 ? Colors.orange.shade800 : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (currencies.isNotEmpty)
                AppDropdown<String>(
                  label: AppStrings.selectCurrency,
                  value: target?.id,
                  items: [
                    for (final c in currencies)
                      AppDropdownItem(value: c.id, label: c.code),
                  ],
                  onChanged: (v) => setState(() => _currencyId = v),
                ),
              const SizedBox(height: AppSpacing.md),
              ReportList(
                emptyMessage: AppStrings.noData,
                items: [
                  for (final it in r.items)
                    ReportItem(
                      title: it.brandName,
                      accentColor:
                          it.isLowStock ? Colors.orange.shade700 : null,
                      trailing: Formatters.money(conv(it.stockValue), code),
                      fields: [
                        ReportField(
                            AppStrings.qtyLabel, Formatters.qty(it.quantity)),
                        if (it.isLowStock)
                          ReportField(AppStrings.stockStatus,
                              AppStrings.lowStockBadge,
                              color: Colors.orange.shade900),
                      ],
                      // وحدات الدواء مع سعر البيع وسعر الشراء (بعملة العرض).
                      children: [
                        for (final u in it.units)
                          ReportItem(
                            title: u.isBaseUnit
                                ? '${u.unitName} (${AppStrings.baseBadge})'
                                : u.unitName,
                            subtitle:
                                '${AppStrings.priceColumn}: ${Formatters.money(conv(u.salePrice), code)}'
                                '  •  ${AppStrings.costPriceLabel}: ${Formatters.money(conv(u.purchaseCost), code)}',
                          ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
