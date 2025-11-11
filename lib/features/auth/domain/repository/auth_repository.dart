import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/domain/model/profile.dart';

abstract class AuthRepository {
  /// Registro con profile (rama de tu amigo)
  Future<void> registerUser(Profile profile, String password);

  /// Registro simple (tu login)
  Future<User?> signUp(String email, String password);

  /// Login
  Future<User?> signIn(String email, String password);

  /// Logout
  Future<void> signOut();

  /// Usuario actual
  Future<User?> currentUser();
}
