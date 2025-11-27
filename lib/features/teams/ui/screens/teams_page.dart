import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/core/widgets/app_header.dart';
import 'package:match_track/core/widgets/minimizable_nav_bar.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/bloc/team_event.dart';
import 'package:match_track/features/teams/ui/bloc/team_state.dart';
import 'package:match_track/features/teams/ui/screens/team_detail_page.dart';
import 'package:match_track/features/teams/ui/widgets/empty_teams_state.dart';
import 'package:match_track/features/teams/ui/widgets/team_card.dart';
import 'package:match_track/features/teams/ui/widgets/team_filter_bar.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final int _currentIndex = 3;
  String selectedSport = 'Todos';
  String selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadTeamsWithFilters();
  }

  void _loadTeamsWithFilters() {
    context.read<TeamBloc>().add(LoadTeamsEvent(
          sport: selectedSport,
          category: selectedCategory,
        ));
  }

  void _goToCreateTeam() {
    Navigator.pushNamed(context, '/createTeam');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(title: 'Mis equipos'),
      body: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            if (state is TeamLoadingState ||
                state is TeamInitialState ||
                state is TeamDetailLoadedState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TeamsLoadedState) {
              final teams = state.teams;

              if (teams.isEmpty) {
                return EmptyTeams(onCreatePressed: _goToCreateTeam);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _loadTeamsWithFilters();
                },
                child: Column(
                  children: [
                    TeamFilterBar(
                      selectedSport: selectedSport,
                      selectedCategory: selectedCategory,
                      onSportChanged: (value) {
                        setState(() {
                          selectedSport = value;
                        });
                        _loadTeamsWithFilters();
                      },
                      onCategoryChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                        _loadTeamsWithFilters();
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: teams.length,
                        itemBuilder: (_, i) => TeamCard(
                          team: teams[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TeamDetailPage(
                                teamId: teams[i].id,
                              ),
                            ),
                          ).then((_) => _loadTeamsWithFilters()),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is TeamErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      bottomNavigationBar: MinimizableNavBar(
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