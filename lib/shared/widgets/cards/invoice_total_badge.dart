import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/shared/utils/formatters.dart';

/// بطاقة إجمالي الفاتورة — أيقونة + الإجمالي بعملة الفاتورة المختارة (بارزاً
/// وكبيراً)، ومعادِلها بالعملة الأساسية وسعر الصرف أسفله حين تختلف العملتان.
/// تُستخدم بشاشتي المبيعات والمشتريات بنفس المكان والتصميم.
class InvoiceTotalBadge extends StatelessWidget {
  const InvoiceTotalBadge({
    required this.total,
    required this.selected,
    required this.base,
    super.key,
  });

  /// الإجمالي بعملة الفاتورة المختارة (selected).
  final double total;
  final Currency? selected;
  final Currency? base;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final code = selected?.code ?? '';
    final sameCurrency =
        selected != null && base != null && selected!.id == base!.id;
    final hasEquivalent = base != null && !sameCurrency;

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: primary.withValues(alpha: 0.15),
            child: Icon(Icons.payments_outlined, size: 17, color: primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.total,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.black)),
              Text(
                Formatters.money(total, code),
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black, height: 1.1),
              ),
            ],
          ),
          if (hasEquivalent) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Container(width: 1, height: 28, color: primary.withValues(alpha: 0.2)),
            ),
            Text(
              '≈ ${Formatters.money(convertToBase(total, base, selected), base!.code)}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}
