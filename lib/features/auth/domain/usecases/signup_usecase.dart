import 'package:match_track/core/domain/model/profile.dart';
import 'package:match_track/features/auth/data/repository/auth_reporitory_impl.dart';
import 'package:match_track/features/auth/domain/repository/auth_repository.dart';

class RegisterUserUsecase {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  Future<void> execute(Profile profile, String password) async {
    await _authRepository.registerUser(profile, password);
  }
}