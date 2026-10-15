import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/router/app_routes.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';

// ─── Data model ────────────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.route,
  });

  /// Branch index in the StatefulShellRoute (selection + goBranch).
  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// When set, tapping navigates to this exact route (nested shell routes —
  /// the individual reports) and selection matches the location, not the
  /// branch index.
  final String? route;
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
  // الفواتير والمرتجعات: المبيعات/المشتريات (فروع مباشرة) + مرتجعاتهما
  // (مسارات متداخلة داخل فرع واحد، index 7 — التظليل يطابق المسار لا رقم الفرع).
  _NavSection('الفواتير والمرتجعات', [
    _NavItem(
      index: 0,
      label: 'المبيعات',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
    ),
    _NavItem(
      index: 6,
      label: 'المشتريات',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping,
    ),
    _NavItem(
      index: 22,
      label: 'فواتير المبيعات',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      route: AppRoutes.salesInvoices,
    ),
    _NavItem(
      index: 23,
      label: 'فواتير المشتريات',
      icon: Icons.receipt_outlined,
      selectedIcon: Icons.receipt,
      route: AppRoutes.purchaseInvoices,
    ),
    _NavItem(
      index: 7,
      label: 'مرتجع مبيعات',
      icon: Icons.assignment_return_outlined,
      selectedIcon: Icons.assignment_return,
      route: AppRoutes.salesReturns,
    ),
    _NavItem(
      index: 7,
      label: 'مرتجع مشتريات',
      icon: Icons.assignment_return_outlined,
      selectedIcon: Icons.assignment_return,
      route: AppRoutes.purchaseReturns,
    ),
  ]),
  // الأدوية وتوابعها: الدواء نفسه + كل ما يصنّفه أو يتتبّع مخزونه.
  _NavSection('الأدوية وتوابعها', [
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
      index: 10,
      label: 'الأصناف',
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
    ),
    _NavItem(
      index: 11,
      label: 'الشركات المصنعة',
      icon: Icons.factory_outlined,
      selectedIcon: Icons.factory,
    ),
    _NavItem(
      index: 12,
      label: 'الوحدات',
      icon: Icons.straighten_outlined,
      selectedIcon: Icons.straighten,
    ),
  ]),
  _NavSection('إدارة البيانات', [
    _NavItem(
      index: 8,
      label: 'الموردون',
      icon: Icons.store_outlined,
      selectedIcon: Icons.store,
    ),
    _NavItem(
      index: 9,
      label: 'الزبائن',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
    ),
    _NavItem(
      index: 13,
      label: 'العملات',
      icon: Icons.currency_exchange_outlined,
      selectedIcon: Icons.currency_exchange,
    ),
  ]),
  // التقارير: عناصر بمسارات متداخلة داخل فرع التقارير (index 14) — التظليل
  // يطابق المسار الحالي لا رقم الفرع.
  _NavSection('التقارير', [
    _NavItem(
      index: 14,
      label: 'تقرير المبيعات',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
      route: AppRoutes.salesReport,
    ),
    _NavItem(
      index: 14,
      label: 'تقرير الأرباح',
      icon: Icons.trending_up_outlined,
      selectedIcon: Icons.trending_up,
      route: AppRoutes.profitReport,
    ),
    _NavItem(
      index: 14,
      label: 'تقرير المشتريات',
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart,
      route: AppRoutes.purchasesReport,
    ),
    _NavItem(
      index: 14,
      label: 'تقرير المخزون',
      icon: Icons.inventory_outlined,
      selectedIcon: Icons.inventory,
      route: AppRoutes.inventoryReport,
    ),
    _NavItem(
      index: 14,
      label: 'تقرير الصلاحية',
      icon: Icons.event_busy_outlined,
      selectedIcon: Icons.event_busy,
      route: AppRoutes.expiryReport,
    ),
    _NavItem(
      index: 14,
      label: 'الجرد',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check,
      route: AppRoutes.stocktakeReport,
    ),
    _NavItem(
      index: 14,
      label: 'تقرير الوصفات',
      icon: Icons.medical_services_outlined,
      selectedIcon: Icons.medical_services,
      route: AppRoutes.prescriptionsReport,
    ),
  ]),
  // الحسابات والسندات والمصاريف: كلها قيود/تدفقات مالية — مسارات متداخلة
  // داخل فرعين (index 15 للمصاريف، 16 للحسابات) — نفس أسلوب المرتجعات/التقارير.
  // الذمم: كتلة قابلة للطيّ بولدين — العملاء والموردون. كلاهما في الفرع 24
  // بمسارين شقيقين، فالتظليل يطابق المسار.
  _NavSection('الذمم والديون', [
    _NavItem(
      index: 24,
      label: 'ديون العملاء',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      route: AppRoutes.debtsCustomers,
    ),
    _NavItem(
      index: 24,
      label: 'ديون الموردين',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping,
      route: AppRoutes.debtsSuppliers,
    ),
  ]),

  _NavSection('الحسابات والمصاريف', [
    _NavItem(
      index: 16,
      label: 'الحسابات',
      icon: Icons.account_balance_outlined,
      selectedIcon: Icons.account_balance,
      route: AppRoutes.accounts,
    ),
    _NavItem(
      index: 16,
      label: 'السندات',
      icon: Icons.description_outlined,
      selectedIcon: Icons.description,
      route: AppRoutes.vouchers,
    ),
    _NavItem(
      index: 15,
      label: 'تصنيفات المصاريف',
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      route: AppRoutes.expenseCategories,
    ),
    _NavItem(
      index: 15,
      label: 'المصاريف',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      route: AppRoutes.expenses,
    ),
  ]),
];

