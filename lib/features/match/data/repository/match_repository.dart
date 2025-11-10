import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';

abstract class MatchRepository {
  Future<void> saveMatch(MatchModel match);
  Future<MatchModel?> getMatch(String id);
  Future<List<MatchModel>> listMatches();
  Future<void> deleteMatch(String id);
  
  // Métodos para eventos
  Future<void> saveEvent(MatchEventDetail event, String matchId);
  Future<void> deleteEvent(String eventId, String matchId);
  Future<List<MatchEventDetail>> getMatchEvents(String matchId);
}
