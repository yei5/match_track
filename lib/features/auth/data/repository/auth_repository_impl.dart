import '../source/supabase_auth_remote.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthRemote remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<void> sendPasswordResetEmail(String email) => remote.sendPasswordResetEmail(email);

  @override
  Future<String> signIn(String email, String password) => remote.signIn(email, password);
}
