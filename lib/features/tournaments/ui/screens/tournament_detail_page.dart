import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentDetailPage extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailPage({super.key, required this.tournament});

  @override
  State<TournamentDetailPage> createState() => _TournamentDetailPageState();
}

class _TournamentDetailPageState extends State<TournamentDetailPage> {
  bool _isDeleting = false;

  Future<void> _deleteTournament() async {
    setState(() => _isDeleting = true);
    try {
      final tournamentId = widget.tournament['id'];
      if (tournamentId == null) {
        throw 'El ID del torneo no se encontró.';
      }

      await Supabase.instance.client
          .from('tournaments')
          .delete()
          .eq('id', tournamentId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Torneo eliminado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        // Pop once to go back to the tournament list
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar el torneo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este torneo? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteTournament();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.tournament['image_url'];
    final name = widget.tournament['name'] ?? 'Sin nombre';
    final description = widget.tournament['description'] ?? 'Sin descripción';
    final sport = widget.tournament['sport'] ?? 'N/A';
    final category = widget.tournament['category'] ?? 'N/A';
    final status = widget.tournament['status'] ?? 'Desconocido';
    final startDate = widget.tournament['start_date'] ?? '---';
    final endDate = widget.tournament['end_date'] ?? '---';
    final team1Id = widget.tournament['team1_id']?.toString() ?? 'Equipo 1';
    final team2Id = widget.tournament['team2_id']?.toString() ?? 'Equipo 2';

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tournament Image
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _buildTeams(team1Id, team2Id),
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
                    icon: _isDeleting
                        ? const SizedBox.shrink()
                        : const Icon(Icons.delete_forever),
                    label: _isDeleting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Borrar'),
                    onPressed: _isDeleting ? null : _showDeleteConfirmationDialog,
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
                      Navigator.pushNamed(context, '/editTournament',
                          arguments: widget.tournament);
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

  Widget _buildTeams(String team1Id, String team2Id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTeamBadge(team1Id),
        const Text(
          'VS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildTeamBadge(team2Id),
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
