import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_create_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/stat_chips_bar.dart';
import 'package:saydaliati/shared/widgets/grids/app_grid.dart';
import 'package:trina_grid/trina_grid.dart';

/// Purchase invoice details — the project-standard layout: a stat-chips strip
/// (total / date / items count) over a full-height grid of the line items.
class PurchaseDetailPage extends StatelessWidget {
  const PurchaseDetailPage({required this.purchase, super.key});

  final Purchase purchase;

  static const _fName = 'name';
  static const _fUnit = 'unit';
  static const _fUnitPrice = 'unitPrice';
  static const _fQty = 'qty';
  static const _fExpiry = 'expiry';
  static const _fTotal = 'total';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.purchaseDetails),
        actions: [
          IconButton(
            tooltip: AppStrings.editPurchase,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final ok = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => PurchaseCreatePage(purchaseToEdit: purchase),
                ),
              );
              // On a successful edit, close the (now-stale) detail → back to
              // the refreshed list.
              if (ok == true && context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatChipsBar(chips: [
              StatChip(
                label: AppStrings.total,
                value: Formatters.money(purchase.totalAmount),
                icon: Icons.shopping_cart_outlined,
              ),
              StatChip(
                label: AppStrings.dateColumn,
                value: AppDate.ymd(purchase.purchaseDate),
                icon: Icons.event_outlined,
              ),
              StatChip(
                label: AppStrings.piecesCountColumn,
                value: '${purchase.items.length}',
                icon: Icons.medication_outlined,
              ),
            ]),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AppGrid(
                columns: [
                  appGridTextColumn(AppStrings.medicineName, _fName,
                      width: 240),
                  appGridTextColumn(AppStrings.unitLabel, _fUnit, width: 110),
                  appGridNumberColumn(AppStrings.unitPriceColumn, _fUnitPrice,
                      width: 110),
                  appGridNumberColumn(AppStrings.piecesCountColumn, _fQty,
                      width: 100),
                  appGridTextColumn(AppStrings.expiryColumn, _fExpiry,
                      width: 110, textAlign: TrinaColumnTextAlign.center),
                  appGridNumberColumn(AppStrings.total, _fTotal, width: 120,
                      renderer: (ctx) {
                    final v = ctx.cell.value;
                    final n = v is num ? v.toDouble() : 0.0;
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        Formatters.number(n),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ],
                rows: [
                  for (final line in purchase.items)
                    TrinaRow(cells: {
                      _fName: TrinaCell(value: line.medicineName),
                      _fUnit: TrinaCell(value: line.unitName),
                      _fUnitPrice: TrinaCell(value: line.unitPrice),
                      _fQty: TrinaCell(value: line.quantity),
                      _fExpiry: TrinaCell(
                          value: line.expiryDate != null
                              ? AppDate.ymd(line.expiryDate!)
                              : ''),
                      _fTotal: TrinaCell(value: line.subTotal),
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
