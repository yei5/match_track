import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/domain/repository/team_repository.dart';

class UpdateTeamUseCase {
  final TeamRepository teamRepository;

  UpdateTeamUseCase({required this.teamRepository});

  Future<Team> call(Team team) {
    return teamRepository.updateTeam(team);
  }
}
