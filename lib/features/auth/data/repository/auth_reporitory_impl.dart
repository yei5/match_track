import 'package:match_track/core/domain/model/profile.dart';
import 'package:match_track/features/auth/domain/repository/auth_repository.dart';
import 'package:match_track/features/auth/data/source/auth_datasource.dart';
import 'package:match_track/features/profile/data/source/profile_datasource.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource = AuthDataSourceImpl();
  final ProfileDataSource _profileDataSource = ProfileDataSourceImpl();

  @override
  Future<void> registerUser(Profile profile, String password) async {
    //1. Registrarnos en el servico de Auth
    String? userId = await _authDataSource.signUp(profile.email, password);
    //2. Crear el Profile
    if (userId != null) {
      profile.id = userId;
      //_profileDataSource.createProfile(profile);
    }
  }
}