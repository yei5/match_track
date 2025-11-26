import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/domain/model/team.dart';

abstract class TeamRemoteDataSource {
  Future<List<Team>> getTeams(String userId, {String? sport, String? category});
  Future<Team> getTeamDetail(String teamId);
  Future<Team> createTeam(Team team);
  Future<Team> updateTeam(Team team);
  Future<void> deleteTeam(String teamId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  TeamRemoteDataSourceImpl();

  @override
  Future<List<Team>> getTeams(String userId, {String? sport, String? category}) async {
    var query = supabaseClient.from('teams').select();

    query = query.eq('creator_id', userId);

    if (sport != null && sport != 'Todos') {
      query = query.eq('sport', sport);
    }
    if (category != null && category != 'Todos') {
      query = query.eq('category', category);
    }

    final response = await query;

    return (response as List)
        .map((json) => Team.fromJson(json))
        .toList();
  }

  @override
  Future<Team> getTeamDetail(String teamId) async {
    final response = await supabaseClient
        .from('teams')
        .select()
        .eq('id', teamId)
        .single();

    return Team.fromJson(response);
  }

  @override
  Future<Team> createTeam(Team team) async {
    final response = await supabaseClient
        .from('teams')
        .insert(team.toJson())
        .select()
        .single();

    return Team.fromJson(response);
    }


    @override
    Future<Team> updateTeam(Team team) async {
      final response = await supabaseClient
          .from('teams')
          .update(team.toJson())
          .eq('id', team.id)
          .select()
          .single();
  
      return Team.fromJson(response);
    }
  
    @override
    Future<void> deleteTeam(String teamId) async {
      await supabaseClient.from('teams').delete().eq('id', teamId);
    }
  }
