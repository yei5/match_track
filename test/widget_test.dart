// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:match_track/main.dart';

import 'package:match_track/features/auth/data/repository/auth_repository.dart';
import 'package:match_track/features/auth/ui/bloc/auth_controller.dart';

class _FakeRepo implements AuthRepository {
  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<String> signIn(String email, String password) async => '';
}

void main() {
  testWidgets('App shows welcome and counter increments', (WidgetTester tester) async {
    final controller = AuthController(repository: _FakeRepo());

    // Build our app and trigger a frame with a fake auth controller.
    await tester.pumpWidget(MyApp(authController: controller));

    // Verify that welcome text exists.
    expect(find.text('Bienvenido'), findsOneWidget);

    // Verify that counter starts at 0 (label text contains the number)
    expect(find.textContaining('Contador: 0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining('Contador: 1'), findsOneWidget);
  });
}
