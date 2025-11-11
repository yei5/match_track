import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import '../repository/team_repository.dart';

class GetTeams {
  final TeamRepository repository;
  GetTeams({required this.repository});

  Future<List<Team>> call(String userId) {
    return repository.getTeams(userId);
  }
}
