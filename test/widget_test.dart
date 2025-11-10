// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_track/features/match/domain/models/team_model.dart';
import 'package:match_track/features/match/domain/models/match_model.dart';

void main() {
  testWidgets('Match models can be created', (WidgetTester tester) async {
    // Test that match models work correctly (from feature/game_control)
    final homeTeam = Team(id: 'home-1', name: 'Icesi');
    final awayTeam = Team(id: 'away-1', name: 'Javeriana');
    final match = MatchModel(
      id: 'match-1',
      homeTeam: homeTeam,
      awayTeam: awayTeam,
    );

    expect(match.id, equals('match-1'));
    expect(match.homeTeam.name, equals('Icesi'));
    expect(match.awayTeam.name, equals('Javeriana'));
    expect(match.homeScore, equals(0));
    expect(match.awayScore, equals(0));
  });

  testWidgets('MaterialApp structure is valid', (WidgetTester tester) async {
    // Simple test to verify Flutter environment works
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('Test'),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
