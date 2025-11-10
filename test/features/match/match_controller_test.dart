import 'package:flutter_test/flutter_test.dart';
import 'package:match_track/features/match/domain/models/team_model.dart';
import 'package:match_track/features/match/domain/models/match_model.dart';
import 'package:match_track/features/match/ui/bloc/match_controller.dart';

void main() {
  group('MatchController', () {
    late Team homeTeam;
    late Team awayTeam;
    late MatchModel match;

    setUp(() {
      homeTeam = Team(id: 'home', name: 'Icesi');
      awayTeam = Team(id: 'away', name: 'Javeriana');
      match = MatchModel(id: 'test-match', homeTeam: homeTeam, awayTeam: awayTeam);
    });

    test('initial state is idle with 0 elapsed seconds', () {
      final controller = MatchController(match: match);
      expect(controller.elapsedSeconds, equals(0));
      expect(controller.isRunning, isFalse);
      expect(controller.formattedTime, equals('00:00'));
    });

    test('start() changes status to running', () {
      final controller = MatchController(match: match);
      controller.start();
      expect(controller.isRunning, isTrue);
      expect(match.status, equals(MatchStatus.running));
      controller.dispose();
    });

    test('pause() stops the timer and changes status to paused', () {
      final controller = MatchController(match: match);
      controller.start();
      controller.pause();
      expect(controller.isRunning, isFalse);
      expect(match.status, equals(MatchStatus.paused));
      controller.dispose();
    });

    test('addGoal() increments correct team score', () {
      final controller = MatchController(match: match);
      
      controller.addGoal(homeTeam.id);
      expect(match.homeScore, equals(1));
      expect(match.awayScore, equals(0));
      expect(match.events.length, equals(1));
      expect(match.events.first.type, equals('goal'));
      
      controller.addGoal(awayTeam.id);
      expect(match.homeScore, equals(1));
      expect(match.awayScore, equals(1));
      expect(match.events.length, equals(2));
      
      controller.dispose();
    });

    test('addFoul() registers foul event', () {
      final controller = MatchController(match: match);
      
      controller.addFoul(homeTeam.id);
      expect(match.events.length, equals(1));
      expect(match.events.first.type, equals('foul'));
      expect(match.events.first.teamId, equals(homeTeam.id));
      
      controller.dispose();
    });

    test('stop() with reset clears scores and elapsed time', () {
      final controller = MatchController(match: match);
      
      controller.start();
      controller.addGoal(homeTeam.id);
      match.elapsedSeconds = 120; // simulate 2 minutes
      
      controller.stop(reset: true);
      
      expect(match.status, equals(MatchStatus.finished));
      expect(match.homeScore, equals(0));
      expect(match.awayScore, equals(0));
      expect(match.elapsedSeconds, equals(0));
      expect(match.events.isEmpty, isTrue);
      
      controller.dispose();
    });

    test('formattedTime returns correct MM:SS format', () {
      final controller = MatchController(match: match);
      
      match.elapsedSeconds = 0;
      expect(controller.formattedTime, equals('00:00'));
      
      match.elapsedSeconds = 65;
      expect(controller.formattedTime, equals('01:05'));
      
      match.elapsedSeconds = 3661;
      expect(controller.formattedTime, equals('61:01'));
      
      controller.dispose();
    });
  });
}
