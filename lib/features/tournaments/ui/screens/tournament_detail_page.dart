import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/features/teams/data/source/team_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentDetailPage extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailPage({super.key, required this.tournament});

  @override
  State<TournamentDetailPage> createState() => _TournamentDetailPageState();
}

class _TournamentDetailPageState extends State<TournamentDetailPage> {
  bool _isDeleting = false;
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

      // Cargar todos los equipos del usuario
      final allTeams = await _teamRepository.getTeams(userId);
      
      // Filtrar equipos que participan en este torneo
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
                        const SizedBox(height: 12),
                        _loadingTeams
                            ? const Center(child: CircularProgressIndicator())
                            : _teams.isEmpty
                                ? const Text(
                                    'No hay equipos registrados en este torneo',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                : Column(
                                    children: _teams.map((team) {
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: AppColors.primary.withOpacity(0.1),
                                          border: Border.all(
                                            color: AppColors.primary.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.groups,
                                              color: AppColors.primary,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                team.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
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
}
