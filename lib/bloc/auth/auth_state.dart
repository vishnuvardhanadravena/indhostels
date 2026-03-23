import 'package:indhostels/data/models/auth_models/auth_res.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  final String token;
  final String? message;
  final String? type;
  LoginSuccess(this.token, {this.message, this.type});
}

final class OtpSentSuccess extends AuthState {
  final String phone;
  final int otp;
  OtpSentSuccess(this.phone, this.otp);
}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class SignUpLoading extends AuthState {}

final class SignUpError extends AuthState {
  final String message;

  SignUpError(this.message);
}

final class SignUpSuccess extends AuthState {
  final SignupResponceModel message;

  SignUpSuccess(this.message);
}

final class VerifyOtpLoading extends AuthState {}

final class VerifyOtpError extends AuthState {
  final String message;

  VerifyOtpError(this.message);
}

final class VerifyLoginOtpSuccess extends AuthState {
  final SignupResponceModel data;

  VerifyLoginOtpSuccess(this.data);
}

final class VerifySSignupOtpSuccess extends AuthState {
  final String success;

  VerifySSignupOtpSuccess(this.success);
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordError extends AuthState {
  final String message;
  ForgotPasswordError(this.message);
}

class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final String message;
  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends AuthState {
  final String message;
  ChangePasswordError(this.message);
}

class ChangePasswordValidationError extends AuthState {
  final String? currentPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;

  ChangePasswordValidationError({
    this.currentPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
  });
}

class LogoutReqLoading extends AuthState {}

class LogoutReqSuccess extends AuthState {
  final String message;
  LogoutReqSuccess(this.message);
}

class LogoutReqError extends AuthState {
  final String message;
  LogoutReqError(this.message);
}

class DeActivateReqLoading extends AuthState {}

class DeActivateReqSuccess extends AuthState {
  final String message;
  DeActivateReqSuccess(this.message);
}

class DeActivateReqError extends AuthState {
  final String message;
  DeActivateReqError(this.message);
}
