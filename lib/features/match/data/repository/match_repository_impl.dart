import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import 'match_repository.dart';

/// Simple in-memory implementation for prototyping.
class MatchRepositoryImpl implements MatchRepository {
  final Map<String, MatchModel> _store = {};
  final Map<String, List<MatchEventDetail>> _eventsStore = {};

  @override
  Future<void> saveMatch(MatchModel match) async {
    _store[match.id] = match;
  }

  @override
  Future<MatchModel?> getMatch(String id) async {
    return _store[id];
  }

  @override
  Future<List<MatchModel>> listMatches() async {
    return _store.values.toList(growable: false);
  }

  @override
  Future<void> deleteMatch(String id) async {
    _store.remove(id);
    _eventsStore.remove(id);
  }

  @override
  Future<void> saveEvent(MatchEventDetail event, String matchId) async {
    if (!_eventsStore.containsKey(matchId)) {
      _eventsStore[matchId] = [];
    }
    // Eliminar evento existente si hay uno con el mismo ID
    _eventsStore[matchId]!.removeWhere((e) => e.id == event.id);
    // Agregar el nuevo evento
    _eventsStore[matchId]!.add(event);
  }

  @override
  Future<void> deleteEvent(String eventId, String matchId) async {
    if (_eventsStore.containsKey(matchId)) {
      _eventsStore[matchId]!.removeWhere((e) => e.id == eventId);
    }
  }

  @override
  Future<List<MatchEventDetail>> getMatchEvents(String matchId) async {
    return _eventsStore[matchId] ?? [];
  }
}
