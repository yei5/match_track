import '../../domain/models/game_model.dart';
import '../../domain/repository/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  @override
  Future<List<GameModel>> getGames() async {
    // TODO: Implementar con Supabase
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockGames();
  }

  @override
  Future<GameModel?> getGameById(String id) async {
    // TODO: Implementar con Supabase
    await Future.delayed(const Duration(milliseconds: 300));
    final games = _getMockGames();
    return games.firstWhere((game) => game.id == id);
  }

  @override
  Future<List<GameModel>> getGamesByTournament(String tournamentId) async {
    // TODO: Implementar con Supabase
    await Future.delayed(const Duration(milliseconds: 500));
    final games = _getMockGames();
    return games.where((game) => game.tournamentId == tournamentId).toList();
  }

  @override
  Future<void> updateGameStatistics(String gameId, GameStatistics statistics) async {
    // TODO: Implementar con Supabase
    await Future.delayed(const Duration(milliseconds: 300));
  }

  List<GameModel> _getMockGames() {
    return [];
  }
}
