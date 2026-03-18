// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Dio Client
// HTTP client with auth, retry, and logging interceptors
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';
import 'package:nexus_ai/core/utils/logger.dart';

/// Creates and configures the global [Dio] instance.
///
/// Includes:
/// - Base URL detection (Android emulator vs desktop)
/// - Auth interceptor (adds API key header)
/// - Retry interceptor (3 attempts with exponential backoff)
/// - Talker logging interceptor
Dio createDioClient({String? apiKey}) {
  final isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  final baseUrl = isDesktop
      ? AppConstants.desktopBaseUrl
      : AppConstants.baseUrl;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.acceptHeader: ContentType.json.value,
      },
    ),
  );

  // ── Auth Interceptor ────────────────────────────────────
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (apiKey != null && apiKey.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $apiKey';
        }
        handler.next(options);
      },
    ),
  );

  // ── Retry Interceptor ───────────────────────────────────
  dio.interceptors.add(_RetryInterceptor(dio: dio));

  // ── Talker Logger ───────────────────────────────────────
  if (kDebugMode) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: logger,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
          printRequestData: true,
          printResponseData: false,
        ),
      ),
    );
  }

  return dio;
}

/// Custom retry interceptor with exponential backoff.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor({required this.dio});

  final Dio dio;
  static const int _maxRetries = 3;
  static const Duration _baseDelay = Duration(milliseconds: 500);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _isRetryable(err);
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (shouldRetry && retryCount < _maxRetries) {
      final delay = _baseDelay * (retryCount + 1);
      logger.warning('Retrying request (${retryCount + 1}/$_maxRetries) '
          'after ${delay.inMilliseconds}ms');

      await Future<void>.delayed(delay);

      try {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        handler.reject(e);
        return;
      }
    }

    handler.next(err);
  }

  bool _isRetryable(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
}
