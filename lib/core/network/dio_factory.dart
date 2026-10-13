import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:saydaliati/core/config/app_config.dart';
import 'package:saydaliati/core/constants/app_constants.dart';

/// Builds the app's [Dio] instance with base options and timeouts.
///
/// Interceptors (auth header, 401 handling, logging) are added by the
/// `dioProvider` so they can reach Riverpod. The base URL comes from
/// [AppConfig]. In debug on non-web platforms a self-signed dev certificate is
/// accepted — never in release.
abstract final class DioFactory {
  const DioFactory._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    if (!kIsWeb && AppConfig.allowBadCertificates) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () => HttpClient()
          ..badCertificateCallback = (cert, host, port) => true,
      );
    }

    return dio;
  }
}
