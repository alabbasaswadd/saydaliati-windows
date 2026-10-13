import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/core/utils/app_date.dart';
import 'package:saydaliati/features/purchases/domain/entities/purchase.dart';
import 'package:saydaliati/features/purchases/presentation/pages/purchase_create_page.dart';
import 'package:saydaliati/shared/utils/formatters.dart';
import 'package:saydaliati/shared/widgets/cards/app_section_card.dart';

class PurchaseDetailPage extends StatelessWidget {
  const PurchaseDetailPage({required this.purchase, super.key});

  final Purchase purchase;

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
              // On a successful edit, close the (now-stale) detail → back to the
              // refreshed list.
              if (ok == true && context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Summary header: total prominent + date & item-count chips.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.total,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor)),
                  const SizedBox(height: 2),
                  Text(Formatters.money(purchase.totalAmount),
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _chip(theme, Icons.event_outlined,
                          AppDate.ymd(purchase.purchaseDate)),
                      _chip(theme, Icons.medication_outlined,
                          '${purchase.items.length} صنف'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppSectionCard(
            title: AppStrings.units,
            icon: Icons.medication_outlined,
            child: Column(
              children: [
                for (var i = 0; i < purchase.items.length; i++) ...[
                  if (i > 0) const Divider(height: AppSpacing.md),
                  _line(theme, purchase.items[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(ThemeData theme, PurchaseLine line) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line.medicineName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 2),
              Text(
                '${line.unitName} • ${Formatters.qty(line.quantity)} × ${Formatters.money(line.unitPrice)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              if (line.expiryDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '${AppStrings.expiry}: ${AppDate.ymd(line.expiryDate!)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(Formatters.money(line.subTotal),
            style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _chip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.hintColor),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
