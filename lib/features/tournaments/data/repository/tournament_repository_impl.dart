import '../../domain/entities/tournament_entity.dart';
import '../../domain/repository/tournament_repository.dart';
import '../models/tournament_model.dart';
import '../source/tournament_remote_data_source.dart';

class TournamentRepositoryImpl implements TournamentRepository {
  final TournamentRemoteDataSource remoteDataSource;

  TournamentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createTournament(TournamentEntity tournament) async {
    // Si el entity es TournamentModel, usamos toJson; si no, construimos Map manualmente.
    final Map<String, dynamic> payload;
    if (tournament is TournamentModel) {
      payload = tournament.toJson();
    } else {
      payload = {
        'id': tournament.id,
        'name': tournament.name,
        'description': tournament.description,
        'sport': tournament.sport,
        'image_url': tournament.imageUrl,
        'status': tournament.status,
        'start_date': tournament.startDate,
        'end_date': tournament.endDate,
        'team_a': tournament.teamA,
        'team_b': tournament.teamB,
        'creator_id': tournament.creatorId,
        'created_at': tournament.createdAt?.toIso8601String(),
      };
    }

    await remoteDataSource.createTournament(payload);
  }

  @override
  Future<TournamentEntity?> getTournamentDetail(String id) async {
    return await remoteDataSource.getTournamentDetail(id);
  }

  @override
  Future<List<TournamentEntity>> getUserTournaments(String userId) async {
    return await remoteDataSource.getUserTournaments(userId);
  }
}
