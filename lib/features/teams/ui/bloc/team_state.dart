import 'package:match_track/core/domain/model/team.dart';

abstract class TeamState {}

class TeamInitialState extends TeamState {}

class TeamLoadingState extends TeamState {}

class TeamsLoadedState extends TeamState {
  final List<Team> teams;

  TeamsLoadedState({required this.teams});
}

class TeamDetailLoadedState extends TeamState {
  final Team team;

  TeamDetailLoadedState({required this.team});
}

class TeamErrorState extends TeamState {
  final String message;

  TeamErrorState({required this.message});
}

class TeamCreatedState extends TeamState {
  final Team team;

  TeamCreatedState({required this.team});
}
