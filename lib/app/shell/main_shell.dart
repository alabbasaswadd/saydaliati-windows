import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/announcements/announcements_providers.dart';
import 'package:saydaliati/features/announcements/domain/announcement.dart';
import 'package:saydaliati/features/announcements/presentation/widgets/announcement_dialog.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/catalog_loading_overlay.dart';
import 'package:saydaliati/features/onboarding/onboarding_coach.dart';
import 'package:saydaliati/features/onboarding/onboarding_controller.dart';
import 'package:saydaliati/shared/widgets/offline_banner.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// The bottom-navigation shell hosting the main tabs. Each tab is a branch of a
/// [StatefulShellRoute] with its own navigation stack and preserved state.
///
/// Also the host of the first-run tour: on first launch it spotlights the tabs
/// then hands off to the per-screen coach marks (add medicine → add purchase).
///
/// Back behaviour (fixes "Back exits the app"):
///  * Detail/create/edit pages are pushed on the ROOT navigator, so system Back
///    pops them first (handled before this widget's [PopScope]).
///  * When the shell itself is on top and the user is not on the first tab, Back
///    switches to the first tab.
///  * On the first tab, Back asks for exit confirmation instead of leaving.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final _salesKey = GlobalKey();
  final _productsKey = GlobalKey();
  final _catalogKey = GlobalKey();
  final _reportsKey = GlobalKey();
  final _moreKey = GlobalKey();
  bool _tabsCoachShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(onboardingControllerProvider.notifier).maybeStart();
      if (!mounted) return;
      final st = ref.read(onboardingControllerProvider);
      if (st.active && st.stage == OnboardingStage.tabs) {
        _showTabsCoach();
      } else if (!st.active) {
        // Show one-time announcements after login — but not during the first-run
        // tour, so they don't overlap the coach marks.
        _showAnnouncements();
      }
    });
  }

  /// Fetches the pending announcements and shows each once in a styled popup,
  /// acknowledging it so it never appears again. Best-effort: any failure is
  /// swallowed and never blocks the app.
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

  void _showTabsCoach() {
    if (_tabsCoachShown) return;
    _tabsCoachShown = true;
    final notifier = ref.read(onboardingControllerProvider.notifier);
    showCoach(
      context,
      steps: [
        CoachStep(
            key: _salesKey,
            title: AppStrings.onbSalesTitle,
            text: AppStrings.onbSalesText,
            shape: ShapeLightFocus.Circle,
            align: ContentAlign.top),
        CoachStep(
            key: _productsKey,
            title: AppStrings.onbProductsTitle,
            text: AppStrings.onbProductsText,
            shape: ShapeLightFocus.Circle,
            align: ContentAlign.top),
        CoachStep(
            key: _reportsKey,
            title: AppStrings.onbReportsTitle,
            text: AppStrings.onbReportsText,
            shape: ShapeLightFocus.Circle,
            align: ContentAlign.top),
        CoachStep(
            key: _moreKey,
            title: AppStrings.onbMoreTitle,
            text: AppStrings.onbMoreText,
            shape: ShapeLightFocus.Circle,
            align: ContentAlign.top),
      ],
      // After the tabs tour, guide the user into adding the first medicine.
      onFinish: () => notifier.toStage(OnboardingStage.medicine),
      onSkip: () => notifier.finish(),
    );
  }

  Future<void> _handleBack(BuildContext context, bool didPop) async {
    if (didPop) return;
    if (widget.shell.currentIndex != 0) {
      widget.shell.goBranch(0);
      return;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.exitTitle),
        content: const Text(AppStrings.exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.exit),
          ),
        ],
      ),
    );
    if (shouldExit ?? false) {
      await SystemNavigator.pop();
    }
  }

  void _onTap(int index) {
    widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // React to (re)activation of the tabs stage — covers "replay" from Settings.
    ref.listen<OnboardingState>(onboardingControllerProvider, (prev, next) {
      if (!next.active) {
        _tabsCoachShown = false;
        return;
      }
      if (next.stage == OnboardingStage.tabs && !_tabsCoachShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showTabsCoach();
        });
      }
    });

    // Show the friendly waiting screen ONLY on the very first catalog download —
    // i.e. when the on-device mirror is still empty AND a sync is running. On
    // every later launch the mirror persists on disk, so the app opens instantly
    // while any refresh runs silently in the background (no overlay).
    final mirrorEmpty = ref.watch(catalogMirrorEmptyProvider).value ?? false;
    final sync = ref.watch(dataSyncControllerProvider);
    final firstLoading = mirrorEmpty && sync.running;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _handleBack(context, didPop),
      child: Stack(
        children: [
          Scaffold(
            body: Column(
              children: [
                const OfflineBanner(),
                Expanded(child: widget.shell),
              ],
            ),
            bottomNavigationBar: _SmoothNavBar(
              currentIndex: widget.shell.currentIndex,
              onTap: _onTap,
              theme: theme,
              salesKey: _salesKey,
              productsKey: _productsKey,
              catalogKey: _catalogKey,
              reportsKey: _reportsKey,
              moreKey: _moreKey,
            ),
          ),
          if (firstLoading) const Positioned.fill(child: CatalogLoadingOverlay()),
        ],
      ),
    );
  }
}

/// A softer, more attractive bottom navigation: a floating rounded surface with
/// a subtle top shadow, a pill indicator, and labels only under the active tab.
class _SmoothNavBar extends StatelessWidget {
  const _SmoothNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.theme,
    required this.salesKey,
    required this.productsKey,
    required this.catalogKey,
    required this.reportsKey,
    required this.moreKey,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final ThemeData theme;
  final GlobalKey salesKey;
  final GlobalKey productsKey;
  final GlobalKey catalogKey;
  final GlobalKey reportsKey;
  final GlobalKey moreKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 66,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.14),
            indicatorShape: const StadiumBorder(),
            labelBehavior:
                NavigationDestinationLabelBehavior.onlyShowSelected,
            iconTheme: WidgetStateProperty.resolveWith(
              (states) => IconThemeData(
                color: states.contains(WidgetState.selected)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            labelTextStyle: WidgetStateProperty.all(
              theme.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            animationDuration: const Duration(milliseconds: 450),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.point_of_sale_outlined, key: salesKey),
                selectedIcon: const Icon(Icons.point_of_sale),
                label: AppStrings.tabSales,
              ),
              NavigationDestination(
                icon: Icon(Icons.medication_outlined, key: productsKey),
                selectedIcon: const Icon(Icons.medication),
                label: AppStrings.tabProducts,
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined, key: catalogKey),
                selectedIcon: const Icon(Icons.menu_book),
                label: 'كاتلوغ',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined, key: reportsKey),
                selectedIcon: const Icon(Icons.bar_chart),
                label: AppStrings.tabHome,
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined, key: moreKey),
                selectedIcon: const Icon(Icons.grid_view),
                label: AppStrings.tabMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
