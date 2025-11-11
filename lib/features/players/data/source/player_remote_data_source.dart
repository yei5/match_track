import 'package:match_track/core/domain/model/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PlayerRemoteDataSource {
  Future<List<Player>> getPlayersForTeam(String teamId);
  Future<Player> createPlayer(Player player);
  Future<Player> updatePlayer(Player player);
  Future<void> deletePlayer(String playerId);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<Player> createPlayer(Player player) async {
    final response = await supabaseClient
        .from('players')
        .insert(player.toJson()) // Assuming Player has toJson
        .select()
        .single();
    return Player.fromJson(response); // Assuming Player has fromJson
  }

  @override
  Future<void> deletePlayer(String playerId) async {
    await supabaseClient.from('players').delete().eq('id', playerId);
  }

  @override
  Future<List<Player>> getPlayersForTeam(String teamId) async {
    final response =
        await supabaseClient.from('players').select().eq('team_id', teamId);
    return (response as List).map((json) => Player.fromJson(json)).toList();
  }

  @override
  Future<Player> updatePlayer(Player player) async {
    final response = await supabaseClient
        .from('players')
        .update(player.toJson())
        .eq('id', player.id)
        .select()
        .single();
    return Player.fromJson(response);
  }
}
