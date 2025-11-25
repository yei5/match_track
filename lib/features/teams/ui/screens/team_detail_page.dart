import 'package:flutter/material.dart';
import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/core/theme/app_colors.dart';

class TeamDetailPage extends StatelessWidget {
  final Team team;
  final List<Player> players;
  const TeamDetailPage({super.key, required this.team, required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(team.name), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Image
                  team.imageUrl != null && team.imageUrl!.isNotEmpty
                      ? Image.network(
                          team.imageUrl!,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          team.description,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Deporte', team.sport),
                        _buildInfoRow('Categoría', team.category),
                        const Divider(height: 32),
                        const Text(
                          'Jugadores',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        players.isEmpty
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Text('Este equipo aún no tiene jugadores.'),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: players.length,
                                itemBuilder: (context, index) {
                                  final player = players[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text(player.jersey_number),
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
                      // TODO: Implement delete team logic in BLoC
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
                      // TODO: Navigate to edit team page
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
