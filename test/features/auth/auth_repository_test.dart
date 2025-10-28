import 'package:flutter_test/flutter_test.dart';

import 'package:match_track/features/auth/data/repository/auth_repository.dart';
import 'package:match_track/features/auth/data/repository/auth_repository_impl.dart';
import 'package:match_track/features/auth/data/source/supabase_auth_remote.dart';

class _FakeRemote implements SupabaseAuthRemote {
  _FakeRemote(): super(supabaseUrl: '', anonKey: '');

  bool sent = false;
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (email == 'fail@example.com') throw Exception('fail');
    sent = true;
  }

  @override
  Future<String> signIn(String email, String password) async {
    if (email == 'ok@example.com' && password == 'pass') return 'token';
    throw Exception('invalid credentials');
  }
}

void main() {
  group('AuthRepositoryImpl', () {
    late _FakeRemote remote;
    late AuthRepository repo;

    setUp(() {
      remote = _FakeRemote();
      repo = AuthRepositoryImpl(remote: remote);
    });

    test('sendPasswordResetEmail success', () async {
      await repo.sendPasswordResetEmail('user@example.com');
      expect(remote.sent, isTrue);
    });

    test('sendPasswordResetEmail failure', () async {
      expect(() => repo.sendPasswordResetEmail('fail@example.com'), throwsA(isA<Exception>()));
    });

    test('signIn success returns token', () async {
      final t = await repo.signIn('ok@example.com', 'pass');
      expect(t, 'token');
    });

    test('signIn failure throws', () async {
      expect(() => repo.signIn('nope@example.com', 'x'), throwsA(isA<Exception>()));
    });
  });
}
