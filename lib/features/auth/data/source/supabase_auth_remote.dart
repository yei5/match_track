import 'dart:convert';

import 'package:http/http.dart' as http;

/// Lightweight Supabase auth remote helper using REST endpoints.
class SupabaseAuthRemote {
  final String supabaseUrl;
  final String anonKey;

  SupabaseAuthRemote({required this.supabaseUrl, required this.anonKey});

  /// Send reset password email using Supabase auth recover endpoint.
  Future<void> sendPasswordResetEmail(String email) async {
    final uri = Uri.parse('$supabaseUrl/auth/v1/recover');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'apikey': anonKey,
        'Authorization': 'Bearer '
            '$anonKey',
      },
      body: jsonEncode({'email': email}),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return;
    }

    throw Exception('Failed to send reset email: ${resp.statusCode} ${resp.body}');
  }

  /// Sign in using Supabase REST token endpoint. Returns access token on success.
  Future<String> signIn(String email, String password) async {
    final uri = Uri.parse('$supabaseUrl/auth/v1/token?grant_type=password');

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'apikey': anonKey,
        'Authorization': 'Bearer '
            '$anonKey',
      },
      body: 'email=' + Uri.encodeQueryComponent(email) + '&password=' + Uri.encodeQueryComponent(password),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final map = jsonDecode(resp.body) as Map<String, dynamic>;
      // Supabase returns access_token in the response when successful
      return map['access_token'] as String? ?? '';
    }

    throw Exception('Failed to sign in: ${resp.statusCode} ${resp.body}');
  }
}
