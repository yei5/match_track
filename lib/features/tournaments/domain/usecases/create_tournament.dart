import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class CreateTournament {
  final TournamentRepository repository;
  CreateTournament(this.repository);

  Future<void> call(TournamentEntity tournament) async {
    await repository.createTournament(tournament);
  }
}
