import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:saydaliati/core/network/api_endpoints.dart';
import 'package:saydaliati/core/observers/logging_provider_observer.dart';
import 'package:saydaliati/core/offline/sync/outbox_handlers.dart';
import 'package:saydaliati/features/sales/data/repositories/sale_repository_impl.dart';

/// One place to assemble the root [ProviderScope].
///
/// Startup wiring lives here — observers, and the offline outbox endpoint
/// registry (which `kind` replays to which endpoint). Each feature that queues
/// writes adds its `kind → endpoint` mapping to the override below.
abstract final class AppBootstrap {
  const AppBootstrap._();

  static Widget wrap(Widget app) {
    WidgetsFlutterBinding.ensureInitialized();
    return ProviderScope(
      observers: [LoggingProviderObserver(Logger())],
      overrides: [
        // Queued sales replay via POST pharmacy-api/Sale when back online.
        outboxEndpointsProvider.overrideWithValue({
          kSaleOutboxKind: ApiEndpoints.sales,
        }),
      ],
      child: app,
    );
  }
}
