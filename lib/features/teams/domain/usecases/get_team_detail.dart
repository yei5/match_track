import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/features/teams/domain/repository/team_repository.dart';

class GetTeamDetail {
  final TeamRepository repository;
  GetTeamDetail({required this.repository});
  Future<Team> call(String teamId) {
    return repository.getTeamDetail(teamId);
  }
}
