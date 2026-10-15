import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/shell/tabs/app_tab.dart';
import 'package:saydaliati/app/shell/tabs/tabs_controller.dart';
import 'package:saydaliati/app/shell/widgets/bottom_tab_strip.dart';
import 'package:saydaliati/app/shell/widgets/new_tab_page.dart';
import 'package:saydaliati/app/shell/widgets/desktop_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saydaliati/app/shell/widgets/desktop_title_bar.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/core/network/server_capabilities.dart';
import 'package:saydaliati/features/announcements/announcements_providers.dart';
import 'package:saydaliati/features/announcements/domain/announcement.dart';
import 'package:saydaliati/features/announcements/presentation/widgets/announcement_dialog.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/currencies/presentation/providers/currency_freshness.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/catalog_loading_overlay.dart';
import 'package:saydaliati/features/onboarding/presentation/welcome_tour.dart';
import 'package:saydaliati/features/shortcuts/presentation/shortcuts_scope.dart';
import 'package:saydaliati/shared/widgets/offline_banner.dart';

/// The desktop shell: custom title bar + collapsible sidebar + content area.
///
/// Replaces the old mobile bottom-navigation shell for the Windows target.
/// The [StatefulNavigationShell] is re-used as-is; only the surrounding chrome
/// changes.  All 18 navigation branches are driven through the sidebar — the
/// first 4 (Sales, Medicines, Catalog, Home) are the original tabs; branches
/// 4-17 are sections that used to be pushed on the root navigator ("More").
class DesktopShell extends ConsumerStatefulWidget {
  const DesktopShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends ConsumerState<DesktopShell> {
  static const _prefKey = 'sidebar_expanded';

  bool _sidebarExpanded = true;

  /// آخر مسار سُجِّل تابّاً — يمنع جدولة نداء في كل إعادة بناء للقشرة
  /// (تُبنى مع كل تغيّر في المزامنة أو الاتصال، لا عند التنقّل فقط).
  String? _syncedLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) setState(() => _sidebarExpanded = prefs.getBool(_prefKey) ?? true);
      // جولة الترحيب أولاً عند أول فتح، ثم إعلانات الإصدار — حتى لا تتزاحم
      // نافذتان على المستخدم الجديد في اللحظة نفسها.
      await _maybeShowWelcome();
      if (!mounted) return;
      _showAnnouncements();
    });
  }

  /// لمحة المزايا + شرح الاختصارات، مرّة واحدة عند أول فتح.
  Future<void> _maybeShowWelcome() async {
    if (await WelcomeTour.isDone()) return;
    if (!mounted) return;
    await WelcomeTour.show(context, ref);
  }

  Future<void> _showAnnouncements() async {
    List<Announcement> items;
    try {
      items = await ref.read(pendingAnnouncementsProvider.future);
    } catch (_) {
      return;
    }
    if (!mounted || items.isEmpty) return;
    for (var i = 0; i < items.length; i++) {
      if (!mounted) break;
      final a = items[i];
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            AnnouncementDialog(announcement: a, index: i, total: items.length),
      );
      await ref.read(pendingAnnouncementsProvider.notifier).acknowledge(a.id);
    }
  }

  void _navigate(int index) {
    widget.shell.goBranch(
      index,
      initialLocation: index == widget.shell.currentIndex,
    );
    _fillActiveTab(_locationOfBranch(index), index);
  }

  /// يُسكِن التابَّ النشِط صفحةً **صراحةً** عند التنقّل من القائمة الجانبية.
  ///
  /// الاعتماعلى تغيّر المسار وحده لا يكفي: مَن يفتح تابّاً فارغاً ثم ينقر
  /// الصفحة التي كان فيها لا يتغيّر مساره، فيبقى التابّ فارغاً إلى الأبد.
  /// والمسار الفعلي قد يختلف عن المسار الافتراضي للفرع (فرعٌ على مسار شقيق)،
  /// فيُصوِّبه `_syncTab` في البناء التالي.
  void _fillActiveTab(String? location, int? branchIndex) {
    if (location == null) return;
    _syncedLocation = location;
    ref
        .read(openTabsProvider.notifier)
        .assignToActive(location, branchIndex: branchIndex);
  }

  /// يُسكِن الصفحة المعروضة **التابَّ النشِط**.
  ///
  /// هكذا يبقى التنقّل العادي داخل التابّ الواحد: نقر «المبيعات» ثم
  /// «التقارير» يُبدّل صفحة التابّ نفسه، ولا يتكاثر تابٌّ بكل نقرة. التابّ
  /// الجديد يُفتَح بزرّ «+» أو بـCtrl + نقر — بقرار المستخدم لا تلقائياً.
  ///
  /// يُنفَّذ بعد اكتمال الإطار: تعديل مزوِّد أثناء البناء ممنوع في Riverpod.
  void _syncTab(String location) {
    if (_syncedLocation == location) return;
    _syncedLocation = location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(openTabsProvider.notifier).assignToActive(
            location,
            branchIndex: widget.shell.currentIndex,
          );
    });
  }

  /// مسار فرعٍ بالرقم — يُقرأ من الراوتر نفسه لا من قائمة موازية.
  ///
  /// الشريط الجانبي يعرّف معظم عناصره برقم الفرع لا بمسار، وكتابة المسارات
  /// مرّة ثانية في قائمة يدوية كانت ستتباعد عن الراوتر عند أول تعديل.
  String? _locationOfBranch(int index) {
    final branches = widget.shell.route.branches;
    if (index < 0 || index >= branches.length) return null;

    final routes = branches[index].routes;
    if (routes.isEmpty) return null;

    final first = routes.first;
    return first is GoRoute ? first.path : null;
  }

  /// Ctrl + نقر على الشريط الجانبي: تابّ في الخلف بلا مغادرة الصفحة.
  void _openInBackground(int branchIndex, String? route) {
    final location = route ?? _locationOfBranch(branchIndex);
    if (location == null) return;

    final tab = ref.read(openTabsProvider.notifier).openWith(
          location,
          branchIndex: branchIndex,
          // لا يُنشَّط: «في الخلف» تعني أن المستخدم يبقى حيث هو.
          activate: false,
        );

    // تابٌّ يُفتَح بلا انتقال لا يراه المستخدم إن لم يُقَل له — والشريط
    // أسفل الشاشة قد يكون خارج بصره وقت النقر.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1400),
      content: Text('فُتح تابّ: ${tab.title}'),
    ));
  }

  /// زرّ «+»: تابٌّ فارغ يصبح النشِط، ثم يختار صاحبه صفحته من القائمة
  /// الجانبية — بلا قائمة اختيار تُكرّرها.
  void _addTabManually() {
    ref.read(openTabsProvider.notifier).newTab();
    // يُحفَظ المسار الحالي لا يُمحى: محوُه يجعل البناء التالي يُسكِن التابّ
    // الجديد الصفحةَ التي نحن فيها فور فتحه، وهو عكس المقصود. وحفظه يترك
    // الإسكان لأوّل اختيار حقيقي.
    _syncedLocation = GoRouterState.of(context).uri.path;
    setState(() {});
  }

  /// الانتقال إلى تابّ.
  ///
  /// `goBranch` حين يُعرَف الفرع: يُظهر الصفحة المحفوظة **كما تُركت** بلا
  /// إعادة بناء. و`go` للمسارات المتداخلة داخل فرع واحد (التقارير مثلاً)
  /// لأن الفرع يحمل مساراً واحداً في وقت واحد.
  void _openTab(AppTab tab) {
    ref.read(openTabsProvider.notifier).activate(tab.id);

    // تابٌّ فارغ: لا انتقال — تُعرَض صفحة «تابّ جديد» ويبقى محتوى الفروع
    // حيّاً خلفها.
    if (tab.location == null) {
      // كما في «+»: يُثبَّت المسار الحالي فلا يسكن التابّ الفارغ تلقائياً.
      setState(() => _syncedLocation = GoRouterState.of(context).uri.path);
      return;
    }

    _syncedLocation = tab.location;
    final sameBranch = tab.branchIndex == widget.shell.currentIndex;
    if (tab.branchIndex != null && !sameBranch) {
      widget.shell.goBranch(tab.branchIndex!);
      // الفرع قد يكون على مسارٍ آخر من مساراته الشقيقة (الحسابات/السندات)،
      // فيُصوَّب بعد تبديل الفرع لا قبله.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (GoRouterState.of(context).uri.path != tab.location) {
          context.go(tab.location!);
        }
      });
      return;
    }
    context.go(tab.location!);
  }

  @override
  Widget build(BuildContext context) {
    // Show the first-catalog-download overlay when there is no local mirror
    // yet and a sync is in progress (same logic as the mobile shell).
    // تُقرأ قدرات الخادم عند الإقلاع لا عند أول حفظ: قراءتها كسولةً تعني أن
    // أول فاتورة بعد التشغيل تأخذ المسار القديم دوماً لأن النتيجة لم تصل بعد.
    ref.watch(serverCapabilitiesProvider);

    final location = GoRouterState.of(context).uri.path;
    final activeTab = ref.watch(openTabsProvider).active;

    // التابّ الفارغ ينتظر اختيار صاحبه — يحميه `_syncedLocation` المُثبَّت
    // عند فتحه، لا شرطٌ هنا: الشرط كان يمنع إسكانه حتى بعد الاختيار.
    final showBlank = activeTab != null && activeTab.isBlank;
    _syncTab(location);

    final mirrorEmpty = ref.watch(catalogMirrorEmptyProvider).value ?? false;
    final sync = ref.watch(dataSyncControllerProvider);
    final firstLoading = mirrorEmpty && sync.running;

    // ShortcutsScope يلتقط المفاتيح قبل الشاشات فتعمل الاختصارات من أي مكان
    // داخل القشرة (شاشات الحوار المعروضة فوقها تأخذ تركيزها فلا تتأثّر).
    return CurrencyFreshness(
      child: ShortcutsScope(
        child: Stack(
          children: [
            Scaffold(
              body: Column(
                children: [
                  // ── Custom title bar ──────────────────────────────────────
                  DesktopTitleBar(sidebarExpanded: _sidebarExpanded),

                  // ── Sidebar + content ─────────────────────────────────────
                  Expanded(
                    child: Row(
                      // In RTL, the first child renders on the RIGHT side, which
                      // is the natural "start" position for the navigation panel.
                      children: [
                        DesktopSidebar(
                          currentIndex: widget.shell.currentIndex,
                          // المسار الحالي — لتظليل عناصر المسارات المتداخلة
                          // (التقارير) داخل الشريط الجانبي.
                          currentLocation: location,
                          expanded: _sidebarExpanded,
                          onToggle: () async {
                            final next = !_sidebarExpanded;
                            setState(() => _sidebarExpanded = next);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(_prefKey, next);
                          },
                          onNavigate: _navigate,
                          onNavigateRoute: (route) {
                            context.go(route);
                            _fillActiveTab(route, widget.shell.currentIndex);
                          },
                          onOpenInNewTab: _openInBackground,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const OfflineBanner(),
                              // القشرة تبقى **مُركَّبة دوماً** حتى وهي
                              // مُغطّاة: إزالتها تُسقِط IndexedStack فتضيع
                              // حالة كل الصفحات — وهو عكس المقصود من
                              // التابّات. فتُخفى ولا تُحذَف.
                              Expanded(
                                child: Stack(
                                  children: [
                                    Offstage(
                                      offstage: showBlank,
                                      child: widget.shell,
                                    ),
                                    if (showBlank)
                                      const Positioned.fill(
                                          child: NewTabPage()),
                                  ],
                                ),
                              ),
                              // شريط التابّات أسفل المحتوى: الصفحات المفتوحة
                              // والانتقال بينها بحالتها محفوظةً.
                              BottomTabStrip(
                                onSelect: _openTab,
                                onAddTab: _addTabManually,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (firstLoading)
              const Positioned.fill(child: CatalogLoadingOverlay()),
          ],
        ),
      ),
    );
  }
}
