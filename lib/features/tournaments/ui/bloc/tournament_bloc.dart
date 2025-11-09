import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_tournaments.dart';
import '../../domain/usecases/get_tournament_detail.dart';
import '../../domain/usecases/create_tournament.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final GetTournaments getTournaments;
  final GetTournamentDetail getTournamentDetail;
  final CreateTournament createTournament;

  TournamentBloc({
    required this.getTournaments,
    required this.getTournamentDetail,
    required this.createTournament,
  }) : super(TournamentInitialState()) {
    on<LoadTournamentsEvent>(_onLoadTournaments);
    on<LoadTournamentDetailEvent>(_onLoadTournamentDetail);
    on<CreateTournamentEvent>(_onCreateTournament);
  }

  Future<void> _onLoadTournaments(
    LoadTournamentsEvent event,
    Emitter<TournamentState> emit,
  ) async {
    emit(TournamentLoadingState());
    try {
      // En una implementación real, necesitarías obtener el userId de alguna manera
      final tournaments = await getTournaments.call('current_user_id');
      emit(TournamentsLoadedState(tournaments: tournaments));
    } catch (e) {
      emit(TournamentErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadTournamentDetail(
    LoadTournamentDetailEvent event,
    Emitter<TournamentState> emit,
  ) async {
    emit(TournamentLoadingState());
    try {
      final tournament = await getTournamentDetail.call(event.tournamentId);
      emit(TournamentDetailLoadedState(tournament: tournament));
    } catch (e) {
      emit(TournamentErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreateTournament(
    CreateTournamentEvent event,
    Emitter<TournamentState> emit,
  ) async {
    emit(TournamentLoadingState());
    try {
      final tournament = await createTournament.call(event.tournament);
      emit(TournamentCreatedState(tournament: tournament));
    } catch (e) {
      emit(TournamentErrorState(message: e.toString()));
    }
  }
}
