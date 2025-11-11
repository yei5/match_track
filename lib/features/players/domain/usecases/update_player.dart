import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/features/players/domain/repository/player_repository.dart';

class UpdatePlayer {
  final PlayerRepository repository;

  UpdatePlayer({required this.repository});

  Future<Player> call(Player player) {
    return repository.updatePlayer(player);
  }
}
