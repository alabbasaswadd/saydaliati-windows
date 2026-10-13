// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_handlers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(outboxEndpoints)
final outboxEndpointsProvider = OutboxEndpointsProvider._();

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

final class OutboxEndpointsProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
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
  OutboxEndpointsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboxEndpointsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboxEndpointsHash();

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    return outboxEndpoints(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$outboxEndpointsHash() => r'565e747e50456ec4cccd4ed85815f38b4194ee03';
