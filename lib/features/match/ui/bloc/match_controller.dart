import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../../data/repository/match_repository.dart';
import '../../../games/domain/models/game_model.dart';

class MatchController extends ChangeNotifier {
  final MatchModel match;
  final MatchRepository? repository;
  Timer? _ticker;
  GameStatistics statistics = GameStatistics.empty();

  MatchController({
    required this.match,
    this.repository,
  }) {
    _initializeStatistics();
  }

  void _initializeStatistics() {
    statistics = GameStatistics.empty();
  }

  int get elapsedSeconds => match.elapsedSeconds;
  int get currentMinute => (match.elapsedSeconds / 60).floor();
  
  String get formattedTime {
    final s = match.elapsedSeconds;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  bool get isRunning => match.status == MatchStatus.running;
  
  // Obtener eventos ordenados por tiempo (más reciente primero)
  List<MatchEventDetail> get sortedEvents {
    final events = List<MatchEventDetail>.from(match.detailedEvents);
    events.sort((a, b) => b.minute.compareTo(a.minute));
    return events;
  }

  void start() {
    if (isRunning) return;
    match.status = MatchStatus.running;
    _ticker?.cancel();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) {
      match.elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (!isRunning) return;
    _ticker?.cancel();
    match.status = MatchStatus.paused;
    notifyListeners();
  }

  Future<void> stop({bool reset = false}) async {
    _ticker?.cancel();
    match.status = MatchStatus.finished;
    if (reset) {
      match.elapsedSeconds = 0;
      match.homeScore = 0;
      match.awayScore = 0;
      match.events.clear();
    }
    
    // Guardar el partido finalizado
    if (repository != null) {
      try {
        await repository!.saveMatch(match);
      } catch (e) {
        debugPrint('Error guardando partido finalizado: $e');
      }
    }
    
    notifyListeners();
  }

  void addGoal(String teamId) {
    if (teamId == match.homeTeam.id) {
      match.homeScore++;
    } else if (teamId == match.awayTeam.id) {
      match.awayScore++;
    }
    final ev = MatchEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'goal',
      teamId: teamId,
      timestamp: match.elapsedSeconds,
    );
    match.events.add(ev);
    notifyListeners();
  }

