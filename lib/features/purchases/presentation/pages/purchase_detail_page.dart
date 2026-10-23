import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
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
  static const _fBonus = 'bonus';
  static const _fExpiry = 'expiry';
  static const _fTotal = 'total';
  static const _fIsBonusLine = 'isBonusLine';

  /// هل في الفاتورة بونص؟ — يحدّد ظهور عمود البونص وشارته في الشريط
  /// العلوي، فتُعرَف الفاتورة التي فيها بونص من تفاصيلها لا من حفظها فقط.
  bool get _hasBonus => purchase.items.any((i) => i.bonusQuantity > 0);

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
              // يظهر فقط حين يوجد بونص — غيابه يعني فاتورةً خالية منه، لا
              // داعي لشغل الشريط بصفر دائم.
              if (_hasBonus)
                StatChip(
                  label: AppStrings.bonusLabel,
                  value: Formatters.number(
                      purchase.items.fold(0.0, (s, i) => s + i.bonusQuantity)),
                  icon: Icons.card_giftcard_outlined,
                ),
            ]),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AppGrid(
                columns: [
                  appGridTextColumn(AppStrings.medicineName, _fName,
                      width: 240, renderer: (ctx) {
                    // من خليّة مخفية بالسطر نفسه لا بالاسم أو الفهرس: مادتان
                    // بنفس الاسم (دفعتان مختلفتان) تشتبهان بالاسم، والفرز قد
                    // يُبدِّل ترتيب الصفوف عن ترتيب `purchase.items` فيُخطئ
                    // الفهرس أيضاً.
                    final isBonus = ctx.row.cells[_fIsBonusLine]?.value == true;
                    return Row(
                      children: [
                        // نفس إشارة شاشة الإنشاء — يُعرَف السطر الذي فيه
                        // بونص من الاستعراض بلمحة، لا بقراءة عمود الأرقام.
                        if (isBonus) ...[
                          Tooltip(
                            message: 'فيه بونص',
                            child: Icon(Icons.card_giftcard,
                                size: 14, color: context.semantic.success),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Expanded(
                          child: Text(ctx.cell.value?.toString() ?? '',
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    );
                  }),
                  appGridTextColumn(AppStrings.unitLabel, _fUnit, width: 110),
                  appGridNumberColumn(AppStrings.unitPriceColumn, _fUnitPrice,
                      width: 110),
                  appGridNumberColumn(AppStrings.piecesCountColumn, _fQty,
                      width: 100),
                  // نفس شرط عمود البونص في شاشة الإنشاء: يظهر فقط حين تحمل
                  // الفاتورة بونصاً — وإلا عمودٌ صفريٌّ دائم لا يُفيد.
                  if (_hasBonus)
                    appGridNumberColumn(AppStrings.bonusLabel, _fBonus,
                        width: 85, renderer: (ctx) {
                      final v = ctx.cell.value;
                      final n = v is num ? v.toDouble() : 0.0;
                      if (n == 0) return const SizedBox.shrink();
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          Formatters.number(n),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: context.semantic.success,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    }),
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
                  TrinaColumn(
                      title: '',
                      field: _fIsBonusLine,
                      type: TrinaColumnType.text(),
                      hide: true),
                ],
                rows: [
                  for (final line in purchase.items)
                    TrinaRow(cells: {
                      _fName: TrinaCell(value: line.medicineName),
                      _fUnit: TrinaCell(value: line.unitName),
                      _fUnitPrice: TrinaCell(value: line.unitPrice),
                      _fQty: TrinaCell(value: line.quantity),
                      if (_hasBonus)
                        _fBonus: TrinaCell(value: line.bonusQuantity),
                      _fExpiry: TrinaCell(
                          value: line.expiryDate != null
                              ? AppDate.ymd(line.expiryDate!)
                              : ''),
                      _fTotal: TrinaCell(value: line.subTotal),
                      _fIsBonusLine:
                          TrinaCell(value: line.bonusQuantity > 0),
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
