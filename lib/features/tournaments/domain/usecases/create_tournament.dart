import 'package:match_track/features/tournaments/data/repository/tournament_repository_impl.dart';

import '../entities/tournament_entity.dart';
import '../repository/tournament_repository.dart';

class CreateTournament {
  final TournamentRepository repository;

  CreateTournament(TournamentRepositoryImpl repo, {required this.repository});

  Future<TournamentEntity> call(TournamentEntity tournament) {
    return repository.createTournament(tournament);
  }
}
