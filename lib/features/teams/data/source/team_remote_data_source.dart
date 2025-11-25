import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/domain/model/team.dart';

abstract class TeamRemoteDataSource {
  Future<List<Team>> getTeams(String userId);
  Future<Team> getTeamDetail(String teamId);
  Future<Team> createTeam(Team team);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  TeamRemoteDataSourceImpl();

  @override
  Future<List<Team>> getTeams(String userId) async {
    final response = await supabaseClient
        .from('teams')
        .select()
        .eq('creator_id', userId)
        .order('created_at', ascending: false);

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
}
