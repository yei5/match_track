import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tournament_model.dart';

abstract class TournamentRemoteDataSource {
  Future<List<TournamentModel>> getTournaments(String userId);
  Future<TournamentModel> getTournamentDetail(String tournamentId);
  Future<TournamentModel> createTournament(
    TournamentModel tournament, {
    Uint8List? imageBytes,
  });
}

class TournamentRemoteDataSourceImpl implements TournamentRemoteDataSource {
  final SupabaseClient supabaseClient;

  TournamentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TournamentModel>> getTournaments(String userId) async {
    final response = await supabaseClient
        .from('tournaments')
        .select()
        .eq('user_id', userId)
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
  Future<TournamentModel> createTournament(
    TournamentModel tournament, {
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    // 1️⃣ Si hay imagen, la subimos al bucket 'tournament_images'
    if (imageBytes != null && imageBytes.isNotEmpty) {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final uploadResponse = await supabaseClient.storage
          .from('tournament-photos')
          .uploadBinary(fileName, imageBytes);

      if (uploadResponse.isEmpty) {
        throw Exception('No se pudo subir la imagen');
      }

      // Obtener URL pública
      final publicUrl = supabaseClient.storage
          .from('tournament-photos')
          .getPublicUrl(fileName);

      imageUrl = publicUrl;
    }

    // 2️⃣ Insertamos el torneo con la URL
    final response = await supabaseClient
        .from('tournaments')
        .insert({...tournament.toJson(), 'image_url': imageUrl})
        .select()
        .single();

    return TournamentModel.fromJson(response);
  }
}