// عناصر النظام السفلية — قسمان منفصلان بحدّ بينهما: البقية أولاً، ثم مفتاح
// وضع الاتصال وحده في القسم الأخير (الإشعارات انتقلت لشريط العنوان العلوي).
const _bottomItems = <_NavItem>[
  _NavItem(
    index: 18,
    label: 'الشروحات',
    icon: Icons.school_outlined,
    selectedIcon: Icons.school,
  ),
  _NavItem(
    index: 19,
    label: 'الإعدادات',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
  _NavItem(
    index: 20,
    label: 'الحساب الشخصي',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
  _NavItem(
    index: 21,
    label: 'الاختصارات',
    icon: Icons.keyboard_outlined,
    selectedIcon: Icons.keyboard,
  ),
];

// ─── Widget ────────────────────────────────────────────────────────────────

class DesktopSidebar extends ConsumerStatefulWidget {
  const DesktopSidebar({
    required this.currentIndex,
    required this.currentLocation,
    required this.expanded,
    required this.onToggle,
    required this.onNavigate,
    required this.onNavigateRoute,
    required this.onOpenInNewTab,
    super.key,
  });

  final int currentIndex;

  /// المسار الحالي (uri.path) — لتظليل عناصر المسارات المتداخلة.
  final String currentLocation;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<int> onNavigate;
  final ValueChanged<String> onNavigateRoute;

  /// Ctrl + نقر: يفتح تابّاً في الخلف. يُمرَّر رقم الفرع والمسار الصريح إن
  /// وُجد — القشرة تحلّ مسار الفرع من الراوتر حين لا مسار صريح.
  final void Function(int branchIndex, String? route) onOpenInNewTab;

  // Labels are visible only once the sidebar is within 20 px of fully expanded.
  // This keeps labels in sync with the AnimatedContainer width so they never
  // snap in/out while the animation is still mid-flight.
  static const double _labelThreshold = AppDesktopSizes.sidebarExpanded - 20;

  @override
  ConsumerState<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends ConsumerState<DesktopSidebar> {
  /// الكتل المطوية (بالاسم). كل الكتل مفتوحة افتراضياً.
  final Set<String> _collapsedSections = {};

  bool _isSelected(_NavItem item) => item.route != null
      ? widget.currentLocation == item.route
      : widget.currentIndex == item.index;

  /// هل كان Ctrl مضغوطاً **لحظة نزول مؤشّر الفأرة**؟
  ///
  /// لا يُسأل `HardwareKeyboard` عند النقر: اختصارُ تنقّلٍ بـCtrl يترك الحالة
  /// «مضغوطة» لحظات (ورفعُ المفتاح قد يُفقَد أصلاً إن تغيّرت الشاشة تحته)،
  /// فكانت أوّل نقرة بعد الاختصار تُقرأ Ctrl+نقر فتفتح تابّاً في الخلف
  /// وتُظهر رسالةً بدل أن تنتقل. الربط بحدث النقر نفسه يُلغي ذلك: مسار
  /// لوحة المفاتيح لا يمرّ بالمؤشّر أصلاً.
  bool _ctrlAtPointerDown = false;

  void _onTap(_NavItem item) {
    final withCtrl = _ctrlAtPointerDown;
    _ctrlAtPointerDown = false;

    // Ctrl + نقر = تابّ جديد في الخلف، بلا مغادرة الصفحة الحالية — عادة
    // المتصفّحات. النقر المجرَّد ينتقل كما كان.
    if (withCtrl) {
      widget.onOpenInNewTab(item.index, item.route);
      return;
    }

    if (item.route != null) {
      widget.onNavigateRoute(item.route!);
    } else {
      widget.onNavigate(item.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Listener(
      // تُسجَّل حالة Ctrl عند نزول المؤشّر، فيقرأها `_onTap` بعدها.
      onPointerDown: (_) =>
          _ctrlAtPointerDown = HardwareKeyboard.instance.isControlPressed,
      child: ClipRect(
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: widget.expanded
            ? AppDesktopSizes.sidebarExpanded
            : AppDesktopSizes.sidebarCollapsed,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            left:
                BorderSide(color: theme.extension<AppSemanticColors>()!.border),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showLabels =
                constraints.maxWidth > DesktopSidebar._labelThreshold;
            return Column(
              children: [
                // Header: collapse toggle + optional app name
                _SidebarHeader(
                    showLabels: showLabels, onToggle: widget.onToggle),
                Divider(height: 1, thickness: 2, color: theme.extension<AppSemanticColors>()!.border),

                // Main navigation sections (scrollable) — حدّ رفيع بين كل كتلة
                // والتي تليها.
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < _mainSections.length; i++) ...[
                          if (i > 0) _sectionDivider(context),
                          _buildSection(_mainSections[i], showLabels),
                        ],
                      ],
                    ),
                  ),
                ),

                // عناصر النظام السفلية — قسمان بحدّ بينهما: البقية، ثم الإشعارات
                // أخيراً وحدها في قسمها الخاص.
                Divider(height: 1, thickness: 2, color: theme.extension<AppSemanticColors>()!.border),
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
                          isSelected: _isSelected(item),
                          showLabels: showLabels,
                          badgeCount: 0,
                          onTap: () => _onTap(item),
                        ),
                    ],
                  ),
                ),
                _sectionDivider(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.sm,
                  ),
                  child: _OfflineToggleTile(showLabels: showLabels),
                ),
              ],
            );
          },
          ),
        ),
      ),
    );
  }

  /// حدّ بين كتلتين من كتل القائمة الجانبية — أثخن من الحدود الافتراضية حتى
  /// يكون الفصل بين الأقسام ظاهراً بوضوح.
  Widget _sectionDivider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Divider(
          height: 1,
          thickness: 2,
          color: Theme.of(context).extension<AppSemanticColors>()!.border,
        ),
      );

  /// كتلة قابلة للطي: رأس بسهم دوّار يفتح/يغلق عناصرها. في الوضع المطوي
  /// (أيقونات فقط) لا رؤوس — تُعرض كل العناصر.
  Widget _buildSection(_NavSection section, bool showLabels) {
    // الطي هنا يتبع نقرة المستخدم دوماً — حتى لو كانت الكتلة تحوي العنصر
    // المحدّد حالياً (الطي السابق كان يمنع إغلاق كتلة فيها تظليل، فبدا للمستخدم
    // كأن الكتلة "لا تُقفل").
    final effectiveCollapsed = _collapsedSections.contains(section.label);

    final items = [
      for (final item in section.items)
        _NavItemTile(
          item: item,
          isSelected: _isSelected(item),
          showLabels: showLabels,
          badgeCount: 0,
          onTap: () => _onTap(item),
        ),
    ];

    if (!showLabels) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [const SizedBox(height: AppSpacing.sm), ...items],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          label: section.label,
          collapsed: effectiveCollapsed,
          onTap: () => setState(() {
            if (effectiveCollapsed) {
              _collapsedSections.remove(section.label);
            } else {
              _collapsedSections.add(section.label);
            }
          }),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: effectiveCollapsed
              ? const SizedBox(width: double.infinity)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items,
                ),
        ),
      ],
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
        mainAxisAlignment: showLabels
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
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

