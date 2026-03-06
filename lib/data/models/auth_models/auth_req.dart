class LoginRequestModel {
  final String phone;
  final String? password;

  LoginRequestModel({required this.phone, this.password});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{"phone": phone};

    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
    }

    return data;
  }
}

class SignUpRequestModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isTermsAccepted;

  SignUpRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.isTermsAccepted,
  });

  Map<String, dynamic> toJson() => {
    "fullname": fullName,
    "email": email,
    "phone": int.tryParse(phone) ?? phone,
    "password": password,
    "confirmpassword": confirmPassword,
    "istermsandConditions": isTermsAccepted,
  };
}

class ApiResponseModel {
  final bool success;
  final int? statuscode;
  final String? message;
  final dynamic data;

  ApiResponseModel({
    required this.success,
    this.statuscode,
    this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      success: json['success'] ?? false,
      statuscode: json['statuscode'],
      message: json['message'],
      data: json,
    );
  }
}
