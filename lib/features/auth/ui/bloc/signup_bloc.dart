//Eventos
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/domain/model/profile.dart';
import 'package:match_track/features/auth/domain/usecases/signup_usecase.dart';

abstract class SignupEvent {}

class SubmmitSignupEvent extends SignupEvent {
  String name;
  String email;
  String password;
  SubmmitSignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

//States
abstract class SignupState {}

class SignupIdleState extends SignupState {}

class SignupErrorState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUserUsecase _registerUserUsecase = RegisterUserUsecase();

  SignupBloc() : super(SignupIdleState()) {
    on<SubmmitSignupEvent>(_registerUser);
  }

  Future<void> _registerUser(
    SubmmitSignupEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoadingState());
    try {
      await _registerUserUsecase.execute(
        Profile(
          id: "",
          name: event.name,
          email: event.email,
          createdAt: DateTime.now(),
        ),
        event.password,
      );
      emit(SignupSuccessState());
    } on Exception {
      emit(SignupErrorState());
    }
  }
}