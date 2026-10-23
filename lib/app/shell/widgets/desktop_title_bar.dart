import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/app/shell/widgets/exchange_rate_header.dart';
import 'package:saydaliati/app/shell/widgets/window_controls.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';
import 'package:saydaliati/core/theme/app_semantic_colors.dart';
import 'package:saydaliati/core/theme/app_spacing.dart';
import 'package:saydaliati/shared/widgets/dialogs/app_dialogs.dart';
import 'package:window_manager/window_manager.dart';

/// Custom 40-px title bar for the desktop shell.
///
/// Layout (LTR, Windows-standard):
///   LEFT: Drag area                   RIGHT: Exchange rate | Sync badge |
///                                            Window controls
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

class _DesktopTitleBarState extends ConsumerState<DesktopTitleBar> {
  /// تأكيدٌ قبل الإغلاق — فاتورةٌ نصف مكتوبة تضيع بنقرةٍ واحدة بلا سؤال.
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

            const ExchangeRateHeader(),
            const SizedBox(width: AppSpacing.xs),

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
            WindowControls(onClose: _close),
          ],
        ),
      ),
    );
  }
}
