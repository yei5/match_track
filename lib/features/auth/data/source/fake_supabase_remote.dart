import 'dart:async';

import 'supabase_auth_remote.dart';

/// A lightweight fake remote used for demos when no SUPABASE_* env vars are provided.
class FakeSupabaseRemote extends SupabaseAuthRemote {
  FakeSupabaseRemote() : super(supabaseUrl: '', anonKey: '');

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.contains('fail')) {
      throw Exception('Simulated failure');
    }
    return;
  }

  @override
  Future<String> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (email == 'ok@example.com' && password == 'pass') return 'token-demo';
    throw Exception('Invalid credentials (fake)');
  }
}
