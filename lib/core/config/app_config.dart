import 'package:flutter/foundation.dart';

/// Environment configuration, supplied at build/run time via `--dart-define`.
///
/// The base URL is configurable. Run with a custom host, e.g.:
/// ```
/// flutter run --dart-define=API_BASE_URL=https://10.0.2.2:7124
/// ```
///
/// **Android emulator:** `localhost` points at the emulator itself — use
/// `https://10.0.2.2:<port>` to reach the host machine. **iOS simulator:**
/// `localhost` works. A self-signed dev cert is accepted in debug only
/// (see [DioFactory]).
abstract final class AppConfig {
  const AppConfig._();

  /// Host origin only — **no `/pharmacy-api`** suffix, because every path in
  /// `ApiEndpoints` already carries its own prefix (`/pharmacy-api/...`, or
  /// `/api/Alternatives`). So the live calls resolve to
  /// `https://codetechsyria.com/pharmacy-api/...`.
  /// Default = PRODUCTION. Override per environment with
  /// `--dart-define=API_BASE_URL=http://169.58.139.217:5010` (dev).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://codetechsyria.com',
  );

  /// Whether to accept a self-signed dev certificate. Debug builds only.
  static bool get allowBadCertificates => kDebugMode;

  /// Web-demo mode — enabled only for the public demo build via
  /// `--dart-define=DEMO_MODE=true`. When on, the login screen is pre-filled
  /// with the shared demo credentials so visitors can sign in with one tap.
  static const bool demoMode = bool.fromEnvironment('DEMO_MODE');

  /// Demo login = the local part of the demo pharmacy's phone (dial code +963
  /// is prepended by the phone field → full `963999000000`).
  static const String demoPhoneLocal = '999000000';
  static const String demoPassword = 'demo12345';
}
