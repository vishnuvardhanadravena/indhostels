import 'package:bloc/bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/data/models/auth_models/auth_req.dart';
import 'package:indhostels/data/repo/authrepo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/services/init.dart';
import 'package:indhostels/utils/helpers/app_toast.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthReset>((event, emit) => emit(AuthInitial()));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await repository.login(
        LoginRequestModel(phone: event.phone, password: event.password),
      );
      if (event.type == LoginType.otp) {
        AppToast.success(
          "OTP sent to ${event.phone}",
          position: ToastPosition.bottom,
        );
        emit(OtpSentSuccess(event.phone));
        return;
      }
      final token = response.token;
      if (token.isNotEmpty) {
        await sl<AppSecureStorage>().writeString("token", token);
        await sl<AppSecureStorage>().writeBool("login", true);
        emit(LoginSuccess(token));
      } else {
        emit(AuthError("Invalid token received"));
      }
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError("Something went wrong"));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(SignUpLoading());

    try {
      final response = await repository.signup(
        SignUpRequestModel(
          fullName: event.fullName,
          email: event.email,
          phone: event.phone,
          password: event.password,
          confirmPassword: event.confirmPassword,
          isTermsAccepted: event.isTermsAccepted,
        ),
      );
      if (response.success == true) {
        AppToast.success(
          "OTP sent to ${event.phone}",
          position: ToastPosition.bottom,
        );
        emit(OtpSentSuccess(event.phone));
        return;
      } else {
        emit(SignUpError(response.message ?? "Signup failed"));
      }
    } on ApiException catch (e) {
      emit(SignUpError(e.message));
    } catch (_) {
      emit(SignUpError("Something went wrong"));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final data = await repository.verifyOtp(event.phone, event.otp);

      final success = data['success'] == true;

      if (!success) {
        emit(AuthError(data['message'] ?? "Invalid OTP"));
        return;
      }

      if (event.type == LoginType.signup) {
        emit(VerifySSignupOtpSuccess(event.phone));
        return;
      }

      if (event.type == LoginType.login) {
        final token = data['JWTtoken'];

        if (token != null) {
          await sl<AppSecureStorage>().writeString("token", token);
          await sl<AppSecureStorage>().writeBool("login", true);

          emit(LoginSuccess(token));
        } else {
          emit(AuthError("Token missing"));
        }
      }
    } on ApiException catch (e) {
      emit(VerifyOtpError(e.message));
    } catch (_) {
      emit(VerifyOtpError("Something went wrong"));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    final email = event.email.trim();

    if (email.isEmpty) {
      emit(ForgotPasswordError("Email is required"));
      return;
    }

    final isValidEmail = RegExp(
      r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);

    if (!isValidEmail) {
      emit(ForgotPasswordError("Enter valid email"));
      return;
    }

    try {
      final response = await repository.forgotPassword(email);
      if (response.success == true) {
        emit(ForgotPasswordSuccess(response.message ?? "Reset link sent"));
      } else {
        emit(ForgotPasswordError(response.message ?? "Request failed"));
      }
    } on ApiException catch (e) {
      emit(ForgotPasswordError(e.message));
    } catch (_) {
      emit(ForgotPasswordError("Something went wrong"));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentErr = _validateCurrent(event.currentPassword);
    final newErr = _validateNew(event.newPassword);
    final confirmErr = _validateConfirm(
      event.newPassword,
      event.confirmPassword,
    );

    if (currentErr != null || newErr != null || confirmErr != null) {
      emit(
        ChangePasswordValidationError(
          currentPasswordError: currentErr,
          newPasswordError: newErr,
          confirmPasswordError: confirmErr,
        ),
      );
      return;
    }

    emit(ChangePasswordLoading());

    try {
      final response = await repository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      if (response.success == true) {
        emit(
          ChangePasswordSuccess(
            response.message ?? "Password updated successfully",
          ),
        );
      } else {
        emit(
          ChangePasswordError(response.message ?? "Failed to update password"),
        );
      }
    } on ApiException catch (e) {
      emit(ChangePasswordError(e.message));
    } catch (_) {
      emit(ChangePasswordError("Something went wrong"));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutReqLoading());

    try {
      final response = await repository.logout();
      if (response["success"] == true) {
        emit(LogoutReqSuccess(response["message"]));
      }
    } on ApiException catch (e) {
      emit(LogoutReqError(e.message));
    } catch (e, s) {
      print(e);
      print(s);
      emit(LogoutReqError(e.toString()));
    }
  }

  String? _validateCurrent(String value) {
    if (value.trim().isEmpty) return "Current password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _validateNew(String value) {
    if (value.trim().isEmpty) return "New password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain at least one uppercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain at least one number";
    }
    return null;
  }

  String? _validateConfirm(String newPassword, String confirm) {
    if (confirm.trim().isEmpty) return "Please confirm your new password";
    if (confirm != newPassword) return "Passwords do not match";
    return null;
  }
}
