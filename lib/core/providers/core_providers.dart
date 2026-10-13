import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saydaliati/core/network/api_client.dart';
import 'package:saydaliati/core/network/dio_factory.dart';
import 'package:saydaliati/core/network/interceptors/auth_interceptor.dart';
import 'package:saydaliati/core/storage/key_value_store.dart';
import 'package:saydaliati/core/storage/secure_key_value_store.dart';

part 'core_providers.g.dart';

/// Cross-cutting infrastructure providers.
///
/// These are the roots of the dependency graph: everything a feature needs
/// (an [ApiClient], a [KeyValueStore], a [Logger]) is reachable from here via
/// Riverpod. This is our dependency injection — there is no service locator.
/// Each provider is trivially overridable in tests with `overrideWithValue`.

@Riverpod(keepAlive: true)
Logger appLogger(Ref ref) => Logger();

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage();

@Riverpod(keepAlive: true)
KeyValueStore keyValueStore(Ref ref) =>
    SecureKeyValueStore(ref.watch(secureStorageProvider));

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = DioFactory.create();
  // Auth header + 401 handling. The interceptor reads the session lazily at
  // request time, so there is no build-time cycle between dio and the session.
  dio.interceptors.add(AuthInterceptor(ref));
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (o) => ref.read(appLoggerProvider).d(o),
    ));
  }
  return dio;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) => DioApiClient(ref.watch(dioProvider));
