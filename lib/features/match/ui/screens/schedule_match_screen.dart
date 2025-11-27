import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/match_model.dart';
import '../../../../core/domain/model/team.dart';
import '../../../teams/data/repository/team_repository_impl.dart';
import '../../../teams/data/source/team_remote_data_source.dart';
import '../../../tournaments/data/repository/tournament_repository_impl.dart';
import '../../../tournaments/data/source/tournament_remote_data_source.dart';
import '../../../tournaments/domain/entities/tournament_entity.dart';
import '../../data/repository/match_repository.dart';
import '../../../../core/theme/app_colors_new.dart';
import '../../../../core/widgets/standard_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleMatchScreen extends StatefulWidget {
  const ScheduleMatchScreen({super.key});

  @override
  State<ScheduleMatchScreen> createState() => _ScheduleMatchScreenState();
}

class _ScheduleMatchScreenState extends State<ScheduleMatchScreen> {
  final _teamRepository = TeamRepositoryImpl(remoteDataSource: TeamRemoteDataSourceImpl());
  final _tournamentRepository = TournamentRepositoryImpl(remoteDataSource: TournamentRemoteDataSourceImpl());
  final _matchRepository = MatchRepository();
  
  List<Team> _teams = [];
  List<TournamentEntity> _tournaments = [];
  bool _isLoading = true;
  
  Team? _selectedHomeTeam;
  Team? _selectedAwayTeam;
  TournamentEntity? _selectedTournament;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isFriendly = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final teams = await _teamRepository.getTeams(userId);
      final tournaments = await _tournamentRepository.getTournaments(userId);
      
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _scheduleMatch() async {
    // Validaciones
    if (_selectedHomeTeam == null || _selectedAwayTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar ambos equipos')),
      );
      return;
    }

    if (_selectedHomeTeam!.id == _selectedAwayTeam!.id) {
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

    try {
      // Combinar fecha y hora
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Crear el partido
      final match = MatchModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        homeTeam: _selectedHomeTeam!,
        awayTeam: _selectedAwayTeam!,
        status: MatchStatus.scheduled,
        scheduledDate: scheduledDateTime,
        tournamentId: _isFriendly ? null : _selectedTournament?.id,
      );

      // Guardar el partido
      await _matchRepository.saveMatch(match);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Partido agendado exitosamente'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agendar partido: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Agendar Partido'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_teams.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Agendar Partido'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
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
                'No hay equipos disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Crea equipos primero para agendar partidos',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight.withOpacity(0.7),
                ),
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
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agendar Partido'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de equipos
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sports_soccer, color: AppColors.primary, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Equipos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Equipo Local
                  const Text(
                    'Equipo Local',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Team>(
                        isExpanded: true,
                        value: _selectedHomeTeam,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Seleccionar equipo local'),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        borderRadius: BorderRadius.circular(12),
                        items: _teams.map<DropdownMenuItem<Team>>((team) {
                          return DropdownMenuItem<Team>(
                            value: team,
                            child: Text(team.name),
                          );
                        }).toList(),
                        onChanged: (team) => setState(() => _selectedHomeTeam = team),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Equipo Visitante
                  const Text(
                    'Equipo Visitante',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.awayTeam.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Team>(
                        isExpanded: true,
                        value: _selectedAwayTeam,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Seleccionar equipo visitante'),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        borderRadius: BorderRadius.circular(12),
                        items: _teams.map<DropdownMenuItem<Team>>((team) {
                          return DropdownMenuItem<Team>(
                            value: team,
                            child: Text(team.name),
                          );
                        }).toList(),
                        onChanged: (team) => setState(() => _selectedAwayTeam = team),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta de tipo de partido
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: AppColors.primary, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Tipo de Partido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Amistoso',
                                  style: TextStyle(
                                    fontSize: 16,
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Torneo',
                                  style: TextStyle(
                                    fontSize: 16,
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
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tarjeta de fecha y hora
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Fecha y Hora',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Fecha
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy', 'es').format(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Hora
                  InkWell(
                    onTap: _selectTime,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hora',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botón de agendar
            ElevatedButton(
              onPressed: _scheduleMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Agendar Partido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: StandardNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/games');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/tournaments');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/teams');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
