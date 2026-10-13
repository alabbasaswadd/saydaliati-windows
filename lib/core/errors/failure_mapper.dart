import 'package:saydaliati/core/errors/exceptions.dart';
import 'package:saydaliati/core/errors/failure.dart';

/// Translates a data-layer [AppException] (or any stray error) into a
/// domain-facing [Failure].
///
/// This is the *only* place the two hierarchies meet. Repositories call it in
/// their `catch` blocks so no infrastructure type leaks past the data boundary.
/// The HTTP-status → exception mapping happens earlier, in the API client
/// (`dio_error_mapper.dart`); this step is purely exception → failure.
Failure mapExceptionToFailure(Object error) => switch (error) {
      NetworkException(:final message) => Failure.network(message: message),
      TimeoutException(:final message) => Failure.timeout(message: message),
      UnauthorizedException(:final message) => Failure.unauthorized(message: message),
      NotFoundException(:final message) => Failure.notFound(message: message),
      ValidationException(:final errors, :final message) =>
        Failure.validation(errors: errors, message: message),
      BusinessException(:final code, :final message, :final errors) =>
        Failure.business(code: code, message: message, errors: errors),
      ServerException(:final statusCode, :final message) =>
        Failure.server(statusCode: statusCode, message: message),
      UnknownException(:final message) => Failure.unknown(message: message),
      _ => Failure.unknown(message: error.toString()),
    };
