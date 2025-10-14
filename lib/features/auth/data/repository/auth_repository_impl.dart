import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/domain/model/profile.dart';
import 'package:match_track/features/auth/domain/repository/auth_repository.dart';
import 'package:match_track/features/auth/data/source/auth_datasource.dart';
import 'package:match_track/features/profile/data/source/profile_datasource.dart';
import '../../../../core/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  final SupabaseClient _client = supabaseClient();

  final AuthDataSource _authDataSource = AuthDataSourceImpl();
  final ProfileDataSource _profileDataSource = ProfileDataSourceImpl();

  @override
  Future<void> registerUser(Profile profile, String password) async {
    String? userId = await _authDataSource.signUp(profile.email, password);
    if (userId != null) {
      profile.id = userId;
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

  // Login
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

  // Logout
  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Usuario actual
  @override
  User? currentUser() {
    return _client.auth.currentUser;
  }
}
