import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class GetTournamentDetail {
  final TournamentRepository repository;
  GetTournamentDetail(this.repository);

  Future<TournamentEntity?> call(String id) async {
    return await repository.getTournamentDetail(id);
  }
}
