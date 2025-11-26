import 'package:match_track/features/players/domain/repository/player_repository.dart';

class DeletePlayerUseCase {
  final PlayerRepository playerRepository;

  DeletePlayerUseCase({required this.playerRepository});

  Future<void> call(String playerId) {
    return playerRepository.deletePlayer(playerId);
  }
}