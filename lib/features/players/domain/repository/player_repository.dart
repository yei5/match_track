import 'package:match_track/core/domain/model/player.dart';

abstract class PlayerRepository {
  Future<List<Player>> getPlayersForTeam(String teamId);
  Future<Player> createPlayer(Player player);
  Future<Player> updatePlayer(Player player);
  Future<void> deletePlayer(String playerId);
}