  void addFoul(String teamId) {
    final ev = MatchEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'foul',
      teamId: teamId,
      timestamp: match.elapsedSeconds,
    );
    match.events.add(ev);
    notifyListeners();
  }

  // Nuevos métodos para eventos detallados
  
  Future<void> addDetailedEvent(MatchEventDetail event) async {
    match.detailedEvents.add(event);
    
    final isHomeTeam = event.teamId == match.homeTeam.id;
    
    // Actualizar estadísticas según el tipo de evento
    switch (event.type) {
      case EventType.goal:
        if (isHomeTeam) {
          match.homeScore++;
          statistics = GameStatistics(
            homeGoals: statistics.homeGoals + 1,
            awayGoals: statistics.awayGoals,
            homeYellowCards: statistics.homeYellowCards,
            awayYellowCards: statistics.awayYellowCards,
            homeRedCards: statistics.homeRedCards,
            awayRedCards: statistics.awayRedCards,
            homeFouls: statistics.homeFouls,
            awayFouls: statistics.awayFouls,
            homeOffsides: statistics.homeOffsides,
            awayOffsides: statistics.awayOffsides,
            homeInjuries: statistics.homeInjuries,
            awayInjuries: statistics.awayInjuries,
          );
        } else {
          match.awayScore++;
          statistics = GameStatistics(
            homeGoals: statistics.homeGoals,
            awayGoals: statistics.awayGoals + 1,
            homeYellowCards: statistics.homeYellowCards,
            awayYellowCards: statistics.awayYellowCards,
            homeRedCards: statistics.homeRedCards,
            awayRedCards: statistics.awayRedCards,
            homeFouls: statistics.homeFouls,
            awayFouls: statistics.awayFouls,
            homeOffsides: statistics.homeOffsides,
            awayOffsides: statistics.awayOffsides,
            homeInjuries: statistics.homeInjuries,
            awayInjuries: statistics.awayInjuries,
          );
        }
        break;
        
      case EventType.yellowCard:
        statistics = GameStatistics(
          homeGoals: statistics.homeGoals,
          awayGoals: statistics.awayGoals,
          homeYellowCards: isHomeTeam ? statistics.homeYellowCards + 1 : statistics.homeYellowCards,
          awayYellowCards: isHomeTeam ? statistics.awayYellowCards : statistics.awayYellowCards + 1,
          homeRedCards: statistics.homeRedCards,
          awayRedCards: statistics.awayRedCards,
          homeFouls: statistics.homeFouls,
          awayFouls: statistics.awayFouls,
          homeOffsides: statistics.homeOffsides,
          awayOffsides: statistics.awayOffsides,
          homeInjuries: statistics.homeInjuries,
          awayInjuries: statistics.awayInjuries,
        );
        break;
        
      case EventType.redCard:
        statistics = GameStatistics(
          homeGoals: statistics.homeGoals,
          awayGoals: statistics.awayGoals,
          homeYellowCards: statistics.homeYellowCards,
          awayYellowCards: statistics.awayYellowCards,
          homeRedCards: isHomeTeam ? statistics.homeRedCards + 1 : statistics.homeRedCards,
          awayRedCards: isHomeTeam ? statistics.awayRedCards : statistics.awayRedCards + 1,
          homeFouls: statistics.homeFouls,
          awayFouls: statistics.awayFouls,
          homeOffsides: statistics.homeOffsides,
          awayOffsides: statistics.awayOffsides,
          homeInjuries: statistics.homeInjuries,
          awayInjuries: statistics.awayInjuries,
        );
        break;
        
      case EventType.foul:
        statistics = GameStatistics(
          homeGoals: statistics.homeGoals,
          awayGoals: statistics.awayGoals,
          homeYellowCards: statistics.homeYellowCards,
          awayYellowCards: statistics.awayYellowCards,
          homeRedCards: statistics.homeRedCards,
          awayRedCards: statistics.awayRedCards,
          homeFouls: isHomeTeam ? statistics.homeFouls + 1 : statistics.homeFouls,
          awayFouls: isHomeTeam ? statistics.awayFouls : statistics.awayFouls + 1,
          homeOffsides: statistics.homeOffsides,
          awayOffsides: statistics.awayOffsides,
          homeInjuries: statistics.homeInjuries,
          awayInjuries: statistics.awayInjuries,
        );
        break;
        
      case EventType.offside:
        statistics = GameStatistics(
          homeGoals: statistics.homeGoals,
          awayGoals: statistics.awayGoals,
          homeYellowCards: statistics.homeYellowCards,
          awayYellowCards: statistics.awayYellowCards,
          homeRedCards: statistics.homeRedCards,
          awayRedCards: statistics.awayRedCards,
          homeFouls: statistics.homeFouls,
          awayFouls: statistics.awayFouls,
          homeOffsides: isHomeTeam ? statistics.homeOffsides + 1 : statistics.homeOffsides,
          awayOffsides: isHomeTeam ? statistics.awayOffsides : statistics.awayOffsides + 1,
          homeInjuries: statistics.homeInjuries,
          awayInjuries: statistics.awayInjuries,
        );
        break;
        
      case EventType.injury:
        statistics = GameStatistics(
          homeGoals: statistics.homeGoals,
          awayGoals: statistics.awayGoals,
          homeYellowCards: statistics.homeYellowCards,
          awayYellowCards: statistics.awayYellowCards,
          homeRedCards: statistics.homeRedCards,
          awayRedCards: statistics.awayRedCards,
          homeFouls: statistics.homeFouls,
          awayFouls: statistics.awayFouls,
          homeOffsides: statistics.homeOffsides,
          awayOffsides: statistics.awayOffsides,
          homeInjuries: isHomeTeam ? statistics.homeInjuries + 1 : statistics.homeInjuries,
          awayInjuries: isHomeTeam ? statistics.awayInjuries : statistics.awayInjuries + 1,
        );
        break;
        
      default:
        // Otros eventos no afectan las estadísticas
        break;
    }
    
    // Guardar en repositorio si está disponible
    if (repository != null) {
      try {
        await repository!.saveEvent(event, match.id);
        await repository!.saveMatch(match);
      } catch (e) {
        debugPrint('Error guardando evento: $e');
      }
    }
    
    notifyListeners();
  }
  
  Future<void> removeEvent(String eventId) async {
    final event = match.detailedEvents.firstWhere((e) => e.id == eventId);
    
    // Si era un gol, restar del marcador
    if (event.type == EventType.goal) {
      if (event.teamId == match.homeTeam.id) {
        match.homeScore--;
      } else if (event.teamId == match.awayTeam.id) {
        match.awayScore--;
      }
    }
    
    match.detailedEvents.removeWhere((e) => e.id == eventId);
    
    // Eliminar del repositorio si está disponible
    if (repository != null) {
      try {
        await repository!.deleteEvent(eventId, match.id);
        await repository!.saveMatch(match);
      } catch (e) {
        debugPrint('Error eliminando evento: $e');
      }
    }
    
    notifyListeners();
  }
  
  void endHalfTime() {
    if (match.currentHalf == HalfTime.firstHalf) {
      // Finalizar el primer tiempo y pausar el cronómetro
      pause();
      match.currentHalf = HalfTime.halftime;
      final event = MatchEventDetail(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: EventType.halfTime,
        minute: currentMinute,
        teamId: match.homeTeam.id, // No importa el equipo para este evento
        description: 'Entretiempo',
      );
      match.detailedEvents.add(event);
    } else if (match.currentHalf == HalfTime.halftime) {
      // Iniciar el segundo tiempo y reanudar el cronómetro
      match.currentHalf = HalfTime.secondHalf;
      start();
    } else if (match.currentHalf == HalfTime.secondHalf) {
      // Finalizar el partido
      match.currentHalf = HalfTime.finished;
      final event = MatchEventDetail(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: EventType.fullTime,
        minute: currentMinute,
        teamId: match.homeTeam.id,
        description: 'Fin del partido',
      );
      match.detailedEvents.add(event);
      stop();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
