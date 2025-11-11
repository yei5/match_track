import 'package:match_track/features/teams/domain/repository/team_repository.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/core/domain/model/team.dart';


class CreateTeam {
  final TeamRepository repository;

  CreateTeam(TeamRepositoryImpl repo, {required this.repository});

  Future<Team> call(Team team) {
    return repository.createTeam(team);
  }
}
