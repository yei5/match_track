import 'package:match_track/features/teams/domain/repository/team_repository.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/source/team_remote_data_source.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Team>> getTeams(String userId) async {
    final models = await remoteDataSource.getTeams(userId);
    return models.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<Team> getTeamDetail(String teamId) async {
    final model = await remoteDataSource.getTeamDetail(teamId);
    return _mapModelToEntity(model);
  }

  @override
  Future<Team> createTeam(Team team) async {
    final model = _mapEntityToModel(team);
    final createdModel = await remoteDataSource.createTeam(model);
    return _mapModelToEntity(createdModel);
  }

  Team _mapModelToEntity(Team model) {
    return Team(
      id: model.id,
      name: model.name,
      description: model.description,
      sport: model.sport,
      imageUrl: model.imageUrl,
      creator_id: model.creator_id,
      category: model.category,
    );
  }

  Team _mapEntityToModel(Team entity) {
    return Team(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      sport: entity.sport,
      imageUrl: entity.imageUrl,
      creator_id: entity.creator_id,
      category: entity.category,
    );
  }
}
