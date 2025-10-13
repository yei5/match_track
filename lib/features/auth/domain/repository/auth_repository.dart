import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  /// Devuelve el User en caso de éxito, lanza Exception en caso de error
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  User? currentUser();
}
