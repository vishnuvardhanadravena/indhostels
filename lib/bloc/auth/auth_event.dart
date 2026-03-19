abstract class AuthEvent {}

enum LoginType { password, otp, signup, login }

final class LoginRequested extends AuthEvent {
  final String phone;
  final String? password;
  final LoginType type;

  LoginRequested({required this.phone, this.password, required this.type});
}

final class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isTermsAccepted;
  final LoginType type;

  SignUpRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.isTermsAccepted,
    required this.type,
  });
}

final class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;
  final LoginType type;

  VerifyOtpRequested({
    required this.phone,
    required this.otp,
    required this.type,
  });
}

final class AuthReset extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class LogoutRequested extends AuthEvent {
  LogoutRequested();
}

class DeActivateRequested extends AuthEvent {
  DeActivateRequested();
}
