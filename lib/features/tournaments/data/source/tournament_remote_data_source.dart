import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tournament_model.dart';

class TournamentRemoteDataSource {
  final SupabaseClient client;

  TournamentRemoteDataSource(this.client);

  Future<List<TournamentModel>> getUserTournaments(String userId) async {
    final response = await client
        .from('tournaments')
        .select()
        .eq('creator_id', userId)
        .order('created_at', ascending: false);

    if (response == null) return [];
    return (response as List)
        .map((json) => TournamentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<TournamentModel?> getTournamentDetail(String id) async {
    final response = await client
        .from('tournaments')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response == null) return null;
    return TournamentModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> createTournament(Map<String, dynamic> data) async {
    await client.from('tournaments').insert(data);
  }
}
