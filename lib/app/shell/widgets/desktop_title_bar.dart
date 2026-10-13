import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:window_manager/window_manager.dart';

/// Custom 40-px title bar for the desktop shell.
///
/// Layout (LTR, Windows-standard):
///   LEFT: Drag area + search          RIGHT: Sync badge | Window controls
///
/// The title bar lives in [Directionality.ltr] so window controls stay in the
/// top-right corner regardless of the app's RTL locale.
class DesktopTitleBar extends ConsumerStatefulWidget {
  const DesktopTitleBar({
    required this.sidebarExpanded,
    super.key,
  });

  final bool sidebarExpanded;

  @override
  ConsumerState<DesktopTitleBar> createState() => _DesktopTitleBarState();
}

class _DesktopTitleBarState extends ConsumerState<DesktopTitleBar>
    with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _syncMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  Future<void> _syncMaximized() async {
    final max = await windowManager.isMaximized();
    if (mounted) setState(() => _isMaximized = max);
  }

  Future<void> _minimize() => windowManager.minimize();

  Future<void> _toggleMaximize() async {
    if (_isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Future<void> _close() async {
    final shouldExit = await showConfirmationDialog(
      context,
      title: AppStrings.exitTitle,
      message: AppStrings.exitMessage,
      confirmLabel: AppStrings.exit,
      icon: Icons.logout_outlined,
    );
    if (shouldExit) {
      await windowManager.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending =
        ref.watch(pendingOperationsCountProvider).value ?? 0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: AppDesktopSizes.titleBarHeight,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.extension<AppSemanticColors>()!.border,
            ),
          ),
        ),
        child: Row(
          children: [
            // Draggable area fills the available space (search field removed).
            const Expanded(
              child: DragToMoveArea(child: SizedBox.expand()),
            ),

            // Pending sync badge
            if (pending > 0)
              Tooltip(
                message: AppStrings.pendingOperations,
                child: IconButton(
                  iconSize: AppSizes.iconSm,
                  onPressed: () =>
                      ref.read(syncControllerProvider.notifier).pushNow(),
                  icon: Badge(
                    label: Text('$pending'),
                    child: const Icon(Icons.cloud_upload_outlined),
                  ),
                ),
              ),

            // Window controls — always LTR, top-right corner
            _WindowControls(
              isMaximized: _isMaximized,
              onMinimize: _minimize,
              onMaximize: _toggleMaximize,
              onClose: _close,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Window control buttons ────────────────────────────────────────────────

class _WindowControls extends StatelessWidget {
  const _WindowControls({
    required this.isMaximized,
    required this.onMinimize,
    required this.onMaximize,
    required this.onClose,
  });

  final bool isMaximized;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WinButton(
          icon: Icons.remove,
          tooltip: 'تصغير',
          onTap: onMinimize,
        ),
        _WinButton(
          icon: isMaximized ? Icons.filter_none : Icons.crop_square,
          tooltip: isMaximized ? 'استعادة' : 'تكبير',
          onTap: onMaximize,
        ),
        _WinButton(
          icon: Icons.close,
          tooltip: AppStrings.close,
          onTap: onClose,
          isClose: true,
        ),
      ],
    );
  }
}

class _WinButton extends StatefulWidget {
  const _WinButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isClose = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isClose;

  @override
  State<_WinButton> createState() => _WinButtonState();
}

class _WinButtonState extends State<_WinButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const w = 46.0;
    const h = AppDesktopSizes.titleBarHeight;

    return Tooltip(
      message: widget.tooltip,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: w,
            height: h,
            color: _hovered
                ? (widget.isClose
                    ? const Color(0xFFC42B1C)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.08))
                : Colors.transparent,
            child: Icon(
              widget.icon,
              size: 14,
              color: _hovered && widget.isClose
                  ? Colors.white
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
