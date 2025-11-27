import '../models/game_model.dart';

abstract class GameRepository {
  Future<List<GameModel>> getGames();
  Future<GameModel?> getGameById(String id);
  Future<List<GameModel>> getGamesByTournament(String tournamentId);
  Future<void> updateGameStatistics(String gameId, GameStatistics statistics);
}
