import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saydaliati/app/shell/widgets/desktop_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saydaliati/app/shell/widgets/desktop_title_bar.dart';
import 'package:saydaliati/app/sync/data_sync_controller.dart';
import 'package:saydaliati/features/announcements/announcements_providers.dart';
import 'package:saydaliati/features/announcements/domain/announcement.dart';
import 'package:saydaliati/features/announcements/presentation/widgets/announcement_dialog.dart';
import 'package:saydaliati/features/catalog/catalog_providers.dart';
import 'package:saydaliati/features/medicines/presentation/widgets/catalog_loading_overlay.dart';
import 'package:saydaliati/shared/widgets/offline_banner.dart';

/// The desktop shell: custom title bar + collapsible sidebar + content area.
///
/// Replaces [MainShell] (bottom-navigation) for the Windows desktop target.
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

  final _searchFocusNode = FocusNode(debugLabel: 'TitleBarSearch');
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) setState(() => _sidebarExpanded = prefs.getBool(_prefKey) ?? true);
      _showAnnouncements();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    // Show the first-catalog-download overlay when there is no local mirror
    // yet and a sync is in progress (same logic as the mobile shell).
    final mirrorEmpty = ref.watch(catalogMirrorEmptyProvider).value ?? false;
    final sync = ref.watch(dataSyncControllerProvider);
    final firstLoading = mirrorEmpty && sync.running;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
            _searchFocusNode.requestFocus(),
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            Scaffold(
              body: Column(
                children: [
                  // ── Custom title bar ──────────────────────────────────────
                  DesktopTitleBar(
                    searchFocusNode: _searchFocusNode,
                    sidebarExpanded: _sidebarExpanded,
                  ),

                  // ── Sidebar + content ─────────────────────────────────────
                  Expanded(
                    child: Row(
                      // In RTL, the first child renders on the RIGHT side, which
                      // is the natural "start" position for the navigation panel.
                      children: [
                        DesktopSidebar(
                          currentIndex: widget.shell.currentIndex,
                          expanded: _sidebarExpanded,
                          onToggle: () async {
                            final next = !_sidebarExpanded;
                            setState(() => _sidebarExpanded = next);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(_prefKey, next);
                          },
                          onNavigate: _navigate,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const OfflineBanner(),
                              Expanded(child: widget.shell),
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
