import '../repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User?> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
