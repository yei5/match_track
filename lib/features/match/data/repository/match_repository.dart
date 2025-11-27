import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';

class MatchRepository {
  // Almacenamiento en memoria (temporal - se pierde al cerrar la app)
  static final Map<String, MatchModel> _matches = {};
  static final Map<String, List<MatchEventDetail>> _matchEvents = {};

  Future<void> saveMatch(MatchModel match) async {
    _matches[match.id] = match;
  }

  Future<MatchModel?> getMatch(String id) async {
    return _matches[id];
  }

  Future<List<MatchModel>> listMatches() async {
    return _matches.values.toList();
  }

  Future<List<MatchModel>> getScheduledMatches() async {
    return _matches.values
        .where((match) => match.status == MatchStatus.scheduled)
        .toList()
      ..sort((a, b) => (a.scheduledDate ?? DateTime.now())
          .compareTo(b.scheduledDate ?? DateTime.now()));
  }

  Future<List<MatchModel>> getFinishedMatches() async {
    return _matches.values
        .where((match) => match.status == MatchStatus.finished)
        .toList()
      ..sort((a, b) => (b.scheduledDate ?? DateTime.now())
          .compareTo(a.scheduledDate ?? DateTime.now()));
  }

  Future<void> deleteMatch(String id) async {
    _matches.remove(id);
    _matchEvents.remove(id);
  }
  
  // Métodos para eventos
  Future<void> saveEvent(MatchEventDetail event, String matchId) async {
    if (!_matchEvents.containsKey(matchId)) {
      _matchEvents[matchId] = [];
    }
    _matchEvents[matchId]!.add(event);
    
    // Actualizar el partido con el evento
    final match = _matches[matchId];
    if (match != null) {
      match.detailedEvents.add(event);
    }
  }

  Future<void> deleteEvent(String eventId, String matchId) async {
    _matchEvents[matchId]?.removeWhere((e) => e.id == eventId);
    
    // Actualizar el partido
    final match = _matches[matchId];
    if (match != null) {
      match.detailedEvents.removeWhere((e) => e.id == eventId);
    }
  }

  Future<List<MatchEventDetail>> getMatchEvents(String matchId) async {
    return _matchEvents[matchId] ?? [];
  }
}
