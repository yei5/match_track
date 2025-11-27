import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';

abstract class MatchRemoteDataSource {
  Future<void> saveMatch(MatchModel match);
  Future<MatchModel?> getMatch(String id);
  Future<List<MatchModel>> listMatches();
  Future<List<MatchModel>> getScheduledMatches();
  Future<List<MatchModel>> getFinishedMatches();
  Future<void> deleteMatch(String id);
  Future<void> saveEvent(MatchEventDetail event, String matchId);
  Future<void> deleteEvent(String eventId, String matchId);
  Future<List<MatchEventDetail>> getMatchEvents(String matchId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final SupabaseClient supabaseClient;

  MatchRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> saveMatch(MatchModel match) async {
    try {
      final matchData = {
        'id': match.id,
        'home_team_id': match.homeTeam.id,
        'away_team_id': match.awayTeam.id,
        'home_score': match.homeScore,
        'away_score': match.awayScore,
        'status': match.status.toString().split('.').last,
        'current_half': match.currentHalf.toString().split('.').last,
        'elapsed_seconds': match.elapsedSeconds,
        'scheduled_date': match.scheduledDate?.toIso8601String(),
        'tournament_id': match.tournamentId,
        'user_id': supabaseClient.auth.currentUser?.id,
      };

      // Usar upsert para insertar o actualizar
      await supabaseClient.from('matches').upsert(matchData);
      
      // Guardar eventos si los hay
      if (match.detailedEvents.isNotEmpty) {
        for (var event in match.detailedEvents) {
          await saveEvent(event, match.id);
        }
      }
    } catch (e) {
      debugPrint('Error saving match: $e');
      rethrow;
    }
  }

  @override
  Future<MatchModel?> getMatch(String id) async {
    try {
      final response = await supabaseClient
          .from('matches')
          .select('''
            *,
            home_team:teams!matches_home_team_id_fkey(*),
            away_team:teams!matches_away_team_id_fkey(*)
          ''')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      // Cargar eventos
      final events = await getMatchEvents(id);

      return _matchFromJson(response, events);
    } catch (e) {
      debugPrint('Error getting match: $e');
      return null;
    }
  }

  @override
  Future<List<MatchModel>> listMatches() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabaseClient
          .from('matches')
          .select('''
            *,
            home_team:teams!matches_home_team_id_fkey(*),
            away_team:teams!matches_away_team_id_fkey(*)
          ''')
          .eq('user_id', userId)
          .order('scheduled_date', ascending: false);

      return await _matchesFromResponse(response);
    } catch (e) {
      debugPrint('Error listing matches: $e');
      return [];
    }
  }

  @override
  Future<List<MatchModel>> getScheduledMatches() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabaseClient
          .from('matches')
          .select('''
            *,
            home_team:teams!matches_home_team_id_fkey(*),
            away_team:teams!matches_away_team_id_fkey(*)
          ''')
          .eq('user_id', userId)
          .eq('status', 'scheduled')
          .order('scheduled_date', ascending: true);

      return await _matchesFromResponse(response);
    } catch (e) {
      debugPrint('Error getting scheduled matches: $e');
      return [];
    }
  }

  @override
  Future<List<MatchModel>> getFinishedMatches() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabaseClient
          .from('matches')
          .select('''
            *,
            home_team:teams!matches_home_team_id_fkey(*),
            away_team:teams!matches_away_team_id_fkey(*)
          ''')
          .eq('user_id', userId)
          .eq('status', 'finished')
          .order('scheduled_date', ascending: false);

      return await _matchesFromResponse(response);
    } catch (e) {
      debugPrint('Error getting finished matches: $e');
      return [];
    }
  }

  @override
  Future<void> deleteMatch(String id) async {
    try {
      // Primero eliminar eventos
      await supabaseClient.from('match_events').delete().eq('match_id', id);
      
      // Luego eliminar el partido
      await supabaseClient.from('matches').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting match: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveEvent(MatchEventDetail event, String matchId) async {
    try {
      final eventData = {
        'id': event.id,
        'match_id': matchId,
        'type': event.type.toString().split('.').last,
        'minute': event.minute,
        'team_id': event.team.id,
        'player_id': event.player?.id,
        'player2_id': event.player2?.id,
        'details': event.details,
        'jersey_number': event.jerseyNumber,
        'jersey_number2': event.jerseyNumber2,
      };

      await supabaseClient.from('match_events').upsert(eventData);
    } catch (e) {
      debugPrint('Error saving event: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent(String eventId, String matchId) async {
    try {
      await supabaseClient
          .from('match_events')
          .delete()
          .eq('id', eventId)
          .eq('match_id', matchId);
    } catch (e) {
      debugPrint('Error deleting event: $e');
      rethrow;
    }
  }

  @override
  Future<List<MatchEventDetail>> getMatchEvents(String matchId) async {
    try {
      final response = await supabaseClient
          .from('match_events')
          .select('''
            *,
            team:teams!match_events_team_id_fkey(*)
          ''')
          .eq('match_id', matchId)
          .order('minute', ascending: true);

      if (response.isEmpty) return [];

      return response.map<MatchEventDetail>((json) {
        return _eventFromJson(json);
      }).toList();
    } catch (e) {
      debugPrint('Error getting match events: $e');
      return [];
    }
  }

  Future<List<MatchModel>> _matchesFromResponse(List<dynamic> response) async {
    List<MatchModel> matches = [];
    
    for (var json in response) {
      final events = await getMatchEvents(json['id']);
      matches.add(_matchFromJson(json, events));
    }
    
    return matches;
  }

  MatchModel _matchFromJson(Map<String, dynamic> json, List<MatchEventDetail> events) {
    return MatchModel(
      id: json['id'],
      homeTeam: _teamFromJson(json['home_team']),
      awayTeam: _teamFromJson(json['away_team']),
      homeScore: json['home_score'] ?? 0,
      awayScore: json['away_score'] ?? 0,
      status: _statusFromString(json['status']),
      currentHalf: _halfTimeFromString(json['current_half']),
      elapsedSeconds: json['elapsed_seconds'] ?? 0,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'])
          : null,
      tournamentId: json['tournament_id'],
      detailedEvents: events,
    );
  }

  Team _teamFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Retornar equipo por defecto
      return Team(
        id: '',
        name: 'Equipo',
        category: '',
        sport: '',
        description: '',
        creator_id: '',
      );
    }
    
    return Team.fromJson(json);
  }

  MatchEventDetail _eventFromJson(Map<String, dynamic> json) {
    return MatchEventDetail(
      id: json['id'],
      type: _eventTypeFromString(json['type']),
      minute: json['minute'],
      team: _teamFromJson(json['team'] as Map<String, dynamic>?),
      player: null, // Se puede mejorar cargando el jugador desde la BD
      player2: null,
      details: json['details'],
      jerseyNumber: json['jersey_number'],
      jerseyNumber2: json['jersey_number2'],
    );
  }

  MatchStatus _statusFromString(String? status) {
    switch (status) {
      case 'scheduled':
        return MatchStatus.scheduled;
      case 'idle':
        return MatchStatus.idle;
      case 'inProgress':
        return MatchStatus.inProgress;
      case 'finished':
        return MatchStatus.finished;
      default:
        return MatchStatus.idle;
    }
  }

  HalfTime _halfTimeFromString(String? half) {
    switch (half) {
      case 'firstHalf':
        return HalfTime.firstHalf;
      case 'halftime':
        return HalfTime.halftime;
      case 'secondHalf':
        return HalfTime.secondHalf;
      case 'finished':
        return HalfTime.finished;
      default:
        return HalfTime.firstHalf;
    }
  }

  EventType _eventTypeFromString(String? type) {
    switch (type) {
      case 'goal':
        return EventType.goal;
      case 'yellowCard':
        return EventType.yellowCard;
      case 'redCard':
        return EventType.redCard;
      case 'substitution':
        return EventType.substitution;
      case 'injury':
        return EventType.injury;
      case 'foul':
        return EventType.foul;
      default:
        return EventType.goal;
    }
  }
}
