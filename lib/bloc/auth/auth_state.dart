abstract class AuthState {}


final class AuthInitial extends AuthState {}

/// Loading (for login or signup)
final class AuthLoading extends AuthState {}

/// Login Success
final class LoginSuccess extends AuthState {
  final String token;

  LoginSuccess(this.token);
}

/// Signup Success
final class SignUpSuccess extends AuthState {
  final String message;

  SignUpSuccess(this.message);
}

/// Error State (common for both)
final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}