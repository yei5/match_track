import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tournament_model.dart';

abstract class TournamentRemoteDataSource {
  TournamentRemoteDataSource(SupabaseClient client);

  Future<List<TournamentModel>> getTournaments(String userId);
  Future<TournamentModel> getTournamentDetail(String tournamentId);
  Future<TournamentModel> createTournament(TournamentModel tournament);
}

class TournamentRemoteDataSourceImpl implements TournamentRemoteDataSource {
  final SupabaseClient supabaseClient;

  TournamentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TournamentModel>> getTournaments(String userId) async {
    final response = await supabaseClient
        .from('tournaments')
        .select()
        .eq('creator_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => TournamentModel.fromJson(json))
        .toList();
  }

  @override
  Future<TournamentModel> getTournamentDetail(String tournamentId) async {
    final response = await supabaseClient
        .from('tournaments')
        .select()
        .eq('id', tournamentId)
        .single();

    return TournamentModel.fromJson(response);
  }

  @override
  Future<TournamentModel> createTournament(TournamentModel tournament) async {
    final response = await supabaseClient
        .from('tournaments')
        .insert(tournament.toJson())
        .select()
        .single();

    return TournamentModel.fromJson(response);
  }
}
