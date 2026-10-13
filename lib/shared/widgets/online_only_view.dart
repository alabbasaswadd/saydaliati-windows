import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/offline/connectivity/work_mode.dart';
import 'package:saydaliati/shared/widgets/states/app_states.dart';

/// Gate for online-only content (lists/reports that have no offline cache).
///
/// While the device is offline it shows the animated [OfflineState] *proactively*
/// — before any request is attempted — instead of a spinner then an error. When
/// connectivity returns it calls [onReconnect] (typically a list refresh) and
/// reveals [child].
class OnlineOnlyView extends ConsumerWidget {
  const OnlineOnlyView({required this.child, this.onReconnect, super.key});

  final Widget child;
  final VoidCallback? onReconnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(effectiveOnlineProvider, (previous, next) {
      if (next == true && previous == false) onReconnect?.call();
    });

    if (!ref.watch(effectiveOnlineProvider)) {
      return OfflineState(onRetry: onReconnect);
    }
    return child;
  }
}
