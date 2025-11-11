import 'package:match_track/core/domain/model/team.dart';

abstract class TeamEvent {}

class LoadTeamsEvent extends TeamEvent {}

class LoadTeamDetailEvent extends TeamEvent {
  final String teamId;

  LoadTeamDetailEvent({required this.teamId});
}

class CreateTeamEvent extends TeamEvent {
  final Team team;

  CreateTeamEvent({required this.team});
}
