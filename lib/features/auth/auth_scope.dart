import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/source/supabase_auth_remote.dart';
import 'data/repository/auth_repository_impl.dart';
import 'ui/bloc/auth_controller.dart';

/// Helper to create an [AuthController] wired with Supabase remote using env vars.
AuthController createAuthControllerFromEnv() {
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnon = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  // If dotenv didn't provide values (common on web builds), fall back to
  // compile-time defines passed via `--dart-define=KEY=VALUE`.
  final effectiveUrl = supabaseUrl.isNotEmpty ? supabaseUrl : const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  final effectiveAnon = supabaseAnon.isNotEmpty ? supabaseAnon : const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  final remote = SupabaseAuthRemote(supabaseUrl: effectiveUrl, anonKey: effectiveAnon);
  final repo = AuthRepositoryImpl(remote: remote);
  return AuthController(repository: repo);
}
