import 'package:dio/dio.dart';
import 'package:saydaliati/core/errors/exceptions.dart';
import 'package:saydaliati/core/network/api_envelope.dart';

/// Maps transport-level failures onto the app's [AppException] hierarchy:
///
/// | Status | Exception |
/// | ------ | --------- |
/// | 400 | [ValidationException] (errors keyed by field) |
/// | 401 | [UnauthorizedException] |
/// | 403 | [BusinessException] (permission denied — session stays alive) |
/// | 404 | [NotFoundException] |
/// | 409 | [BusinessException] (conflict — e.g. delete blocked / duplicate) |
/// | 422 | [BusinessException] (errors keyed by business code) |
/// | 5xx | [ServerException] (generic message — raw server detail is never shown) |
///
/// Timeouts and connectivity problems become [TimeoutException] /
/// [NetworkException]. This keeps Dio types out of every layer above the client.
abstract final class DioErrorMapper {
  const DioErrorMapper._();

  static AppException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException('انتهت مهلة الطلب.');
      case DioExceptionType.connectionError:
        return const NetworkException('تعذّر الوصول إلى الخادم.');
      case DioExceptionType.badCertificate:
        return const NetworkException('شهادة خادم غير صالحة.');
      case DioExceptionType.cancel:
        return const UnknownException('تم إلغاء الطلب.');
      case DioExceptionType.badResponse:
        return fromResponse(e.response?.statusCode, e.response?.data);
      case DioExceptionType.unknown:
        return const NetworkException('حدث خطأ في الشبكة.');
    }
  }

  /// Builds an exception from an HTTP [status] and its (possibly enveloped) [body].
  static AppException fromResponse(int? status, Object? body) {
    // 5xx: خطأ من جهة الخادم. لا نُظهر التفاصيل الخام (نصوص استثناءات SQL /
    // مسارات التتبّع) للمستخدم؛ نعرض رسالة عامة فقط. أي حالة أخرى تُعالَج بحسبها.
    if (status != null && status >= 500) {
      return ServerException(
        statusCode: status,
        message: 'حدث خطأ عام في الخادم. حاول مرة أخرى لاحقاً.',
      );
    }

    final env = ApiEnvelope.from(body);
    final first = env.firstError;

    return switch (status) {
      400 => ValidationException(errors: env.errors, message: first?.message),
      401 => UnauthorizedException(first?.message),
      403 => BusinessException(
          code: first?.key ?? 'Forbidden',
          message: first?.message ?? 'ليس لديك صلاحية لتنفيذ هذا الإجراء',
          errors: env.errors,
        ),
      404 => NotFoundException(first?.message),
      409 || 422 => BusinessException(
          code: first?.key ?? 'BusinessRule',
          message: first?.message,
          errors: env.errors,
        ),
      _ => ServerException(statusCode: status, message: first?.message),
    };
  }
}
