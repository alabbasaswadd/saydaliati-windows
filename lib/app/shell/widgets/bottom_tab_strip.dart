import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/shell/tabs/app_tab.dart';
import 'package:saydaliati/app/shell/tabs/tabs_controller.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

/// شريط التابّات أسفل الشاشة — الصفحات المفتوحة والانتقال بينها.
///
/// **الانتقال فوريّ بلا إعادة بناء:** كل صفحة تبقى حيّةً في فرعها
/// (`StatefulShellRoute.indexedStack`)، فالتابّ يُظهرها كما تُركت — فاتورة
/// نصف مكتوبة تبقى، وجدولٌ مُفلتَر يبقى على فلترته، وموضع التمرير لا يضيع.
///
/// **أسفل الشاشة لا أعلاها:** الأعلى مشغول بشريط العنوان، وشريط المهام في
/// ويندوز أسفل — فموضع التابّات أسفل المحتوى يطابق ما تعلّمته اليد.
class BottomTabStrip extends ConsumerStatefulWidget {
  const BottomTabStrip({
    required this.onSelect,
    required this.onAddTab,
    super.key,
  });

  /// يُطلَب تنشيط تابّ (والانتقال إلى صفحته إن كانت له صفحة).

  final void Function(AppTab tab) onSelect;

  /// زرّ «+»: فتح تابّ يدوياً باختيار الصفحة.
  final VoidCallback onAddTab;

  @override
  ConsumerState<BottomTabStrip> createState() => _BottomTabStripState();
}

class _BottomTabStripState extends ConsumerState<BottomTabStrip> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// الإغلاق ينقل إلى الجار **فقط** إن كان المُغلق هو المعروض — إغلاق تابّ
  /// خامل لا يُزيح المستخدم عن مكانه.
  void _close(AppTab tab) {
    final next = ref.read(openTabsProvider.notifier).close(tab.id);
    if (next != null) widget.onSelect(next);
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(openTabsProvider);
    final tabs = tabsState.tabs;
    final theme = Theme.of(context);
    final border = theme.extension<AppSemanticColors>()!.border;

    // الشريط ظاهر دائماً ولو بلا تابّات: زرّ «+» يجب أن يكون في مكان ثابت
    // تعرفه اليد، لا أن يظهر ويختفي بحسب وجود تابّات.
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border(top: BorderSide(color: border, width: 1.2)),
      ),
      child: Row(
        children: [
          _AddTabButton(onTap: widget.onAddTab),
          VerticalDivider(
              width: 1, thickness: 1, color: border, indent: 8, endIndent: 8),
          Expanded(
            // التمرير بالفأرة أفقياً: عشرون تابّاً لا تتّسع لها الشاشة، وقصّها
            // يُخفيها بلا أثر.
            child: Scrollbar(
              controller: _scroll,
              thickness: 3,
              child: ListView.separated(
                controller: _scroll,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                itemCount: tabs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 4),
                itemBuilder: (context, i) {
                  final tab = tabs[i];
                  return _TabChip(
                    tab: tab,
                    selected: tab.id == tabsState.activeId,
                    onTap: () => widget.onSelect(tab),
                    onClose: () => _close(tab),
                    onCloseOthers: tabs.length > 1
                        ? () => ref
                            .read(openTabsProvider.notifier)
                            .closeOthers(tab.id)
                        : null,
                  );
                },
              ),
            ),
          ),
          if (tabs.length > 1)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: Tooltip(
                message: 'إغلاق كل التابّات',
                child: InkWell(
                  borderRadius: AppRadius.brXs,
                  onTap: () => ref.read(openTabsProvider.notifier).closeAll(),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.clear_all,
                        size: 18, color: theme.hintColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// تابٌّ واحد: أيقونة + عنوان + زرّ إغلاق يظهر عند التحويم أو عند كونه نشِطاً.
class _TabChip extends StatefulWidget {
  const _TabChip({
    required this.tab,
    required this.selected,
    required this.onTap,
    required this.onClose,
    this.onCloseOthers,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final VoidCallback? onCloseOthers;

  @override
  State<_TabChip> createState() => _TabChipState();
}

class _TabChipState extends State<_TabChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final selected = widget.selected;

    // زرّ الإغلاق لا يحتلّ مكانه إلّا عند الحاجة: ثبات العرض يمنع «رقص»
    // التابّات تحت المؤشّر، فيُبقى المكان محجوزاً دوماً ويُخفى الزرّ وحده.
    final showClose = selected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        // الزرّ الأوسط يُغلق التابّ — عادة المتصفّحات.
        onTertiaryTapUp: (_) => widget.onClose(),
        onSecondaryTapUp: (details) => _menu(context, details.globalPosition),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          constraints: const BoxConstraints(maxWidth: 220, minWidth: 92),
          height: 34,
          padding: const EdgeInsetsDirectional.only(start: 10, end: 5),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.surface
                : (_hovered
                    ? theme.colorScheme.surface.withValues(alpha: 0.65)
                    : theme.colorScheme.surface.withValues(alpha: 0.25)),
            borderRadius: AppRadius.brSm,
            border: Border.all(
              color: selected
                  ? primary
                  : theme.extension<AppSemanticColors>()!.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                // التابّ الفارغ بأيقونة محايدة حتى يختار صاحبه صفحته.
                widget.tab.icon ?? Icons.tab_outlined,
                size: 16,
                color: selected ? primary : theme.hintColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.tab.title ?? 'تابّ جديد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selected ? primary : theme.colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              SizedBox(
                width: 22,
                height: 22,
                child: showClose
                    ? InkWell(
                        borderRadius: BorderRadius.circular(11),
                        onTap: widget.onClose,
                        child: Icon(Icons.close,
                            size: 14,
                            color: selected ? primary : theme.hintColor),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _menu(BuildContext context, Offset position) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'close',
          height: 36,
          child: Text('إغلاق', style: TextStyle(fontSize: 13)),
        ),
        if (widget.onCloseOthers != null)
          const PopupMenuItem(
            value: 'others',
            height: 36,
            child: Text('إغلاق البقيّة', style: TextStyle(fontSize: 13)),
          ),
      ],
    );

    if (choice == 'close') widget.onClose();
    if (choice == 'others') widget.onCloseOthers?.call();
  }
}

/// زرّ «تابّ جديد» — ثابت في طرف الشريط.
class _AddTabButton extends StatefulWidget {
  const _AddTabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AddTabButton> createState() => _AddTabButtonState();
}

class _AddTabButtonState extends State<_AddTabButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Tooltip(
        message: 'تابّ جديد — أو Ctrl + نقر على عنصر من القائمة الجانبية',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 110),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: _hovered ? 0.16 : 0.08),
                borderRadius: AppRadius.brSm,
                border: Border.all(
                  color: primary.withValues(alpha: _hovered ? 0.6 : 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18, color: primary),
                  const SizedBox(width: 4),
                  Text(
                    'تابّ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
