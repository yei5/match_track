import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:match_track/features/teams/domain/usecases/create_team.dart';
import 'package:match_track/features/teams/domain/usecases/get_team_detail.dart';
import 'package:match_track/features/teams/domain/usecases/get_teams.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'team_event.dart';
import 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetTeams getTeams;
  final GetTeamDetail getTeamDetail;
  final CreateTeam createTeam;
  final GetCurrentUserUsecase getCurrentUser;

  TeamBloc({
    required this.getTeams,
    required this.getTeamDetail,
    required this.createTeam,
    required this.getCurrentUser,
  }) : super(TeamInitialState()) {
    on<LoadTeamsEvent>(_onLoadTeams);
    on<LoadTeamDetailEvent>(_onLoadTeamDetail);
    on<CreateTeamEvent>(_onCreateTeam);
  }

  Future<String?> _getCurrentUserId() async {
    final user = await getCurrentUser.call();
    return user?.id; // Ajusta si tu modelo usa otra propiedad
  }

  Future<void> _onLoadTeams(
    LoadTeamsEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoadingState());
    try {
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null) {
        emit(TeamErrorState(message: "User not logged in"));
        return;
      }
      final teams = await getTeams.call(currentUserId);
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
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null) {
        emit(TeamErrorState(message: "User not logged in"));
        return;
      }
      final team = Team.copyWith(team: event.team, creator_id: currentUserId);
      final created = await createTeam.call(team);
      emit(TeamCreatedState(team: created));
    } catch (e) {
      emit(TeamErrorState(message: e.toString()));
    }
  }
}
