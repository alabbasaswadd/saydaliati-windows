import 'package:flutter/material.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/utils/formatters.dart';

/// بطاقة فاتورة موحّدة لقائمتي المبيعات والمشتريات.
///
/// التصميم يجيب عن أسئلة الصيدلي الأربعة بلمحة: أي فاتورة (رقمها)، متى، ماذا
/// فيها، وبكم — ثم إجراءان صريحان (تعديل/حذف) بدل قوائم مخفية. النقر على
/// البطرقة نفسها يفتح التفاصيل.
class InvoiceCard extends StatefulWidget {
  const InvoiceCard({
    required this.icon,
    required this.invoiceNumber,
    required this.dateLabel,
    required this.itemsCount,
    required this.itemsPreview,
    required this.amount,
    required this.currencyCode,
    this.partyLabel,
    this.badge,
    this.profit,
    this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final IconData icon;

  /// رقم الفاتورة كما يعرفه المستخدم (0 يعني بلا رقم بعد).
  final int invoiceNumber;
  final String dateLabel;
  final int itemsCount;

  /// أسماء أول صنفين وما بقي — يُعرّف الفاتورة أسرع من رقمها.
  final String itemsPreview;

  final double amount;
  final String currencyCode;

  /// العميل أو المورّد، إن وُجد.
  final String? partyLabel;

  /// وسم إضافي (وصفة طبية، مرتجع…).
  final String? badge;

  /// ربح الفاتورة بعملتها نفسها. `null` يعني «مخفيّ» — الأرباح رقم حسّاس لا
  /// يُعرض إلا حين يطلبه المستخدم صراحةً.
  final double? profit;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;

    return MouseRegion(
      cursor: widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(
            color: _hovered
                ? scheme.primary.withValues(alpha: 0.45)
                : semantic.border,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.brLg,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(theme, scheme),
                  const SizedBox(height: AppSpacing.sm),
                  _preview(theme, semantic),
                  const Spacer(),
                  _footer(theme, scheme, semantic),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(ThemeData theme, ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.10),
            borderRadius: AppRadius.brSm,
          ),
          child: Icon(widget.icon, size: AppSizes.iconSm, color: scheme.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.invoiceNumber > 0
                          ? '${AppStrings.invoiceLabel} #${widget.invoiceNumber}'
                          : AppStrings.invoiceLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.badge != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    _Tag(label: widget.badge!),
                  ],
                ],
              ),
              Text(
                widget.dateLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _preview(ThemeData theme, AppSemanticColors semantic) {
    final party = widget.partyLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.itemsPreview.isEmpty
              ? '${widget.itemsCount} صنف'
              : widget.itemsPreview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        if (party != null && party.isNotEmpty)
          Text(
            party,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _footer(
      ThemeData theme, ColorScheme scheme, AppSemanticColors semantic) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.itemsCount} صنف',
                style: theme.textTheme.labelSmall),
            Directionality(
              // المبلغ ورمز العملة يُقرآن يساراً-يميناً دوماً.
              textDirection: TextDirection.ltr,
              child: Text(
                Formatters.money(widget.amount, widget.currencyCode),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
            if (widget.profit != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('الربح ', style: theme.textTheme.labelSmall),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      Formatters.money(widget.profit!, widget.currencyCode),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: widget.profit! < 0
                            ? scheme.error
                            : semantic.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const Spacer(),
        if (widget.onEdit != null)
          _CardAction(
            icon: Icons.edit_outlined,
            label: AppStrings.edit,
            onPressed: widget.onEdit!,
          ),
        if (widget.onDelete != null) ...[
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: AppSizes.iconSm),
            color: scheme.error,
            tooltip: AppStrings.delete,
            visualDensity: VisualDensity.compact,
            onPressed: widget.onDelete,
          ),
        ],
      ],
    );
  }
}

/// زر «تعديل» الصريح — بارز بما يكفي ليُرى من دون أن ينافس المبلغ.
class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppSizes.iconXs),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.45)),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
        textStyle: theme.textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 1),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: AppRadius.brXs,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// شبكة بطاقات الفواتير — عرض البطاقة ثابت تقريباً وعددها في السطر يتبع عرض
/// الشاشة، فتستغل شاشة سطح المكتب العريضة بلا بطاقات ممطوطة.
class InvoiceCardsGrid extends StatelessWidget {
  const InvoiceCardsGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 470,
        mainAxisExtent: 160,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
    );
  }
}
