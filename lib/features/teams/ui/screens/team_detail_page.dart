import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/bloc/team_event.dart';
import 'package:match_track/features/teams/ui/screens/edit_team_page.dart';
import 'package:match_track/features/teams/ui/bloc/team_state.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  const TeamDetailPage({super.key, required this.teamId});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(LoadTeamDetailEvent(teamId: widget.teamId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            if (state is TeamDetailLoadedState) {
              return Text(state.team.name);
            }
            return const Text('Detalle del Equipo');
          },
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          final aTeam = state is TeamDetailLoadedState ? state.team : null;
          final aPlayers = state is TeamDetailLoadedState ? state.players : null;

          if (state is TeamLoadingState || aTeam == null || aPlayers == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamDetailLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Team Image
                        aTeam.imageUrl != null && aTeam.imageUrl!.isNotEmpty
                            ? Image.network(
                                aTeam.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 200,
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Icon(
                                  Icons.groups,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                              ),
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                aTeam.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                aTeam.description,
                                style: const TextStyle(
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Deporte', aTeam.sport),
                              _buildInfoRow('Categoría', aTeam.category),
                              const Divider(height: 32),
                              const Text(
                                'Jugadores',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              aPlayers.isEmpty
                                  ? const Center(
                                      child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                          'Este equipo aún no tiene jugadores.'),
                                    ))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: aPlayers.length,
                                      itemBuilder: (context, index) {
                                        final player = aPlayers[index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              child:
                                                  Text(player.jersey_number),
                                            ),
                                            title: Text(player.name),
                                            subtitle: Text(player.sport),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Borrar'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar Borrado'),
                                  content: const Text(
                                      '¿Estás seguro de que quieres borrar este equipo?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<TeamBloc>().add(
                                            DeleteTeamEvent(
                                                teamId: aTeam.id!));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Borrar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (_) => EditTeamPage(
                                  team: aTeam,
                                  players: aPlayers,
                                ),
                              ),
                            )
                                .then((_) {
                              context.read<TeamBloc>().add(
                                  LoadTeamDetailEvent(teamId: aTeam.id!));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is TeamErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is TeamDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return const SizedBox();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}