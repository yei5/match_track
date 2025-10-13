import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repository/auth_repository.dart';
import '../../../../core/supabase_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client = supabaseClient();

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      return res.user;
    } catch (e) {
      throw Exception('Error al registrarse: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  User? currentUser() {
    return _client.auth.currentUser;
  }
}
