import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/teams/domain/usecases/create_team.dart';
import 'package:match_track/features/teams/domain/usecases/get_team_detail.dart'; 
import 'package:match_track/features/teams/domain/usecases/get_teams.dart';
import 'team_event.dart';
import 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetTeams getTeams;
  final GetTeamDetail getTeamDetail;
  final CreateTeam createTeam;

  TeamBloc({
    required this.getTeams,
    required this.getTeamDetail,
    required this.createTeam,
  }) : super(TeamInitialState()) {
    on<LoadTeamsEvent>(_onLoadTeams);
    on<LoadTeamDetailEvent>(_onLoadTeamDetail);
    on<CreateTeamEvent>(_onCreateTeam);
  }

  Future<void> _onLoadTeams(
    LoadTeamsEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoadingState());
    try {
      final teams = await getTeams.call('current_user_id');
      emit(TeamsLoadedState(teams: teams));
    } catch (e) {
      emit(TeamErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadTeamDetail(
    LoadTeamDetailEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoadingState());
    try {
      final team = await getTeamDetail.call(event.teamId);
      emit(TeamDetailLoadedState(team: team));
    } catch (e) {
      emit(TeamErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreateTeam(
    CreateTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoadingState());
    try {
      final team = await createTeam.call(event.team);
      emit(TeamCreatedState(team: team));
    } catch (e) {
      emit(TeamErrorState(message: e.toString()));
    }
  }
}
