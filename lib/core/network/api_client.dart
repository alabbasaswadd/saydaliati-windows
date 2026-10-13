import 'package:dio/dio.dart';
import 'package:saydaliati/core/network/api_envelope.dart';
import 'package:saydaliati/core/network/dio_error_mapper.dart';

/// Abstraction over the HTTP transport.
///
/// Remote data sources depend on this interface, never on [Dio] directly. Each
/// method returns the **unwrapped `data`** payload from the `ApiResult<T>`
/// envelope (a `Map`, `List`, scalar, or `null`) and throws an `AppException` on
/// any failure — so data sources only ever deal with the payload and clean
/// exceptions, never envelopes or Dio types.
abstract interface class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  /// Fetches the response body as a RAW, un-decoded JSON string (no envelope
  /// unwrapping, no main-isolate `jsonDecode`). For large payloads (the ~22.5k
  /// catalog) the caller parses it off the UI isolate via `compute`.
  Future<String> getRaw(String path, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(String path, {Object? data});

  Future<dynamic> put(String path, {Object? data});

  Future<dynamic> delete(String path, {Object? data});
}

/// Dio-backed [ApiClient]. Owns envelope unwrapping and error translation; the
/// auth header and 401 handling live in [AuthInterceptor] on the [Dio] instance.
class DioApiClient implements ApiClient {
  const DioApiClient(this._dio);

  final Dio _dio;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: queryParameters));

  @override
  Future<String> getRaw(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      // ResponseType.plain → Dio returns the body as a String without parsing
      // it on the main isolate; the caller decodes it in the background.
      final response = await _dio.get<String>(
        path,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.plain),
      );
      return response.data ?? '';
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => _dio.post<dynamic>(path, data: data));

  @override
  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put<dynamic>(path, data: data));

  @override
  Future<dynamic> delete(String path, {Object? data}) =>
      _send(() => _dio.delete<dynamic>(path, data: data));

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      final envelope = ApiEnvelope.from(response.data);

      // Logical success is signalled by the envelope's `succeeded`, not just a
      // 2xx: a 2xx with succeeded=false is treated as a business error.
      if (!envelope.succeeded) {
        throw DioErrorMapper.fromResponse(response.statusCode ?? 200, response.data);
      }
      return envelope.data;
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
