import 'package:flutter/material.dart';
import '../../../teams/data/source/team_remote_data_source.dart';
import '../../../teams/data/repository/team_repository_impl.dart';
import '../../../teams/domain/usecases/get_teams.dart';
import '../../../../core/domain/model/team.dart';
import '../../../../core/theme/app_colors_new.dart';
import '../../domain/models/match_model.dart';
import 'match_control_screen.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  List<Team> _teams = [];
  bool _isLoading = true;
  Team? _homeTeam;
  Team? _awayTeam;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() => _isLoading = true);
    try {
      final teamRemoteDataSource = TeamRemoteDataSourceImpl();
      final teamRepository = TeamRepositoryImpl(remoteDataSource: teamRemoteDataSource);
      final getTeams = GetTeams(repository: teamRepository);
      
      // GetTeams requiere userId - usar un ID temporal o vacío
      final teams = await getTeams.call('temp-user-id');
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando equipos: $e')),
        );
      }
    }
  }

  void _startMatch() {
    if (_homeTeam == null || _awayTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar ambos equipos')),
      );
      return;
    }

    if (_homeTeam!.id == _awayTeam!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los equipos deben ser diferentes')),
      );
      return;
    }

    // Crear el partido directamente con Team
    final match = MatchModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      homeTeam: _homeTeam!,
      awayTeam: _awayTeam!,
    );

    // Navegar a la pantalla de control
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MatchControlScreen(match: match),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crear Partido'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teams.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Selecciona los equipos que jugarán',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Equipo Local
                      _buildTeamSelector(
                        label: 'Equipo Local',
                        selectedTeam: _homeTeam,
                        color: AppColors.homeTeam,
                        onSelect: (team) => setState(() => _homeTeam = team),
                      ),

                      const SizedBox(height: 32),

                      // VS
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Equipo Visitante
                      _buildTeamSelector(
                        label: 'Equipo Visitante',
                        selectedTeam: _awayTeam,
                        color: AppColors.awayTeam,
                        onSelect: (team) => setState(() => _awayTeam = team),
                      ),

                      const SizedBox(height: 48),

                      // Botón Iniciar Partido
                      ElevatedButton(
                        onPressed: _startMatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sports_soccer, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Iniciar Partido',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTeamSelector({
    required String label,
    required Team? selectedTeam,
    required Color color,
    required Function(Team) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedTeam != null ? color : AppColors.textLight.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Team>(
              value: selectedTeam,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Selecciona un equipo',
                  style: TextStyle(color: AppColors.textLight),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: BorderRadius.circular(16),
              icon: Icon(Icons.arrow_drop_down, color: color),
              items: _teams.map((team) {
                return DropdownMenuItem<Team>(
                  value: team,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: color.withOpacity(0.1),
                        child: Text(
                          team.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (team) {
                if (team != null) onSelect(team);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay equipos creados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea equipos primero para iniciar un partido',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/teams'),
            icon: const Icon(Icons.add),
            label: const Text('Ir a Equipos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
