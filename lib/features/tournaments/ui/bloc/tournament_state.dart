import 'package:match_track/features/tournaments/domain/entities/tournament_entity.dart';

abstract class TournamentState {}

class TournamentInitialState extends TournamentState {}

class TournamentLoadingState extends TournamentState {}

class TournamentsLoadedState extends TournamentState {
  final List<TournamentEntity> tournaments;

  TournamentsLoadedState({required this.tournaments});
}

class TournamentDetailLoadedState extends TournamentState {
  final TournamentEntity tournament;

  TournamentDetailLoadedState({required this.tournament});
}

class TournamentErrorState extends TournamentState {
  final String message;

  TournamentErrorState({required this.message});
}

class TournamentCreatedState extends TournamentState {
  final TournamentEntity tournament;

  TournamentCreatedState({required this.tournament});
}
