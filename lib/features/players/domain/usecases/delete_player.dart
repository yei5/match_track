import 'package:match_track/features/players/domain/repository/player_repository.dart';

class DeletePlayer {
  final PlayerRepository repository;

  DeletePlayer({required this.repository});

  Future<void> call(String playerId) {
    return repository.deletePlayer(playerId);
  }
}
