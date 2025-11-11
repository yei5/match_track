import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDataSource {
  Future<String?> signUp(String email, String password);
  Future<User?> getCurrentUser();
}

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<String?> signUp(String email, String password) async {
    AuthResponse response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
    return response.user?.id;
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user;
  }
}