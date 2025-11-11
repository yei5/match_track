import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/features/players/domain/repository/player_repository.dart';
import 'package:match_track/features/players/data/source/player_remote_data_source.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Player> createPlayer(Player player) {
    return remoteDataSource.createPlayer(player);
  }

  @override
  Future<void> deletePlayer(String playerId) {
    return remoteDataSource.deletePlayer(playerId);
  }

  @override
  Future<List<Player>> getPlayersForTeam(String teamId) {
    return remoteDataSource.getPlayersForTeam(teamId);
  }

  @override
  Future<Player> updatePlayer(Player player) {
    return remoteDataSource.updatePlayer(player);
  }
}
