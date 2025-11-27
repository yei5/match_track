import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/features/teams/data/source/team_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentCard extends StatefulWidget {
  final Map<String, dynamic> tournament;
  final VoidCallback? onTap;

  const TournamentCard({super.key, required this.tournament, this.onTap});

  @override
  State<TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends State<TournamentCard> {
  final _teamRepository = TeamRepositoryImpl(remoteDataSource: TeamRemoteDataSourceImpl());
  List<Team> _teams = [];
  bool _loadingTeams = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() => _loadingTeams = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _loadingTeams = false);
        return;
      }

      final allTeams = await _teamRepository.getTeams(userId);
      
      final team1Id = widget.tournament['team1_id']?.toString();
      final team2Id = widget.tournament['team2_id']?.toString();
      
      List<Team> tournamentTeams = [];
      if (team1Id != null && team1Id.isNotEmpty) {
        final team = allTeams.where((t) => t.id == team1Id).firstOrNull;
        if (team != null) tournamentTeams.add(team);
      }
      if (team2Id != null && team2Id.isNotEmpty && team2Id != team1Id) {
        final team = allTeams.where((t) => t.id == team2Id).firstOrNull;
        if (team != null) tournamentTeams.add(team);
      }

      setState(() {
        _teams = tournamentTeams;
        _loadingTeams = false;
      });
    } catch (e) {
      setState(() => _loadingTeams = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.tournament['image_url'];
    final name = widget.tournament['name'] ?? 'Sin nombre';
    final sport = widget.tournament['sport'] ?? 'Deporte no especificado';
    final status = widget.tournament['status'] ?? 'Desconocido';
    final startDate = widget.tournament['start_date'] ?? '';
    final endDate = widget.tournament['end_date'] ?? '';

    Color statusColor;
    switch (status) {
      case 'Activo':
        statusColor = Colors.green;
        break;
      case 'Programado':
        statusColor = Colors.orange;
        break;
      case 'Finalizado':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen del torneo
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
            ),

            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sport,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$startDate - $endDate",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_teams.isNotEmpty) ..[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: _teams.map((team) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.groups,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  team.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
