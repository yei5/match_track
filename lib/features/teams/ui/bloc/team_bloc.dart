import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:match_track/features/players/domain/usecases/create_player.dart';
import 'package:match_track/features/players/domain/usecases/get_players_for_team.dart';
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
  final GetPlayersForTeam getPlayersForTeam;
  final CreatePlayer createPlayer;

  TeamBloc({
    required this.getTeams,
    required this.getTeamDetail,
    required this.createTeam,
    required this.getCurrentUser,
    required this.getPlayersForTeam,
    required this.createPlayer,
  }) : super(TeamInitialState()) {
    on<LoadTeamsEvent>(_onLoadTeams);
    on<LoadTeamDetailEvent>(_onLoadTeamDetail);
    on<CreateTeamEvent>(_onCreateTeam);
  }

  Future<String?> _getCurrentUserId() async {
    final user = await getCurrentUser.call();
    return user?.id;
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
      final players = await getPlayersForTeam.call(event.teamId);
      emit(TeamDetailLoadedState(team: team, players: players));
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
      // 1. Create the team
      print("creating team: ${event.team.toJson()}");
      final teamWithCreator =
          Team.copyWith(team: event.team, creator_id: currentUserId);
      final createdTeam = await createTeam.call(teamWithCreator);

      print("created team: ${createdTeam.toJson()}");
      // 2. Create each player with the new team's ID
      for (final player in event.players) {
        final playerWithTeamId =
            Player.copyWith(player: player, team_id: createdTeam.id);
        print( "Creating player with team ID: ${playerWithTeamId.toJson()}");
        await createPlayer.call(playerWithTeamId);
      }

      emit(TeamCreatedState(team: createdTeam));
    } catch (e) {
      emit(TeamErrorState(message: e.toString()));
    }
  }
}
