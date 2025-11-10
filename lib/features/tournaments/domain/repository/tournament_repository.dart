import '../entities/tournament_entity.dart';

abstract class TournamentRepository {
  Future<List<TournamentEntity>> getTournaments(String userId);
  Future<TournamentEntity> getTournamentDetail(String tournamentId);
  Future<TournamentEntity> createTournament(TournamentEntity tournament);
}
