import 'package:bloc/bloc.dart';
import 'package:indhostels/bloc/auth/auth_event.dart';
import 'package:indhostels/bloc/auth/auth_state.dart';
import 'package:indhostels/data/models/auth_models/auth_req.dart';
import 'package:indhostels/data/repo/authrepo.dart';
import 'package:indhostels/exceptions/api_exceptions.dart';
import 'package:indhostels/services/database/app_secure_storage.dart';
import 'package:indhostels/services/init.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);

    /// SIGN UP
    // on<SignUpRequested>(_onSignUpRequested);

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
await sl<AppSecureStorage>().writeString("token", response.token ?? "");
      emit(LoginSuccess(response.token ?? ""));
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError("Something went wrong"));
    }
  }

  // Future<void> _onSignUpRequested(
  //   SignUpRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());

  //   try {
  //     final response = await repository.signUp(
  //       SignUpRequestModel(
  //         phone: event.phone,
  //         password: event.password,
  //         name: event.name,
  //       ),
  //     );

  //     emit(SignUpSuccess(response.message));
  //   } on ApiException catch (e) {
  //     emit(AuthError(e.message));
  //   } catch (_) {
  //     emit(AuthError("Something went wrong"));
  //   }
  // }
}
