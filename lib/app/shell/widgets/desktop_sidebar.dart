import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/features/notifications/notification_center_providers.dart';

// ─── Data model ────────────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.hasBadge = false,
  });

  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool hasBadge;
}

class _NavSection {
  const _NavSection(this.label, this.items);

  final String label;
  final List<_NavItem> items;
}

// ─── Navigation structure ──────────────────────────────────────────────────
//
// Branch indices match the order in app_router.dart's StatefulShellRoute.
// Keep these two lists in sync.

const _mainSections = <_NavSection>[
  _NavSection('الرئيسية', [
    _NavItem(
      index: 0,
      label: 'المبيعات',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
    ),
    _NavItem(
      index: 1,
      label: 'الأدوية',
      icon: Icons.medication_outlined,
      selectedIcon: Icons.medication,
    ),
    _NavItem(
      index: 2,
      label: 'الكتالوغ',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
    ),
    _NavItem(
      index: 3,
      label: 'لوحة التحكم',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
    ),
  ]),
  _NavSection('المخزون والمشتريات', [
    _NavItem(
      index: 4,
      label: 'المخزون',
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
    ),
    _NavItem(
      index: 5,
      label: 'حركات المخزون',
      icon: Icons.swap_vert_outlined,
      selectedIcon: Icons.swap_vert,
    ),
    _NavItem(
      index: 6,
      label: 'المشتريات',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping,
    ),
  ]),
  _NavSection('إدارة البيانات', [
    _NavItem(
      index: 7,
      label: 'الموردون',
      icon: Icons.store_outlined,
      selectedIcon: Icons.store,
    ),
    _NavItem(
      index: 8,
      label: 'الزبائن',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
    ),
    _NavItem(
      index: 9,
      label: 'الأصناف',
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
    ),
    _NavItem(
      index: 10,
      label: 'الشركات المصنعة',
      icon: Icons.factory_outlined,
      selectedIcon: Icons.factory,
    ),
    _NavItem(
      index: 11,
      label: 'الوحدات',
      icon: Icons.straighten_outlined,
      selectedIcon: Icons.straighten,
    ),
    _NavItem(
      index: 12,
      label: 'العملات',
      icon: Icons.currency_exchange_outlined,
      selectedIcon: Icons.currency_exchange,
    ),
  ]),
  _NavSection('التقارير', [
    _NavItem(
      index: 13,
      label: 'التقارير الكاملة',
      icon: Icons.assessment_outlined,
      selectedIcon: Icons.assessment,
    ),
  ]),
];

const _bottomItems = <_NavItem>[
  _NavItem(
    index: 14,
    label: 'الإشعارات',
    icon: Icons.notifications_outlined,
    selectedIcon: Icons.notifications,
    hasBadge: true,
  ),
  _NavItem(
    index: 15,
    label: 'الشروحات',
    icon: Icons.school_outlined,
    selectedIcon: Icons.school,
  ),
  _NavItem(
    index: 16,
    label: 'الإعدادات',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
  _NavItem(
    index: 17,
    label: 'الحساب الشخصي',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
];

// ─── Widget ────────────────────────────────────────────────────────────────

class DesktopSidebar extends ConsumerWidget {
  const DesktopSidebar({
    required this.currentIndex,
    required this.expanded,
    required this.onToggle,
    required this.onNavigate,
    super.key,
  });

  final int currentIndex;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<int> onNavigate;

  // Labels are visible only once the sidebar is within 20 px of fully expanded.
  // This keeps labels in sync with the AnimatedContainer width so they never
  // snap in/out while the animation is still mid-flight.
  static const double _labelThreshold = AppDesktopSizes.sidebarExpanded - 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unread = ref.watch(notificationsUnreadCountProvider);

    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: expanded
            ? AppDesktopSizes.sidebarExpanded
            : AppDesktopSizes.sidebarCollapsed,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            left: BorderSide(color: theme.extension<AppSemanticColors>()!.border),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showLabels = constraints.maxWidth > _labelThreshold;
            return Column(
              children: [
                // Header: collapse toggle + optional app name
                _SidebarHeader(showLabels: showLabels, onToggle: onToggle),
                const Divider(height: 1, thickness: 1),

                // Main navigation sections (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final section in _mainSections) ...[
                          if (showLabels)
                            _SectionHeader(label: section.label)
                          else
                            const SizedBox(height: AppSpacing.sm),
                          for (final item in section.items)
                            _NavItemTile(
                              item: item,
                              isSelected: currentIndex == item.index,
                              showLabels: showLabels,
                              badgeCount: item.hasBadge ? unread : 0,
                              onTap: () => onNavigate(item.index),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom system items
                const Divider(height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                    horizontal: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      for (final item in _bottomItems)
                        _NavItemTile(
                          item: item,
                          isSelected: currentIndex == item.index,
                          showLabels: showLabels,
                          badgeCount: item.hasBadge ? unread : 0,
                          onTap: () => onNavigate(item.index),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Sub-widgets ───────────────────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({required this.showLabels, required this.onToggle});

  final bool showLabels;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: AppDesktopSizes.titleBarHeight,
      child: Row(
        mainAxisAlignment:
            showLabels ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          if (showLabels) ...[
            Padding(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: AppRadius.brSm,
                    ),
                    child: const Icon(
                      Icons.local_pharmacy,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'صيدليتي',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Tooltip(
            message: showLabels ? 'طيّ الشريط الجانبي' : 'توسيع الشريط الجانبي',
            child: IconButton(
              onPressed: onToggle,
              iconSize: AppSizes.iconMd,
              icon: Icon(
                showLabels ? Icons.menu_open : Icons.menu,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: AppDesktopSizes.sidebarSectionHeaderHeight,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.sm,
          bottom: AppSpacing.xs,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.extension<AppSemanticColors>()!.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemTile extends StatefulWidget {
  const _NavItemTile({
    required this.item,
    required this.isSelected,
    required this.showLabels,
    required this.badgeCount,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final bool showLabels;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  State<_NavItemTile> createState() => _NavItemTileState();
}

class _NavItemTileState extends State<_NavItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    final iconColor = widget.isSelected ? primary : onSurfaceVariant;
    final icon = Icon(
      widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
      size: AppSizes.iconMd,
      color: iconColor,
    );

    return Tooltip(
      message: widget.showLabels ? '' : widget.item.label,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: AppDesktopSizes.sidebarItemHeight,
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? primary.withValues(alpha: 0.12)
                  : _hovered
                      ? primary.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: AppRadius.brSm,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: AppDesktopSizes.sidebarCollapsed - AppSpacing.sm * 2,
                  child: Center(
                    child: widget.badgeCount > 0
                        ? Badge.count(count: widget.badgeCount, child: icon)
                        : icon,
                  ),
                ),
                if (widget.showLabels) ...[
                  Expanded(
                    child: Text(
                      widget.item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.isSelected
                            ? primary
                            : theme.colorScheme.onSurface,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
