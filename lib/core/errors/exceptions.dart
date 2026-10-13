/// Infrastructure-level exceptions thrown *inside* the data layer.
///
/// Data sources / the API client throw these; repositories catch them and
/// translate them into a [Failure] (see `failure_mapper.dart`). They never cross
/// into domain or presentation code — that boundary only ever sees
/// `Result` / `Failure`.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String? message;

  @override
  String toString() => '$runtimeType(${message ?? ''})';
}

/// No connectivity — the request never reached the server.
class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// The server was reached but responded with an unexpected/5xx error.
class ServerException extends AppException {
  const ServerException({this.statusCode, String? message}) : super(message);

  final int? statusCode;
}

/// 401 — missing / invalid / expired / malformed token. The auth *contract*
/// signal to end the session (see [AuthInterceptor]).
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

/// 404 — resource missing, or it belongs to another tenant.
class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

/// The request exceeded its deadline.
class TimeoutException extends AppException {
  const TimeoutException([super.message]);
}

/// 400 — validation failure. [errors] is keyed by **field name**.
class ValidationException extends AppException {
  const ValidationException({
    this.errors = const <String, List<String>>{},
    String? message,
  }) : super(message);

  final Map<String, List<String>> errors;
}

/// 422 / 409 — a business rule. [code] is the error code (match on it, never on
/// the — often Arabic — text); [message] is the server's message.
class BusinessException extends AppException {
  const BusinessException({
    required this.code,
    String? message,
    this.errors = const <String, List<String>>{},
  }) : super(message);

  final String code;
  final Map<String, List<String>> errors;
}

/// Anything not covered above. The safe default.
class UnknownException extends AppException {
  const UnknownException([super.message]);
}
