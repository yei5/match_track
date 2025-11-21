import 'team_model.dart';
import 'match_event_model.dart';

enum MatchStatus { idle, running, paused, finished }

enum HalfTime { firstHalf, secondHalf, extraTime, finished }

class MatchEvent {
  final String id;
  final String type; // e.g., 'goal', 'foul'
  final String teamId;
  final int timestamp; // seconds from start

  MatchEvent({required this.id, required this.type, required this.teamId, required this.timestamp});
}

class MatchModel {
  final String id;
  final Team homeTeam;
  final Team awayTeam;
  int homeScore;
  int awayScore;
  int elapsedSeconds;
  MatchStatus status;
  HalfTime currentHalf;
  final List<MatchEvent> events;
  final List<MatchEventDetail> detailedEvents;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore = 0,
    this.awayScore = 0,
    this.elapsedSeconds = 0,
    this.status = MatchStatus.idle,
    this.currentHalf = HalfTime.firstHalf,
    List<MatchEvent>? events,
    List<MatchEventDetail>? detailedEvents,
  }) : events = events ?? [],
       detailedEvents = detailedEvents ?? [];
}
