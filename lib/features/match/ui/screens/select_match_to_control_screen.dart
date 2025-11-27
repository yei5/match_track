import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/match_model.dart';
import '../../data/repository/match_repository.dart';
import 'match_control_screen.dart';
import '../../../../core/theme/app_colors_new.dart';

class SelectMatchToControlScreen extends StatefulWidget {
  const SelectMatchToControlScreen({super.key});

  @override
  State<SelectMatchToControlScreen> createState() => _SelectMatchToControlScreenState();
}

class _SelectMatchToControlScreenState extends State<SelectMatchToControlScreen> {
  final _matchRepository = MatchRepository();
  List<MatchModel> _scheduledMatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScheduledMatches();
  }

  Future<void> _loadScheduledMatches() async {
    setState(() => _isLoading = true);
    try {
      final matches = await _matchRepository.getScheduledMatches();
      setState(() {
        _scheduledMatches = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando partidos: $e')),
        );
      }
    }
  }

  void _startControl(MatchModel match) {
    // Cambiar el estado del partido a idle (listo para iniciar)
    match.status = MatchStatus.idle;
    
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
        title: const Text('Seleccionar Partido a Controlar'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scheduledMatches.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadScheduledMatches,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _scheduledMatches.length,
                    itemBuilder: (context, index) {
                      final match = _scheduledMatches[index];
                      return _buildMatchCard(match);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay partidos agendados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agenda un partido primero',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/schedule-match'),
            icon: const Icon(Icons.add),
            label: const Text('Agendar Partido'),
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

  Widget _buildMatchCard(MatchModel match) {
    final scheduledDate = match.scheduledDate ?? DateTime.now();
    final isToday = DateFormat('yyyy-MM-dd').format(scheduledDate) == 
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday ? const Color(0xFF10B981) : AppColors.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isToday ? const Color(0xFF10B981) : AppColors.primary).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startControl(match),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Fecha y hora
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'HOY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (!isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      DateFormat('EEEE, d MMMM', 'es').format(scheduledDate),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Hora
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('HH:mm').format(scheduledDate),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Equipos
                Row(
                  children: [
                    // Equipo Local
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.homeTeam.withOpacity(0.1),
                            child: Text(
                              match.homeTeam.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.homeTeam,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            match.homeTeam.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // VS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    
                    // Equipo Visitante
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.awayTeam.withOpacity(0.1),
                            child: Text(
                              match.awayTeam.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.awayTeam,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            match.awayTeam.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Botón de iniciar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFF10B981) : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.play_arrow, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Iniciar Control',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
