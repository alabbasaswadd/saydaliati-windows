import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/currencies/domain/currency_conversion.dart';
import 'package:saydaliati/features/currencies/domain/entities/currency.dart';
import 'package:saydaliati/shared/utils/formatters.dart';

/// بطاقة إجمالي الفاتورة — **دوماً** بعملتين: عملة الفاتورة المختارة (الأعلى،
/// بارزة)، ومعادِلها بالعملة الأساسية (الأسفل، أخفّ)، مع سعر الصرف الحالي بينهما
/// حين تختلف العملتان. تُستخدم بشاشتي المبيعات والمشتريات بنفس المكان والتصميم.
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
    final code = selected?.code ?? '';
    final sameCurrency =
        selected != null && base != null && selected!.id == base!.id;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.brMd,
        border:
            Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.total,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.primary)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                Formatters.money(total, code),
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ],
          ),
          if (base != null) ...[
            const SizedBox(height: 2),
            Text(
              '≈ ${Formatters.money(convertToBase(total, base, selected), base!.code)}',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary.withValues(alpha: 0.65)),
            ),
          ],
          // سعر الصرف الحالي — فقط حين توجد فعلاً عملتان مختلفتان للمقارنة.
          if (base != null && selected != null && !sameCurrency) ...[
            const SizedBox(height: 1),
            Text(
              '${AppStrings.exchangeRateLabel}: 1 $code = '
              '${Formatters.money(convertToBase(1, base, selected), base!.code)}',
              style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5)),
            ),
          ],
        ],
      ),
    );
  }
}
