import 'package:match_track/core/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Interfaz del repositorio de autenticación
abstract class AuthRepository {
  Future<void> registerUser(Profile profile, String password);
  Future<String?> signUp(String email, String password);
}

/// Implementación que usa Supabase
class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<void> registerUser(Profile profile, String password) async {
    // TODO: conectar con Supabase cuando se defina el modelo Profile
  }

  @override
  Future<String?> signUp(String email, String password) async {
    AuthResponse response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
    return response.user?.id;
  }
}
