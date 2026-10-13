import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saydaliati/core/session/session_controller.dart';

/// Attaches the bearer token to every request and reacts to 401s.
///
/// * **onRequest** — reads the in-memory token from [SessionController] and adds
///   `Authorization: Bearer <token>` when present. Anonymous endpoints simply
///   have no token, so nothing is added.
/// * **onError** — a **401 is the auth contract's signal** that the token is
///   invalid/expired, so the session is cleared (→ router sends the user to
///   login). No other status ends the session.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Await the real token: on a cold start the UI gate proceeds before the
    // token finishes loading from secure storage, so reading it synchronously
    // could miss it. Once loaded this resolves instantly.
    final token =
        await _ref.read(sessionControllerProvider.notifier).awaitToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Only treat a 401 as "the session is invalid" when the request actually
    // carried our bearer token. Anonymous requests (e.g. a background catalog
    // pull that fired before login) naturally get 401 from authed endpoints and
    // must NOT clear a freshly-created session — that caused a log-in-then-out loop.
    final sentToken =
        err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && sentToken) {
      // Fire-and-forget: clearing persisted secrets is async, but the error must
      // continue to propagate to the caller as an UnauthorizedException.
      unawaited(_ref.read(sessionControllerProvider.notifier).clear());
    }
    handler.next(err);
  }
}
