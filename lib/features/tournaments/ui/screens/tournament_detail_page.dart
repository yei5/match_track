import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TournamentDetailPage extends StatelessWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailPage({Key? key, required this.tournament})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = tournament['image_url'];
    final name = tournament['name'] ?? 'Sin nombre';
    final description = tournament['description'] ?? 'Sin descripción';
    final sport = tournament['sport'] ?? 'N/A';
    final category = tournament['category'] ?? 'N/A';
    final status = tournament['status'] ?? 'Desconocido';
    final startDate = tournament['start_date'] ?? '---';
    final endDate = tournament['end_date'] ?? '---';
    final teamA = tournament['team_a'] ?? 'Equipo A';
    final teamB = tournament['team_b'] ?? 'Equipo B';

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del torneo
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Deporte', sport),
                  _buildInfoRow('Categoría', category),
                  _buildInfoRow('Estado', status),
                  _buildInfoRow('Fecha de inicio', startDate),
                  _buildInfoRow('Fecha de fin', endDate),
                  const Divider(height: 32),
                  const Text(
                    'Equipos participantes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildTeams(teamA, teamB),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildTeams(String teamA, String teamB) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTeamBadge(teamA),
        const Text(
          'VS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildTeamBadge(teamB),
      ],
    );
  }

  Widget _buildTeamBadge(String team) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Text(
        team,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
