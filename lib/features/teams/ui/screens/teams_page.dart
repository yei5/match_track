import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/core/widgets/app_header.dart';
import 'package:match_track/core/widgets/nav_bar.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/bloc/team_event.dart';
import 'package:match_track/features/teams/ui/bloc/team_state.dart';
import 'package:match_track/features/teams/ui/screens/team_detail_page.dart';
import 'package:match_track/features/teams/ui/widgets/empty_teams_state.dart';
import 'package:match_track/features/teams/ui/widgets/team_card.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(LoadTeamsEvent());
  }

  void _goToCreateTeam() {
    Navigator.pushNamed(context, '/createTeam');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(title: 'Mis equipos'),
      body: BlocListener<TeamBloc, TeamState>(
        listener: (context, state) {
          if (state is TeamDetailLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeamDetailPage(team: state.team),
              ),
            );
          }
        },
        child: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            if (state is TeamLoadingState || state is TeamInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TeamsLoadedState) {
              final teams = state.teams;

              if (teams.isEmpty) {
                return EmptyTeams(onCreatePressed: _goToCreateTeam);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TeamBloc>().add(LoadTeamsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: teams.length,
                  itemBuilder: (_, i) => TeamCard(
                    team: teams[i],
                    onTap: () => context
                        .read<TeamBloc>()
                        .add(LoadTeamDetailEvent(teamId: teams[i].id)),
                  ),
                ),
              );
            } else if (state is TeamErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/control');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/tournaments');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/teams');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      floatingActionButton: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state is TeamsLoadedState && state.teams.isNotEmpty) {
            return FloatingActionButton(
              onPressed: _goToCreateTeam,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.surface),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}