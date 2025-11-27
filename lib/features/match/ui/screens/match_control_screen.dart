import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../bloc/match_controller.dart';
import '../widgets/goal_dialog.dart';
import '../widgets/card_dialog.dart';
import '../widgets/substitution_dialog.dart';
import '../widgets/interruption_dialog.dart';
import '../widgets/match_statistics_widget.dart';
import '../services/match_pdf_service.dart';
import '../../../../core/theme/app_colors_new.dart';
import '../../../../core/domain/model/player.dart' as CorePlayer;
import '../../../players/data/repository/player_repository_impl.dart';
import '../../../players/data/source/player_remote_data_source.dart';
import '../../../tournaments/data/repository/tournament_repository_impl.dart';
import '../../../tournaments/data/source/tournament_remote_data_source.dart';
import '../../../tournaments/domain/entities/tournament_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchControlScreen extends StatefulWidget {
  final MatchModel match;

  const MatchControlScreen({super.key, required this.match});

  @override
  State<MatchControlScreen> createState() => _MatchControlScreenState();
}

class _MatchControlScreenState extends State<MatchControlScreen> {
  late MatchController controller;
  final _playerRepository = PlayerRepositoryImpl(remoteDataSource: PlayerRemoteDataSourceImpl());
  final _tournamentRepository = TournamentRepositoryImpl(
    remoteDataSource: TournamentRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    ),
  );
  
  List<CorePlayer.Player> _homePlayers = [];
  List<CorePlayer.Player> _awayPlayers = [];
  TournamentEntity? _tournament;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    controller = MatchController(match: widget.match);
    _loadPlayers();
    _loadTournament();
  }

  Future<void> _loadPlayers() async {
    try {
      final homePlayers = await _playerRepository.getPlayersForTeam(widget.match.homeTeam.id);
      final awayPlayers = await _playerRepository.getPlayersForTeam(widget.match.awayTeam.id);
      
      setState(() {
        _homePlayers = homePlayers;
        _awayPlayers = awayPlayers;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando jugadores: $e')),
        );
      }
    }
  }

  Future<void> _loadTournament() async {
    if (widget.match.tournamentId == null) return;
    
    try {
      final tournament = await _tournamentRepository.getTournamentDetail(widget.match.tournamentId!);
      setState(() => _tournament = tournament);
    } catch (e) {
      // No mostrar error si no se encuentra el torneo
    }
  }

  Future<void> _downloadPdf() async {
    setState(() => _isGeneratingPdf = true);
    
    try {
      await MatchPdfService.downloadMatchReport(
        match: controller.match,
        statistics: controller.statistics,
        tournamentName: _tournament?.name,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generado exitosamente'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar el PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? label,
    Color? iconColor,
  }) {
    // Determinar si el botón es claro o oscuro
    final bool isDark = color == const Color(0xFF292D32);
    final bool isGray = color == const Color(0xFF9CA3AF);
    
    final Color finalIconColor = iconColor ?? 
      (isDark || isGray ? Colors.white : 
       color == const Color(0xFFE63946) || color == const Color(0xFFF59E0B) ? Colors.white : 
       const Color(0xFF6B7280));
    
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: finalIconColor, size: 32),
              if (label != null) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: finalIconColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Control de Partido'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Marcador
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Nombre del torneo o Amistoso
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _tournament != null ? Icons.emoji_events : Icons.handshake,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _tournament?.name ?? 'Amistoso',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Equipo Local
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  widget.match.homeTeam.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.match.homeScore.toString(),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.homeTeam,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Separador
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          
                          // Equipo Visitante
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  widget.match.awayTeam.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.match.awayScore.toString(),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.awayTeam,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Cronómetro
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.timer,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.formattedTime,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botón único de control de tiempos
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  String buttonText;
                  IconData buttonIcon;
                  Color buttonColor;
                  VoidCallback onPressed;

                  switch (controller.match.currentHalf) {
                    case HalfTime.firstHalf:
                      if (controller.match.elapsedSeconds == 0) {
                        // Partido no iniciado
                        buttonText = 'Iniciar Partido';
                        buttonIcon = Icons.play_arrow;
                        buttonColor = const Color(0xFF10B981); // Verde
                        onPressed = () {
                          controller.start();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('⚽ Primer Tiempo Iniciado')),
                          );
                        };
                      } else {
                        // Primer tiempo en curso
                        buttonText = 'Finalizar Primer Tiempo';
                        buttonIcon = Icons.pause_circle_filled;
                        buttonColor = const Color(0xFFF59E0B); // Amarillo
                        onPressed = () {
                          controller.endHalfTime();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('⏸️ Entretiempo - Cronómetro pausado')),
                          );
                        };
                      }
                      break;
                    case HalfTime.halftime:
                      buttonText = 'Iniciar Segundo Tiempo';
                      buttonIcon = Icons.play_arrow;
                      buttonColor = const Color(0xFF10B981); // Verde
                      onPressed = () {
                        controller.endHalfTime();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('▶️ Segundo Tiempo - Cronómetro reanudado')),
                        );
                      };
                      break;
                    case HalfTime.secondHalf:
                      buttonText = 'Finalizar Partido';
                      buttonIcon = Icons.stop_circle;
                      buttonColor = const Color(0xFFEF4444); // Rojo
                      onPressed = () {
                        controller.endHalfTime();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🏁 Fin del Partido')),
                        );
                      };
                      break;
                    default:
                      buttonText = 'Partido Finalizado';
                      buttonIcon = Icons.check_circle;
                      buttonColor = Colors.grey;
                      onPressed = () {};
                  }

                  return ElevatedButton.icon(
                    onPressed: controller.match.currentHalf == HalfTime.finished ? null : onPressed,
                    icon: Icon(buttonIcon, size: 28),
                    label: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Acciones
              const Text(
                'Acciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              
              // Primera fila: Gol, Tarjeta Roja, Tarjeta Amarilla
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gol
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _actionButton(
                      icon: Icons.sports_soccer,
                      color: const Color(0xFF00FF00), // Verde brillante
                      iconColor: Colors.black,
                      onTap: () async {
                        final event = await showDialog<MatchEventDetail>(
                          context: context,
                          builder: (context) => GoalDialog(
                            homeTeam: controller.match.homeTeam,
                            awayTeam: controller.match.awayTeam,
                            homePlayers: _homePlayers,
                            awayPlayers: _awayPlayers,
                            currentMinute: controller.currentMinute,
                          ),
                        );
                        if (event != null) {
                          controller.addDetailedEvent(event);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('⚽ Gol registrado - Minuto ${event.minute}')),
                            );
                          }
                        }
                      },
                      label: '+1',
                    ),
                  ),
                  // Tarjeta Roja
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _actionButton(
                      icon: Icons.rectangle,
                      color: const Color(0xFFE63946), // Rojo
                      onTap: () async {
                        final event = await showDialog<MatchEventDetail>(
                          context: context,
                          builder: (context) => CardDialog(
                            homeTeam: controller.match.homeTeam,
                            awayTeam: controller.match.awayTeam,
                            homePlayers: _homePlayers,
                            awayPlayers: _awayPlayers,
                            currentMinute: controller.currentMinute,
                            isRed: true,
                          ),
                        );
                        if (event != null) {
                          controller.addDetailedEvent(event);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('🟥 Tarjeta roja - Minuto ${event.minute}')),
                            );
                          }
                        }
                      },
                      label: '+1',
                    ),
                  ),
                  // Tarjeta Amarilla
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _actionButton(
                      icon: Icons.rectangle,
                      color: const Color(0xFFF59E0B), // Naranja/Amarillo
                      onTap: () async {
                        final event = await showDialog<MatchEventDetail>(
                          context: context,
                          builder: (context) => CardDialog(
                            homeTeam: controller.match.homeTeam,
                            awayTeam: controller.match.awayTeam,
                            homePlayers: _homePlayers,
                            awayPlayers: _awayPlayers,
                            currentMinute: controller.currentMinute,
                            isRed: false,
                          ),
                        );
                        if (event != null) {
                          controller.addDetailedEvent(event);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('🟨 Tarjeta amarilla - Minuto ${event.minute}')),
                            );
                          }
                        }
                      },
                      label: '+1',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Segunda fila: Sustitución e Interrupción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Sustitución
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _actionButton(
                      icon: Icons.swap_horiz_rounded,
                      color: const Color(0xFF292D32), // Gris oscuro
                      onTap: () async {
                        final event = await showDialog<MatchEventDetail>(
                          context: context,
                          builder: (context) => SubstitutionDialog(
                            homeTeam: controller.match.homeTeam,
                            awayTeam: controller.match.awayTeam,
                            homePlayers: _homePlayers,
                            awayPlayers: _awayPlayers,
                            currentMinute: controller.currentMinute,
                          ),
                        );
                        if (event != null) {
                          controller.addDetailedEvent(event);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('🔄 Sustitución - Minuto ${event.minute}')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  // Interrupción
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _actionButton(
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFF9CA3AF), // Gris
                      onTap: () async {
                        final event = await showDialog<MatchEventDetail>(
                          context: context,
                          builder: (context) => InterruptionDialog(
                            homeTeam: controller.match.homeTeam,
                            awayTeam: controller.match.awayTeam,
                            homePlayers: _homePlayers,
                            awayPlayers: _awayPlayers,
                            currentMinute: controller.currentMinute,
                          ),
                        );
                        if (event != null) {
                          controller.addDetailedEvent(event);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('🤚 ${event.displayText} - Minuto ${event.minute}')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Estadísticas del partido
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  return MatchStatisticsWidget(
                    statistics: controller.statistics,
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón de guardar partido
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await controller.stop();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Partido guardado'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.save_rounded, size: 20),
                      label: const Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Botón de descargar PDF
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isGeneratingPdf ? null : _downloadPdf,
                      icon: _isGeneratingPdf
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.download_rounded, size: 20),
                      label: Text(
                        _isGeneratingPdf ? 'Generando...' : 'Descargar PDF',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                        disabledForegroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Espacio final para scroll completo
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
