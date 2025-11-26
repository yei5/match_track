import 'package:match_track/core/domain/model/team.dart';

abstract class TeamRepository {
  Future<List<Team>> getTeams(String userId, {String? sport, String? category});
  Future<Team> getTeamDetail(String teamId);
  Future<Team> createTeam(Team team);
  Future<Team> updateTeam(Team team);
  Future<void> deleteTeam(String teamId);
}

