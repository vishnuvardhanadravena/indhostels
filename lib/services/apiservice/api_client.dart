import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // ================== PUBLIC METHODS ==================

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return _request(
      () => _dio.get(path, queryParameters: query),
      method: "GET",
      path: path,
      body: query,
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _request(
      () => _dio.post(path, data: data),
      method: "POST",
      path: path,
      body: data,
    );
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _request(
      () => _dio.put(path, data: data),
      method: "PUT",
      path: path,
      body: data,
    );
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return _request(
      () => _dio.delete(path, data: data),
      method: "DELETE",
      path: path,
      body: data,
    );
  }

  Future<Response> multipart(
    String path, {
    required Map<String, dynamic> fields,
    required String filePath,
    required String fileKey,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
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

  // ================== CORE REQUEST HANDLER ==================

  Future<Response> _request(
    Future<Response> Function() request, {
    required String method,
    required String path,
    dynamic body,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      _logRequest(method, path, body);

      final response = await request();
      stopwatch.stop();

      _logResponse(method, path, response, stopwatch.elapsedMilliseconds);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response;
      }

      final message =
          _extractMessage(response.data) ??
          "Server error (${response.statusCode})";

      throw ApiException(message: message);
    } catch (e) {
      stopwatch.stop();
      final error = _mapError(e);
      _logError(method, path, error.message);
      throw error;
    }
  }

  // ================== ERROR MAPPING ==================

  ApiException _mapError(dynamic e) {
    if (e is ApiException) return e;

    if (e is DioException) {
      // Log everything for debugging
      AppLogger.warning("⚠️ DioException:");
      AppLogger.warning("   type    → ${e.type}");
      AppLogger.warning("   message → ${e.message ?? 'null'}");
      AppLogger.warning("   error   → ${e.error ?? 'null'}");
      AppLogger.warning("   status  → ${e.response?.statusCode ?? 'null'}");

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException(
            message: "Connection timed out. Please try again.",
          );

        case DioExceptionType.sendTimeout:
          return ApiException(
            message: "Request send timed out. Please try again.",
          );

        case DioExceptionType.receiveTimeout:
          return ApiException(message: "Server took too long to respond.");

        case DioExceptionType.badResponse:
          final message =
              _extractMessage(e.response?.data) ??
              "Server error (${e.response?.statusCode ?? 'unknown'})";
          return ApiException(message: message);

        case DioExceptionType.cancel:
          return ApiException(message: "Request was cancelled.");

        case DioExceptionType.connectionError:
          return ApiException(message: "No internet connection.");

        case DioExceptionType.unknown:
          return _handleUnknownError(e);

        default:
          return ApiException(message: "Network error. Please try again.");
      }
    }

    AppLogger.error("❗ Unexpected error: $e");
    return ApiException(message: "Unexpected error occurred.");
  }

  /// Handles DioExceptionType.unknown by inspecting the root cause
  ApiException _handleUnknownError(DioException e) {
    final underlying = e.error;

    if (underlying is SocketException) {
      AppLogger.warning("   SocketException → ${underlying.message}");
      return ApiException(message: "No internet connection.");
    }

    if (underlying is HandshakeException) {
      AppLogger.warning("   HandshakeException → ${underlying.message}");
      return ApiException(
        message: "Secure connection failed. Check SSL settings.",
      );
    }

    if (underlying is FormatException) {
      AppLogger.warning("   FormatException → ${underlying.message}");
      return ApiException(message: "Invalid response format from server.");
    }

    if (underlying is TimeoutException) {
      AppLogger.warning("   TimeoutException → ${underlying.message}");
      return ApiException(message: "Connection timed out.");
    }

    // Fallback: use whatever info is available
    final message =
        e.message ?? underlying?.toString() ?? "Unknown network error.";

    AppLogger.warning("   Unknown underlying error → $message");
    return ApiException(message: message);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      // Support common backend message keys
      final message = data['message'] ?? data['error'] ?? data['detail'];
      if (message != null) return message.toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return null;
  }

  // ================== LOGGING ==================

  void _logRequest(String method, String path, dynamic body) {
    if (!AppLogger._canLog) return;

    AppLogger.debug("📤 [$method] $path");

    final headers = Map.from(_dio.options.headers);
    if (headers.containsKey("Authorization")) {
      headers["Authorization"] = "Bearer ********";
    }

    AppLogger.debug("🔐 Headers:");
    AppLogger.prettyJson(headers);

    if (body != null) {
      AppLogger.debug("📝 Body:");
      AppLogger.prettyJson(body);
    }
  }

  void _logResponse(String method, String path, Response response, int time) {
    if (!AppLogger._canLog) return;

    AppLogger.debug("📥 Status: ${response.statusCode}");
    AppLogger.debug("⏱ Duration: ${time}ms");

    if (response.data != null) {
      AppLogger.debug("📦 Response:");
      AppLogger.prettyJson(response.data);
    }

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      AppLogger.success("✅ [$method] $path SUCCESS");
    } else {
      AppLogger.error("❌ [$method] $path FAILED");
    }
  }

  void _logError(String method, String path, String message) {
    if (!AppLogger._canLog) return;
    AppLogger.error("❌ [$method] $path ERROR: $message");
  }
}

// ================== LOGGER ==================

class AppLogger {
  static bool enableLogs = true;

  static const _blue = '\x1B[34m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _yellow = '\x1B[33m';
  static const _reset = '\x1B[0m';

  static bool get _canLog => enableLogs && kDebugMode;

  static void debug(String msg) {
    if (!_canLog) return;
    debugPrint("$_blue$msg$_reset");
  }

  static void success(String msg) {
    if (!_canLog) return;
    debugPrint("$_green$msg$_reset");
  }

  static void error(String msg) {
    if (!_canLog) return;
    debugPrint("$_red$msg$_reset");
  }

  static void warning(String msg) {
    if (!_canLog) return;
    debugPrint("$_yellow$msg$_reset");
  }

  static void prettyJson(dynamic data) {
    if (!_canLog) return;
    try {
      const encoder = JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(data));
    } catch (_) {
      debugPrint(data.toString());
    }
  }
}
