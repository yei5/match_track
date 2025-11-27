import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';

class MatchRepository {
  // Almacenamiento en memoria (puede ser reemplazado por Supabase)
  static final Map<String, MatchModel> _matches = {};
  static final Map<String, List<MatchEventDetail>> _matchEvents = {};

  Future<void> saveMatch(MatchModel match) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _matches[match.id] = match;
  }

  Future<MatchModel?> getMatch(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _matches[id];
  }

  Future<List<MatchModel>> listMatches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _matches.values.toList();
  }

  Future<List<MatchModel>> getScheduledMatches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _matches.values
        .where((match) => match.status == MatchStatus.scheduled)
        .toList()
      ..sort((a, b) {
        final dateA = a.scheduledDate ?? DateTime.now();
        final dateB = b.scheduledDate ?? DateTime.now();
        return dateA.compareTo(dateB);
      });
  }

  Future<List<MatchModel>> getFinishedMatches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _matches.values
        .where((match) => match.status == MatchStatus.finished)
        .toList()
      ..sort((a, b) {
        final dateA = a.scheduledDate ?? DateTime.now();
        final dateB = b.scheduledDate ?? DateTime.now();
        return dateB.compareTo(dateA); // Más reciente primero
      });
  }

  Future<void> deleteMatch(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _matches.remove(id);
    _matchEvents.remove(id);
  }
  
  // Métodos para eventos
  Future<void> saveEvent(MatchEventDetail event, String matchId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_matchEvents[matchId] == null) {
      _matchEvents[matchId] = [];
    }
    _matchEvents[matchId]!.add(event);
  }

  Future<void> deleteEvent(String eventId, String matchId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _matchEvents[matchId]?.removeWhere((e) => e.id == eventId);
  }

  Future<List<MatchEventDetail>> getMatchEvents(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _matchEvents[matchId] ?? [];
  }
}
