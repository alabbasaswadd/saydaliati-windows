import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/shared/widgets/feedback/app_snackbar.dart';

/// An app-bar action that pulls fresh data from the server into the local cache
/// (local-first "تحديث" button). When offline it says so instead of trying;
/// otherwise it shows a spinner while running and a success snackbar when done.
class RefreshDataButton extends ConsumerStatefulWidget {
  const RefreshDataButton({required this.onRefresh, super.key});

  /// Returns true on success. Typically a notifier's `forceRefresh`.
  final Future<bool> Function() onRefresh;

  @override
  ConsumerState<RefreshDataButton> createState() => _RefreshDataButtonState();
}

class _RefreshDataButtonState extends ConsumerState<RefreshDataButton> {
  bool _busy = false;

  Future<void> _run() async {
    if (_busy) return;
    // No network → tell the user instead of a pointless attempt.
    if (!ref.read(effectiveOnlineProvider)) {
      AppSnackbar.error(context, AppStrings.noInternetToRefresh);
      return;
    }
    setState(() => _busy = true);
    final ok = await widget.onRefresh();
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      AppSnackbar.success(context, AppStrings.dataRefreshed);
    } else {
      AppSnackbar.error(
        context,
        ref.read(effectiveOnlineProvider)
            ? AppStrings.errorDefault
            : AppStrings.noInternetToRefresh,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppStrings.refreshData,
      onPressed: _busy ? null : _run,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_sync_outlined),
    );
  }
}
