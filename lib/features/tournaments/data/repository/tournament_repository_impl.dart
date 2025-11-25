import 'dart:typed_data';
import '../../domain/entities/tournament_entity.dart';
import '../../domain/repository/tournament_repository.dart';
import '../models/tournament_model.dart';
import '../source/tournament_remote_data_source.dart';

class TournamentRepositoryImpl implements TournamentRepository {
  final TournamentRemoteDataSource remoteDataSource;

  TournamentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TournamentEntity>> getTournaments(String userId) async {
    final models = await remoteDataSource.getTournaments(userId);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<TournamentEntity> getTournamentDetail(String tournamentId) async {
    final model = await remoteDataSource.getTournamentDetail(tournamentId);
    return _mapModelToEntity(model);
  }

  @override
  Future<TournamentEntity> createTournament(
    TournamentEntity tournament, {
    Uint8List? imageBytes,
  }) async {
    final model = _mapEntityToModel(tournament);
    final createdModel = await remoteDataSource.createTournament(
      model,
      imageBytes: imageBytes,
    );
    return _mapModelToEntity(createdModel);
  }

  TournamentEntity _mapModelToEntity(TournamentModel model) {
    return TournamentEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      sport: model.sport,
      status: model.status,
      start_date: model.start_date,
      end_date: model.end_date,
      image_url: model.imageUrl,
      user_id: model.user_id,
      category: model.category,
      team1_id: model.team1_id,
      team2_id: model.team2_id,
    );
  }

  TournamentModel _mapEntityToModel(TournamentEntity entity) {
    return TournamentModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      sport: entity.sport,
      status: entity.status,
      start_date: entity.start_date,
      end_date: entity.end_date,
      imageUrl: entity.image_url,
      user_id: entity.user_id,
      category: entity.category,
      team1_id: entity.team1_id,
      team2_id: entity.team2_id,
    );
  }
}
