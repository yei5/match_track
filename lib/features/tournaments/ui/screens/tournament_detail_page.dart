import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/source/tournament_remote_data_source.dart';
import '../../data/repository/tournament_repository_impl.dart';
import '../../domain/usecases/get_tournament_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentDetailPage extends StatefulWidget {
  final Map<String, dynamic>? tournamentArg;

  const TournamentDetailPage({
    Key? key,
    this.tournamentArg,
    required Map tournament,
  }) : super(key: key);

  @override
  State<TournamentDetailPage> createState() => _TournamentDetailPageState();
}

class _TournamentDetailPageState extends State<TournamentDetailPage> {
  Map<String, dynamic>? tournament;
  bool isLoading = true;

  late final GetTournamentDetail _getTournamentDetail;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final remote = TournamentRemoteDataSource(client);
    final repo = TournamentRepositoryImpl(remoteDataSource: remote);
    _getTournamentDetail = GetTournamentDetail(repo);

    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => isLoading = true);

    // Si ya llega el argumento con todo, lo mostramos; si llega solo id, pedimos al usecase.
    final arg = widget.tournamentArg;
    if (arg != null && arg['id'] != null) {
      // Intentamos cargar detalle desde remote para mantener consistencia
      final id = arg['id'].toString();
      final result = await _getTournamentDetail(id);
      if (result != null) {
        tournament = {
          'id': result.id,
          'name': result.name,
          'description': result.description,
          'sport': result.sport,
          'image_url': result.imageUrl,
          'status': result.status,
          'start_date': result.startDate,
          'end_date': result.endDate,
          'team_a': result.teamA,
          'team_b': result.teamB,
        };
      } else {
        tournament = arg;
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = tournament?['image_url'];
    final name = tournament?['name'] ?? 'Sin nombre';
    final description = tournament?['description'] ?? 'Sin descripción';
    final sport = tournament?['sport'] ?? 'N/A';
    final category = tournament?['category'] ?? 'N/A';
    final status = tournament?['status'] ?? 'Desconocido';
    final startDate = tournament?['start_date'] ?? '---';
    final endDate = tournament?['end_date'] ?? '---';
    final teamA = tournament?['team_a'] ?? 'Equipo A';
    final teamB = tournament?['team_b'] ?? 'Equipo B';

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl != null && imageUrl.toString().isNotEmpty
                      ? Image.network(
                          imageUrl.toString(),
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
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
