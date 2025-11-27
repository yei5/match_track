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
  // Estadísticas simplificadas: solo eventos usados
  final int homeGoals;
  final int awayGoals;
  final int homeYellowCards;
  final int awayYellowCards;
  final int homeRedCards;
  final int awayRedCards;
  final int homeFouls;
  final int awayFouls;
  final int homeOffsides;
  final int awayOffsides;
  final int homeInjuries;
  final int awayInjuries;

  GameStatistics({
    required this.homeGoals,
    required this.awayGoals,
    required this.homeYellowCards,
    required this.awayYellowCards,
    required this.homeRedCards,
    required this.awayRedCards,
    required this.homeFouls,
    required this.awayFouls,
    required this.homeOffsides,
    required this.awayOffsides,
    required this.homeInjuries,
    required this.awayInjuries,
  });

  factory GameStatistics.empty() {
    return GameStatistics(
      homeGoals: 0,
      awayGoals: 0,
      homeYellowCards: 0,
      awayYellowCards: 0,
      homeRedCards: 0,
      awayRedCards: 0,
      homeFouls: 0,
      awayFouls: 0,
      homeOffsides: 0,
      awayOffsides: 0,
      homeInjuries: 0,
      awayInjuries: 0,
    );
  }
}
