class LoginResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final String token;
  final String username;
  final String userId;
  final String role;
  final String email;
  final String phone;

  LoginResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.token,
    required this.username,
    required this.userId,
    required this.role,
    required this.email,
    required this.phone,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json["success"] ?? false,
      statusCode: json["statuscode"] ?? 0,
      message: json["message"] ?? "",
      token: json["JWTtoken"] ?? "",
      username: json["username"] ?? "",
      userId: json["userID"] ?? "",
      role: json["role"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statuscode": statusCode,
      "message": message,
      "JWTtoken": token,
      "username": username,
      "userID": userId,
      "role": role,
      "email": email,
      "phone": phone,
    };
  }
}
class SignupResponceModel {
  bool? success;
  String? message;
  int? otp;
  String? otpExpiry;
  int? statuscode;

  SignupResponceModel(
      {this.success, this.message, this.otp, this.otpExpiry, this.statuscode});

  SignupResponceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    otp = json['otp'];
    otpExpiry = json['otp_expiry'];
    statuscode = json['statuscode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['otp'] = otp;
    data['otp_expiry'] = otpExpiry;
    data['statuscode'] = statuscode;
    return data;
  }
}
