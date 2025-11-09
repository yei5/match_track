import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class GetTournamentDetail {
  final TournamentRepository repository;

  GetTournamentDetail({required this.repository});

  Future<TournamentEntity> call(String tournamentId) {
    return repository.getTournamentDetail(tournamentId);
  }
}
