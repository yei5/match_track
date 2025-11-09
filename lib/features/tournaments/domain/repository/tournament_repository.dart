import '../entities/tournament_entity.dart';

abstract class TournamentRepository {
  Future<List<TournamentEntity>> getUserTournaments(String userId);
  Future<TournamentEntity?> getTournamentDetail(String id);
  Future<void> createTournament(TournamentEntity tournament);
}
