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

  /// منصّة التشغيل كما يفهمها الخادم.
  static String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isWindows) return 'windows';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status >= 200 && status < 300,
        headers: {
          // يُعرِّف الخادمَ بمصدر الطلب فتظهر أحداث الدخول والتسجيل موسومةً
          // بمنصّتها. بدونها يستنتج الخادم من User-Agent، و«Dart/x.y
          // (dart:io)» واحدٌ على ويندوز والأندرويد — فيُقرأ سطح المكتب جوالاً.
          'X-Client-Platform': _platform,
        },
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
