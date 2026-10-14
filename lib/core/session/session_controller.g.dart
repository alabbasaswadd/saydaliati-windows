// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the auth session: on startup it decides authenticated-or-not *fast*
/// (from [_kHasSessionPref]), then loads the real bearer token from secure
/// storage in the BACKGROUND. The network interceptor awaits [awaitToken] so
/// every authed request still carries the token; the UI never blocks on it.
///
/// The real token stays in secure storage (unchanged) — only the cheap
/// presence flag moved to SharedPreferences, so no one is logged out.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// Owns the auth session: on startup it decides authenticated-or-not *fast*
/// (from [_kHasSessionPref]), then loads the real bearer token from secure
/// storage in the BACKGROUND. The network interceptor awaits [awaitToken] so
/// every authed request still carries the token; the UI never blocks on it.
///
/// The real token stays in secure storage (unchanged) — only the cheap
/// presence flag moved to SharedPreferences, so no one is logged out.
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, SessionState> {
  /// Owns the auth session: on startup it decides authenticated-or-not *fast*
  /// (from [_kHasSessionPref]), then loads the real bearer token from secure
  /// storage in the BACKGROUND. The network interceptor awaits [awaitToken] so
  /// every authed request still carries the token; the UI never blocks on it.
  ///
  /// The real token stays in secure storage (unchanged) — only the cheap
  /// presence flag moved to SharedPreferences, so no one is logged out.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();
}

String _$sessionControllerHash() => r'91c4ac46b27a5b194ba9c79a523d2d739d90ee84';

/// Owns the auth session: on startup it decides authenticated-or-not *fast*
/// (from [_kHasSessionPref]), then loads the real bearer token from secure
/// storage in the BACKGROUND. The network interceptor awaits [awaitToken] so
/// every authed request still carries the token; the UI never blocks on it.
///
/// The real token stays in secure storage (unchanged) — only the cheap
/// presence flag moved to SharedPreferences, so no one is logged out.

abstract class _$SessionController extends $AsyncNotifier<SessionState> {
  FutureOr<SessionState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SessionState>, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SessionState>, SessionState>,
              AsyncValue<SessionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
