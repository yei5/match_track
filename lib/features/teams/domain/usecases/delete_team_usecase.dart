import 'package:match_track/features/teams/domain/repository/team_repository.dart';

class DeleteTeamUseCase {
  final TeamRepository teamRepository;

  DeleteTeamUseCase({required this.teamRepository});

  Future<void> call(String teamId) {
    return teamRepository.deleteTeam(teamId);
  }
}
