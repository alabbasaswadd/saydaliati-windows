import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/core/offline/sync/sync_service.dart';

/// A thin status strip shown app-wide whenever the app is working offline —
/// either the user forced offline mode or there's no connection — with the count
/// of operations still queued to sync.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(effectiveOnlineProvider)) return const SizedBox.shrink();
    final pending = ref.watch(pendingOperationsCountProvider).value ?? 0;
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.cloud_off,
                  size: 18, color: theme.colorScheme.onErrorContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pending > 0
                      ? '${AppStrings.workingOffline} • ${AppStrings.pendingOperations}: $pending'
                      : AppStrings.workingOffline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
