import 'package:match_track/features/tournaments/domain/entities/tournament_entity.dart';

abstract class TournamentEvent {}

class LoadTournamentsEvent extends TournamentEvent {}

class LoadTournamentDetailEvent extends TournamentEvent {
  final String tournamentId;

  LoadTournamentDetailEvent({required this.tournamentId});
}

class CreateTournamentEvent extends TournamentEvent {
  final TournamentEntity tournament;

  CreateTournamentEvent({required this.tournament});
}
