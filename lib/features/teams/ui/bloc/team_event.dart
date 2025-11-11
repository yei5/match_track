import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';

abstract class TeamEvent {}

class LoadTeamsEvent extends TeamEvent {}

class LoadTeamDetailEvent extends TeamEvent {
  final String teamId;

  LoadTeamDetailEvent({required this.teamId});
}

class CreateTeamEvent extends TeamEvent {
  final Team team;
  final List<Player> players;

  CreateTeamEvent({required this.team, required this.players});
}
