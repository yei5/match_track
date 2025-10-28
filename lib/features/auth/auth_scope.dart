import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/source/supabase_auth_remote.dart';
import 'data/repository/auth_repository_impl.dart';
import 'ui/bloc/auth_controller.dart';

/// Helper to create an [AuthController] wired with Supabase remote using env vars.
AuthController createAuthControllerFromEnv() {
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnon = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  final remote = SupabaseAuthRemote(supabaseUrl: supabaseUrl, anonKey: supabaseAnon);
  final repo = AuthRepositoryImpl(remote: remote);
  return AuthController(repository: repo);
}
