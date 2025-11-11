import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/features/players/domain/repository/player_repository.dart';

class GetPlayersForTeam {
  final PlayerRepository repository;

  GetPlayersForTeam({required this.repository});

  Future<List<Player>> call(String teamId) {
    return repository.getPlayersForTeam(teamId);
  }
}
