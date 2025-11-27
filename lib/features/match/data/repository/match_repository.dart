import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../source/match_remote_data_source.dart';

class MatchRepository {
  late final MatchRemoteDataSource _remoteDataSource;

  MatchRepository() {
    _remoteDataSource = MatchRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    );
  }

  Future<void> saveMatch(MatchModel match) async {
    await _remoteDataSource.saveMatch(match);
  }

  Future<MatchModel?> getMatch(String id) async {
    return await _remoteDataSource.getMatch(id);
  }

  Future<List<MatchModel>> listMatches() async {
    return await _remoteDataSource.listMatches();
  }

  Future<List<MatchModel>> getScheduledMatches() async {
    return await _remoteDataSource.getScheduledMatches();
  }

  Future<List<MatchModel>> getFinishedMatches() async {
    return await _remoteDataSource.getFinishedMatches();
  }

  Future<void> deleteMatch(String id) async {
    await _remoteDataSource.deleteMatch(id);
  }
  
  // Métodos para eventos
  Future<void> saveEvent(MatchEventDetail event, String matchId) async {
    await _remoteDataSource.saveEvent(event, matchId);
  }

  Future<void> deleteEvent(String eventId, String matchId) async {
    await _remoteDataSource.deleteEvent(eventId, matchId);
  }

  Future<List<MatchEventDetail>> getMatchEvents(String matchId) async {
    return await _remoteDataSource.getMatchEvents(matchId);
  }
}
