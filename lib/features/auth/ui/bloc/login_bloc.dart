import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/domain/repository/auth_repository.dart';
import 'package:match_track/features/auth/data/repository/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

enum LoginErrorField { email, password }

class LoginFailure extends LoginState {
  final String message;
  final LoginErrorField field;
  LoginFailure(this.message, {required this.field});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUserUsecase _signInUserUsecase = SignInUserUsecase();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLogin);
  }

  Future<void> _onLogin(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _signInUserUsecase.execute(
        event.email,
        event.password,
      );

      if (user != null) {
        emit(LoginSuccess());
      } else {
        emit(
          LoginFailure(
            "Contraseña incorrecta",
            field: LoginErrorField.password,
          ),
        );
      }
    } on AuthApiException catch (e) {
      String message;
      LoginErrorField field;

      if (e.code == "invalid_login_credentials" ||
          e.message.toLowerCase().contains("invalid login credentials")) {
        message = "Correo o contraseña incorrectos";
        field = LoginErrorField.password;
      } else if (e.code == "invalid_email") {
        message = "Correo electrónico no válido";
        field = LoginErrorField.email;
      } else if (e.code == "user_disabled") {
        message = "Este usuario ha sido deshabilitado";
        field = LoginErrorField.email;
      } else {
        message = "Ocurrió un error al iniciar sesión";
        field = LoginErrorField.password;
      }

      emit(LoginFailure(message, field: field));
    } catch (_) {
      emit(
        LoginFailure(
          "Ocurrió un error inesperado. Intenta de nuevo",
          field: LoginErrorField.password,
        ),
      );
    }
  }
}

class SignInUserUsecase {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  Future<User?> execute(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }
}
