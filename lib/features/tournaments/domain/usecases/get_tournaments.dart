import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class GetTournaments {
  final TournamentRepository repository;

  GetTournaments({required this.repository});

  Future<List<TournamentEntity>> call(String userId) {
    return repository.getTournaments(userId);
  }
}
