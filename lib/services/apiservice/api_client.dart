import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/apiservice/circut_breaker.dart';

class ApiClient {
  final Dio _dio;
  final CircuitBreaker _circuitBreaker = CircuitBreaker();
  ApiClient(this._dio);

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _request(
      () => _dio.get(path, queryParameters: query),
      method: "GET",
      path: path,
      body: query,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      method: "POST",
      path: path,
      body: data,
    );
  }

  Future<Response> put(String path, {dynamic data}) {
    return _request(
      () => _dio.put(path, data: data),
      method: "PUT",
      path: path,
      body: data,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.delete(path, data: data, queryParameters: queryParameters),
      method: "DELETE",
      path: path,
      body: data ?? queryParameters,
    );
  }

  Future<Response> multipart(
    String path, {
    Map<String, dynamic>? fields,
    required String filePath,
    required String fileKey,
  }) async {
    final formData = FormData.fromMap({
      ...?fields,
      fileKey: await MultipartFile.fromFile(filePath),
    });

    return _request(
      () => _dio.post(
        path,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      ),
      method: "MULTIPART",
      path: path,
      body: fields,
    );
  }

  Future<Response> _request(
    Future<Response> Function() request, {
    required String method,
    required String path,
    dynamic body,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // _logRequest(method, path, body);

      final response = await request();

      stopwatch.stop();

      _logResponse(method, path, response, stopwatch.elapsedMilliseconds);

      if (_isSuccess(response.statusCode)) {
        _circuitBreaker.onSuccess();
        return response;
      }

      _circuitBreaker.onFailure();

      throw ApiException(
        statusCode: response.statusCode,
        message:
            _extractMessage(response.data) ??
            "Server error (${response.statusCode})",
      );
    } catch (e) {
      stopwatch.stop();

      final error = _mapError(e);

      _circuitBreaker.onFailure();

      _logError(method, path, error.message);

      throw error;
    }
  }

  bool _isSuccess(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  // ================= ERROR HANDLING =================

  ApiException _mapError(dynamic e) {
    if (e is ApiException) return e;

    if (e is DioException) {
      AppLogger.warning("⚠️ DioException");
      AppLogger.warning("Type: ${e.type}");
      AppLogger.warning("Status: ${e.response?.statusCode}");
      AppLogger.warning("Message: ${e.message}");
      AppLogger.warning("Error: ${e.error}");

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException(message: "Connection timed out.");

        case DioExceptionType.sendTimeout:
          return ApiException(message: "Request send timeout.");

        case DioExceptionType.receiveTimeout:
          return ApiException(message: "Server took too long to respond.");

        case DioExceptionType.connectionError:
          return ApiException(message: "No internet connection.");

        case DioExceptionType.cancel:
          return ApiException(message: "Request cancelled.");

        case DioExceptionType.badResponse:
          return ApiException(
            statusCode: e.response?.statusCode,
            message:
                _extractMessage(e.response?.data) ??
                "Server error (${e.response?.statusCode})",
          );

        case DioExceptionType.unknown:
          return _handleUnknownError(e);
        case DioExceptionType.badCertificate:
          throw UnimplementedError();
      }
    }

    return ApiException(message: "Unexpected error occurred.");
  }

  ApiException _handleUnknownError(DioException e) {
    final underlying = e.error;

    if (underlying is SocketException) {
      return ApiException(message: "No internet connection.");
    }

    if (underlying is TimeoutException) {
      return ApiException(message: "Connection timeout.");
    }

    if (underlying is HandshakeException) {
      return ApiException(message: "SSL handshake failed.");
    }

    if (underlying is FormatException) {
      return ApiException(message: "Invalid response format.");
    }

    return ApiException(
      message: underlying?.toString() ?? "Unknown network error.",
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final message = data["message"] ?? data["error"] ?? data["detail"];
      if (message != null) return message.toString();
    }

    if (data is String && data.isNotEmpty) return data;

    return null;
  }

  // ================= LOGGING =================

  void _logRequest(
    String method,
    String path,
    dynamic body, {
    Options? options,
  }) {
    if (!AppLogger.canLog) return;

    AppLogger.debug("📤 [$method] $path");

    final headers = {..._dio.options.headers, ...?options?.headers};

    AppLogger.debug("Headers:");
    AppLogger.prettyJson(headers);

    if (body != null) {
      AppLogger.debug("Body:");
      AppLogger.prettyJson(body);
    }
  }

  void _logResponse(String method, String path, Response response, int time) {
    if (!AppLogger.canLog) return;

    AppLogger.debug("📥 [$method] $path");
    AppLogger.debug("Status: ${response.statusCode}");
    AppLogger.debug("Duration: ${time}ms");

    if (response.data != null) {
      AppLogger.prettyJson(response.data);
    }
  }

  void _logError(String method, String path, String message) {
    if (!AppLogger.canLog) return;

    AppLogger.error("❌ [$method] $path ERROR → $message");
  }
}

class AppLogger {
  static bool enableLogs = true;

  static const _blue = '\x1B[34m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _yellow = '\x1B[33m';
  static const _reset = '\x1B[0m';

  static bool get canLog => enableLogs && kDebugMode;

  static void debug(String msg) {
    if (!canLog) return;
    debugPrint("$_blue$msg$_reset");
  }

  static void success(String msg) {
    if (!canLog) return;
    debugPrint("$_green$msg$_reset");
  }

  static void error(String msg) {
    if (!canLog) return;
    debugPrint("$_red$msg$_reset");
  }

  static void warning(String msg) {
    if (!canLog) return;
    debugPrint("$_yellow$msg$_reset");
  }

  static void prettyJson(dynamic data) {
    if (!canLog) return;

    try {
      const encoder = JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(data));
    } catch (_) {
      debugPrint(data.toString());
    }
  }
}
