import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/routing/app_roter.dart';
import 'package:indhostels/routing/route_constants.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class DioClient {
  late final Dio dio;
  final AppSecureStorage storage;

  DioClient(this.storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.domain,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.readString("token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] =
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MDlkZDhlMGQwMmY3NjY4NTFmMDY3NyIsInN0YXR1cyI6ImFjdGl2ZSIsImlhdCI6MTc3MzkxNDIwMywiZXhwIjoxNzc0MDAwNjAzfQ.vLwTV3lpTL0NoD_0JLj-stTHhDA9PM429ZrtXs3Am_Y";

            // options.headers["Authorization"] = "Bearer $token";
          }

          AppLogger.log("📤 ${options.method} ${options.path}");

          if (options.data != null) {
            AppLogger.json(options.data);
          }

          handler.next(options);
        },

        onResponse: (response, handler) async {
          if (response.statusCode == 401 &&
              response.data["message"] ==
                  "session expired. Please login again.") {
            await storage.delete("token");
            final context = rootNavigatorKey.currentContext;
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Session expired. Please login again."),
                ),
              );
              context.go(RouteList.login);
            }
            return;
          }
          handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.log("❌ ${error.message}");
          handler.next(error);
        },
      ),
    );
  }
}

class AppLogger {
  static bool enableLogs = true;
  static bool get _canLog => enableLogs && kDebugMode;
  static void log(String msg) {
    if (!_canLog) return;
    debugPrint(msg);
  }

  static void json(dynamic data) {
    if (!_canLog) return;
    if (data is FormData) {
      debugPrint("📦 FormData request (multipart upload)");
      return;
    }
    const encoder = JsonEncoder.withIndent('  ');
    try {
      debugPrint(encoder.convert(data));
    } catch (_) {
      debugPrint(data.toString());
    }
  }
}
