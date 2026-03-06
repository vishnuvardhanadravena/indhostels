import 'package:dio/dio.dart';
import 'package:indhostels/data/models/auth_models/auth_req.dart';
import 'package:indhostels/data/models/auth_models/auth_res.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/apiservice/api_client.dart';
import 'package:indhostels/utils/constants/api_constants.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await api.post(
      ApiConstants.signin,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }

  Future<SignupResponceModel> signup(SignUpRequestModel request) async {
    final response = await api.post(
      ApiConstants.signup,
      data: request.toJson(),
    );

    return SignupResponceModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final response = await api.post(
      ApiConstants.verify,
      queryParameters: {
        "otp": otp,
        //  "phone": phone
      },
      // data: {"phone": phone, "otp": otp},
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    throw ApiException(message: "Invalid response format");
  }

  Future<ApiResponseModel> forgotPassword(String email) async {
    try {
      final response = await api.post(
        ApiConstants.forgotpassword,
        data: {"email": email},
      );

      return ApiResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        final status = e.response!.statusCode;

        final message = data is Map<String, dynamic>
            ? data['message']?.toString()
            : "Request failed";

        switch (status) {
          case 401:
            throw ApiException(message: message ?? "Unauthorized");

          case 404:
            throw ApiException(
              message: message ?? "Invalid mail ID, Please check",
            );

          case 500:
            throw ApiException(message: "Internal Server Error");

          default:
            throw ApiException(message: message ?? "Request failed");
        }
      }

      throw ApiException(message: "No internet connection");
    }
  }

  Future<ApiResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await api.post(
        ApiConstants.changePassword,
        data: {
          "oldpassword": currentPassword,
          "newpassword": newPassword,
          "confirmpassword": confirmPassword,
        },
      );

      return ApiResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        final status = e.response!.statusCode;

        final message = data is Map<String, dynamic>
            ? data['message']?.toString()
            : "Request failed";

        switch (status) {
          case 401:
            throw ApiException(message: message ?? "Unauthorized");
          case 400:
            throw ApiException(message: message ?? "Invalid request");
          case 500:
            throw ApiException(message: "Internal Server Error");
          default:
            throw ApiException(message: message ?? "Request failed");
        }
      }

      throw ApiException(message: "No internet connection");
    }
  }

  Future<dynamic> logout() async {
    final response = await api.put(ApiConstants.logout);

    return response.data;
  }
}
