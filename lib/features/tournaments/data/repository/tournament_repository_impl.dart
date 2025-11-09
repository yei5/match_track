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
  Future<TournamentEntity> createTournament(TournamentEntity tournament) async {
    final model = _mapEntityToModel(tournament);
    final createdModel = await remoteDataSource.createTournament(model);
    return _mapModelToEntity(createdModel);
  }

  TournamentEntity _mapModelToEntity(TournamentModel model) {
    return TournamentEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      sport: model.sport,
      status: model.status,
      startDate: model.startDate,
      endDate: model.endDate,
      imageUrl: model.imageUrl,
      creatorId: model.creatorId,
      category: model.category,
      teamA: model.teamA,
      teamB: model.teamB,
    );
  }

  TournamentModel _mapEntityToModel(TournamentEntity entity) {
    return TournamentModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      sport: entity.sport,
      status: entity.status,
      startDate: entity.startDate,
      endDate: entity.endDate,
      imageUrl: entity.imageUrl,
      creatorId: entity.creatorId,
      category: entity.category,
      teamA: entity.teamA,
      teamB: entity.teamB,
    );
  }
}
