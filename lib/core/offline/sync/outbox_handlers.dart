import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'outbox_handlers.g.dart';

/// Maps an outbox item's `kind` to the API endpoint that replays it — a POST of
/// the stored payload. This is the registry the [SyncController] drains against.
///
/// The foundation ships it empty. Each feature registers its own kinds by
/// overriding this provider in the root `ProviderScope`, e.g. in
/// `app_bootstrap.dart`:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     outboxEndpointsProvider.overrideWithValue({
///       'createSale': ApiEndpoints.salesInvoices,
///       'createProduct': ApiEndpoints.products,
///     }),
///   ],
///   child: app,
/// );
/// ```
///
/// A `kind` with no entry here is marked failed (unknown operation) rather than
/// retried forever.
@Riverpod(keepAlive: true)
Map<String, String> outboxEndpoints(Ref ref) => const <String, String>{};
