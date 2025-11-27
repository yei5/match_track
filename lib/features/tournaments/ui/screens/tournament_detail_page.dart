import 'package:flutter/foundation.dart';
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
      
      debugPrint('🔍 TOURNAMENT DEBUG:');
      debugPrint('   Tournament ID: ${widget.tournament['id']}');
      debugPrint('   Team1 ID from DB: $team1Id');
      debugPrint('   Team2 ID from DB: $team2Id');
      debugPrint('   Total teams loaded: ${allTeams.length}');
      
      List<Team> tournamentTeams = [];
      
      // Buscar team1
      if (team1Id != null && team1Id.isNotEmpty && team1Id != 'null') {
        final team = allTeams.where((t) => t.id == team1Id).firstOrNull;
        if (team != null) {
          tournamentTeams.add(team);
          debugPrint('   ✅ Found Team 1: ${team.name}');
        } else {
          debugPrint('   ❌ Team 1 not found in user teams');
        }
      } else {
        debugPrint('   ⚠️ Team1 ID is null or empty');
      }
      
      // Buscar team2
      if (team2Id != null && team2Id.isNotEmpty && team2Id != 'null' && team2Id != team1Id) {
        final team = allTeams.where((t) => t.id == team2Id).firstOrNull;
        if (team != null) {
          tournamentTeams.add(team);
          debugPrint('   ✅ Found Team 2: ${team.name}');
        } else {
          debugPrint('   ❌ Team 2 not found in user teams');
        }
      } else {
        debugPrint('   ⚠️ Team2 ID is null, empty, or same as Team1');
      }
      
      debugPrint('   📊 Total tournament teams: ${tournamentTeams.length}');

      setState(() {
        _teams = tournamentTeams;
        _loadingTeams = false;
      });
    } catch (e) {
      debugPrint('   ❌ ERROR loading teams: $e');
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
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _teams.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.textSecondary.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'No hay equipos inscritos en este torneo',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: _teams.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final team = entry.value;
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: AppColors.primary.withOpacity(0.3),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  team.name.substring(0, 1).toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    team.name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    team.category,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Equipo ${index + 1}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
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
