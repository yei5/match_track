import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';

abstract class TeamEvent {}

class LoadTeamsEvent extends TeamEvent {
  final String sport;
  final String category;

  LoadTeamsEvent({this.sport = 'Todos', this.category = 'Todos'});
}

class LoadTeamDetailEvent extends TeamEvent {
  final String teamId;

  LoadTeamDetailEvent({required this.teamId});
}

class CreateTeamEvent extends TeamEvent {
  final Team team;
  final List<Player> players;

  CreateTeamEvent({required this.team, required this.players});
}

class UpdateTeamEvent extends TeamEvent {
  final Team team;
  final List<Player> players;

  UpdateTeamEvent({required this.team, required this.players});
}

class DeleteTeamEvent extends TeamEvent {
  final String teamId;

  DeleteTeamEvent({required this.teamId});
}
