import 'package:flutter/material.dart';
import '../../../teams/data/source/team_remote_data_source.dart';
import '../../../teams/data/repository/team_repository_impl.dart';
import '../../../teams/domain/usecases/get_teams.dart';
import '../../../tournaments/data/repository/tournament_repository_impl.dart';
import '../../../tournaments/data/source/tournament_remote_data_source.dart';
import '../../../tournaments/domain/entities/tournament_entity.dart';
import '../../../../core/domain/model/team.dart';
import '../../../../core/theme/app_colors_new.dart';
import '../../domain/models/match_model.dart';
import 'match_control_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  List<Team> _teams = [];
  List<TournamentEntity> _tournaments = [];
  bool _isLoading = true;
  Team? _homeTeam;
  Team? _awayTeam;
  TournamentEntity? _selectedTournament;
  bool _isFriendly = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final teamRemoteDataSource = TeamRemoteDataSourceImpl();
      final teamRepository = TeamRepositoryImpl(remoteDataSource: teamRemoteDataSource);
      final getTeams = GetTeams(repository: teamRepository);
      
      final tournamentRepository = TournamentRepositoryImpl(
        remoteDataSource: TournamentRemoteDataSourceImpl(
          supabaseClient: Supabase.instance.client,
        ),
      );
      
      final teams = await getTeams.call(userId);
      final tournaments = await tournamentRepository.getTournaments(userId);
      
      setState(() {
        _teams = teams;
        _tournaments = tournaments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando datos: $e')),
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

    if (!_isFriendly && _selectedTournament == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar un torneo')),
      );
      return;
    }

    // Crear el partido directamente con Team
    final match = MatchModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      homeTeam: _homeTeam!,
      awayTeam: _awayTeam!,
      tournamentId: _isFriendly ? null : _selectedTournament?.id,
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

                      const SizedBox(height: 32),

                      // Selector de tipo de partido
                      const Text(
                        'Tipo de Partido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                _isFriendly = true;
                                _selectedTournament = null;
                              }),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isFriendly ? AppColors.primary : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.handshake,
                                      color: _isFriendly ? Colors.white : AppColors.textLight,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Amistoso',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _isFriendly ? Colors.white : AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isFriendly = false),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isFriendly ? AppColors.primary : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.emoji_events,
                                      color: !_isFriendly ? Colors.white : AppColors.textLight,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Torneo',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: !_isFriendly ? Colors.white : AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Selector de torneo
                      if (!_isFriendly) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Seleccionar Torneo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<TournamentEntity>(
                              isExpanded: true,
                              value: _selectedTournament,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(_tournaments.isEmpty 
                                  ? 'No hay torneos disponibles' 
                                  : 'Seleccionar torneo'),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              borderRadius: BorderRadius.circular(12),
                              items: _tournaments.map<DropdownMenuItem<TournamentEntity>>((tournament) {
                                return DropdownMenuItem<TournamentEntity>(
                                  value: tournament,
                                  child: Text(tournament.name),
                                );
                              }).toList(),
                              onChanged: _tournaments.isEmpty 
                                ? null 
                                : (tournament) => setState(() => _selectedTournament = tournament),
                            ),
                          ),
                        ),
                      ],

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
