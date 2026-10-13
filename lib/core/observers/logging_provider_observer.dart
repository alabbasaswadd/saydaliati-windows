import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Logs provider lifecycle and failures during development.
///
/// [ProviderObserver] is an `abstract base class` in Riverpod 3, so this
/// subclass is declared `final`. Attached to the root [ProviderScope] in
/// `app_bootstrap.dart`. It observes only — it holds no app state.
final class LoggingProviderObserver extends ProviderObserver {
  LoggingProviderObserver(this._logger);

  final Logger _logger;

  String _name(ProviderObserverContext context) =>
      context.provider.name ?? context.provider.runtimeType.toString();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.e('Provider failed: ${_name(context)}',
        error: error, stackTrace: stackTrace);
  }
}
