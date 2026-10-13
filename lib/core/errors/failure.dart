import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// The domain-facing error model.
///
/// A [Failure] is what the presentation layer sees — never a [DioException], a
/// SQL error, or a raw [Exception]. The data layer catches infrastructure
/// exceptions and maps them onto one of these cases (see `failure_mapper.dart`).
@freezed
sealed class Failure with _$Failure {
  const Failure._();

  /// No connectivity / DNS / socket problem — the request never reached a server.
  const factory Failure.network({String? message}) = NetworkFailure;

  /// The server was reached but responded with a 5xx or an otherwise unexpected error.
  const factory Failure.server({int? statusCode, String? message}) = ServerFailure;

  /// Authentication is missing or expired (401). The session should end.
  const factory Failure.unauthorized({String? message}) = UnauthorizedFailure;

  /// Input rejected by validation (400). [errors] is a field → messages map.
  const factory Failure.validation({
    @Default(<String, List<String>>{}) Map<String, List<String>> errors,
    String? message,
  }) = ValidationFailure;

  /// A business rule was violated (422/409). [code] is the backend error code.
  const factory Failure.business({
    required String code,
    String? message,
    @Default(<String, List<String>>{}) Map<String, List<String>> errors,
  }) = BusinessFailure;

  /// The requested resource does not exist (404).
  const factory Failure.notFound({String? message}) = NotFoundFailure;

  /// The request exceeded its deadline.
  const factory Failure.timeout({String? message}) = TimeoutFailure;

  /// Anything not covered above. The safe default.
  const factory Failure.unknown({String? message}) = UnknownFailure;

  /// A human-readable message suitable for logging or a fallback UI string.
  /// Presentation code should prefer localized copy keyed off the case/[code].
  String get displayMessage => switch (this) {
        NetworkFailure(:final message) => message ?? 'لا يوجد اتصال بالإنترنت.',
        ServerFailure(:final message) => message ?? 'حدث خطأ في الخادم.',
        UnauthorizedFailure(:final message) => message ?? 'انتهت صلاحية الجلسة.',
        ValidationFailure(:final message, :final errors) =>
          message ?? _firstError(errors) ?? 'بعض الحقول غير صحيحة.',
        BusinessFailure(:final message) => message ?? 'هذا الإجراء غير مسموح.',
        NotFoundFailure(:final message) => message ?? 'غير موجود.',
        TimeoutFailure(:final message) => message ?? 'انتهت مهلة الطلب.',
        UnknownFailure(:final message) => message ?? 'حدث خطأ ما.',
      };

  static String? _firstError(Map<String, List<String>> errors) {
    for (final list in errors.values) {
      if (list.isNotEmpty) return list.first;
    }
    return null;
  }
}
