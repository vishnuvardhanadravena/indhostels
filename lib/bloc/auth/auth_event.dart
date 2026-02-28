abstract class AuthEvent {}

/// Login Event
final class LoginRequested extends AuthEvent {
  final String phone;
  final String password;

  LoginRequested({required this.phone, required this.password});
}

/// Signup Event
final class SignUpRequested extends AuthEvent {
  final String phone;
  final String password;
  final String name;

  SignUpRequested({
    required this.phone,
    required this.password,
    required this.name,
  });
}

/// Optional: Reset State (useful after success)
final class AuthReset extends AuthEvent {}
