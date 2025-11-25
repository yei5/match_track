import 'package:match_track/core/domain/model/team.dart';

abstract class TeamRepository {
  Future<List<Team>> getTeams(String userId);
  Future<Team> getTeamDetail(String teamId);
  Future<Team> createTeam(Team team);
}
