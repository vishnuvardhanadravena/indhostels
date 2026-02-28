import 'package:dio/dio.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.BaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Example: attach token automatically
          // final token = TokenStorage.getToken();
          // if (token != null) {
          //   options.headers["Authorization"] = "Bearer $token";
          // }

          return handler.next(options);
        },
        onError: (error, handler) {
          final message =
              error.response?.data?["message"] ?? "Something went wrong";

          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ApiException(
                statusCode: error.response?.statusCode,
                message: message,
              ),
            ),
          );
        },
      ),
    );
  }
}
