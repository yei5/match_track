import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class GetTournaments {
  final TournamentRepository repository;
  GetTournaments(this.repository);

  Future<List<TournamentEntity>> call(String userId) async {
    return await repository.getUserTournaments(userId);
  }
}
