import '../../../match/domain/models/match_model.dart';
import '../../../match/domain/models/match_event_model.dart';
import '../../../match/domain/models/team_model.dart';

class GameModel {
  final String id;
  final String tournamentId;
  final String tournamentName;
  final Team homeTeam;
  final Team awayTeam;
  final int homeScore;
  final int awayScore;
  final GameStatus status;
  final int? currentMinute;
  final DateTime scheduledDate;
  final List<MatchEventDetail> events;
  final GameStatistics? statistics;

  GameModel({
    required this.id,
    required this.tournamentId,
    required this.tournamentName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore = 0,
    this.awayScore = 0,
    required this.status,
    this.currentMinute,
    required this.scheduledDate,
    List<MatchEventDetail>? events,
    this.statistics,
  }) : events = events ?? [];

  bool get isLive => status == GameStatus.live;
  bool get isFinished => status == GameStatus.finished;
  bool get isScheduled => status == GameStatus.scheduled;
}

enum GameStatus {
  scheduled,
  live,
  finished,
}

class GameStatistics {
  final int homePossession;
  final int awayPossession;
  final double homeExpectedGoals;
  final double awayExpectedGoals;
  final int homeTotalShots;
  final int awayTotalShots;
  final int homeShotsOnTarget;
  final int awayShotsOnTarget;
  final int homeBigChances;
  final int awayBigChances;
  final int homeCorners;
  final int awayCorners;
  final int homeOffsides;
  final int awayOffsides;
  final int homeCompletedPasses;
  final int awayCompletedPasses;
  final int homeRedCards;
  final int awayRedCards;
  final int homeAttacks;
  final int awayAttacks;

  GameStatistics({
    required this.homePossession,
    required this.awayPossession,
    required this.homeExpectedGoals,
    required this.awayExpectedGoals,
    required this.homeTotalShots,
    required this.awayTotalShots,
    required this.homeShotsOnTarget,
    required this.awayShotsOnTarget,
    required this.homeBigChances,
    required this.awayBigChances,
    required this.homeCorners,
    required this.awayCorners,
    required this.homeOffsides,
    required this.awayOffsides,
    required this.homeCompletedPasses,
    required this.awayCompletedPasses,
    required this.homeRedCards,
    required this.awayRedCards,
    required this.homeAttacks,
    required this.awayAttacks,
  });

  factory GameStatistics.empty() {
    return GameStatistics(
      homePossession: 50,
      awayPossession: 50,
      homeExpectedGoals: 0.0,
      awayExpectedGoals: 0.0,
      homeTotalShots: 0,
      awayTotalShots: 0,
      homeShotsOnTarget: 0,
      awayShotsOnTarget: 0,
      homeBigChances: 0,
      awayBigChances: 0,
      homeCorners: 0,
      awayCorners: 0,
      homeOffsides: 0,
      awayOffsides: 0,
      homeCompletedPasses: 0,
      awayCompletedPasses: 0,
      homeRedCards: 0,
      awayRedCards: 0,
      homeAttacks: 0,
      awayAttacks: 0,
    );
  }
}