/// رأس كتلة قابل للنقر: التسمية + سهم يدور عند الطي.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.collapsed,
    required this.onTap,
  });

  final String label;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.extension<AppSemanticColors>()!.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brSm,
      child: SizedBox(
        height: AppDesktopSizes.sidebarSectionHeaderHeight,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.sm,
            end: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: collapsed ? -0.25 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(Icons.expand_more, size: 16, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// مفتاح وضع الاتصال (أونلاين/أوفلاين) في آخر القائمة الجانبية — ليس انتقالاً
/// لصفحة بل تبديل حالة، فيأخذ شكل عناصر القائمة نفسه (الارتفاع والزاوية
/// والتمرير) مع لون تحذيري حين يكون العمل دون اتصال.
class _OfflineToggleTile extends ConsumerStatefulWidget {
  const _OfflineToggleTile({required this.showLabels});

  final bool showLabels;

  @override
  ConsumerState<_OfflineToggleTile> createState() => _OfflineToggleTileState();
}

class _OfflineToggleTileState extends ConsumerState<_OfflineToggleTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offline = !ref.watch(effectiveOnlineProvider);
    final warning = context.semantic.warning;
    final color = offline ? warning : theme.colorScheme.onSurfaceVariant;

    final icon = Icon(
      offline ? Icons.cloud_off : Icons.cloud_done_outlined,
      size: AppSizes.iconMd,
      color: color,
    );

    return Tooltip(
      message: AppStrings.offlineToggleTooltip,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => ref.read(workModeControllerProvider.notifier).toggleOffline(
                ref.read(workModeControllerProvider) != WorkMode.offline,
              ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: AppDesktopSizes.sidebarItemHeight,
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: offline
                  ? warning.withValues(alpha: 0.12)
                  : _hovered
                      ? theme.colorScheme.primary.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: AppRadius.brSm,
            ),
            child: Row(
              children: [
                if (widget.showLabels)
                  SizedBox(
                    width: AppDesktopSizes.sidebarCollapsed - AppSpacing.sm * 2,
                    child: Center(child: icon),
                  )
                else
                  Expanded(child: Center(child: icon)),
                if (widget.showLabels)
                  Expanded(
                    child: Text(
                      offline ? AppStrings.workingOffline : 'متّصل بالإنترنت',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: offline ? warning : theme.colorScheme.onSurface,
                        fontWeight:
                            offline ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
              ],
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
                // مطوي: الأيقونة تملأ المساحة المتاحة (عرض ثابت 48 يفيض 1px
                // عن قيود الشريط المطوي)؛ موسّع: منطقة أيقونة ثابتة 48.
                if (widget.showLabels)
                  SizedBox(
                    width: AppDesktopSizes.sidebarCollapsed - AppSpacing.sm * 2,
                    child: Center(
                      child: widget.badgeCount > 0
                          ? Badge.count(count: widget.badgeCount, child: icon)
                          : icon,
                    ),
                  )
                else
                  Expanded(
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
                      style: theme.textTheme.bodyLarge?.copyWith(
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
