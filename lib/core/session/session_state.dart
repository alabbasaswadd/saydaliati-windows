import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

/// The app's authentication session, held in memory and mirrored to secure
/// storage by [SessionController].
///
/// This is a *core* concept (infrastructure), not auth business logic: the Dio
/// interceptor and the router read it, and the auth feature drives it. Kept a
/// sealed union so "authenticated vs not" is exhaustive; the "still checking"
/// phase is represented by the `AsyncValue.loading` around it, not a third case.
@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.authenticated({
    required String token,
    String? userId,
    String? tenantId,
  }) = Authenticated;

  const factory SessionState.unauthenticated() = Unauthenticated;
}
