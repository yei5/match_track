import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../bloc/match_controller.dart';
import '../widgets/goal_dialog.dart';
import '../widgets/card_dialog.dart';
import '../widgets/substitution_dialog.dart';
import '../widgets/interruption_dialog.dart';
import '../widgets/events_timeline.dart';
import '../../../../core/theme/app_colors_new.dart';

class MatchControlScreen extends StatefulWidget {
  final MatchModel match;

  const MatchControlScreen({super.key, required this.match});

  @override
  State<MatchControlScreen> createState() => _MatchControlScreenState();
}

class _MatchControlScreenState extends State<MatchControlScreen> {
  late MatchController controller;

  @override
  void initState() {
    super.initState();
    controller = MatchController(match: widget.match);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
      ),
    );
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
                  child: Row(
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
              
              // Controles del Juego
              const Text(
                'Control del Juego',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _controlButton(Icons.play_arrow, () => controller.start()),
                  _controlButton(Icons.pause, () => controller.pause()),
                  _controlButton(Icons.stop, () => controller.stop(reset: false)),
                ],
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
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  // Gol
                  _actionButton(
                    icon: Icons.sports_soccer,
                    color: const Color(0xFFE63946), // Rojo intenso
                    onTap: () async {
                      final event = await showDialog<MatchEventDetail>(
                        context: context,
                        builder: (context) => GoalDialog(
                          homeTeam: controller.match.homeTeam,
                          awayTeam: controller.match.awayTeam,
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
                  // Tarjeta Roja
                  _actionButton(
                    icon: Icons.rectangle,
                    color: const Color(0xFFE63946), // Rojo
                    onTap: () async {
                      final event = await showDialog<MatchEventDetail>(
                        context: context,
                        builder: (context) => CardDialog(
                          homeTeam: controller.match.homeTeam,
                          awayTeam: controller.match.awayTeam,
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
                  // Tarjeta Amarilla
                  _actionButton(
                    icon: Icons.rectangle,
                    color: const Color(0xFFF59E0B), // Naranja/Amarillo
                    onTap: () async {
                      final event = await showDialog<MatchEventDetail>(
                        context: context,
                        builder: (context) => CardDialog(
                          homeTeam: controller.match.homeTeam,
                          awayTeam: controller.match.awayTeam,
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
                  ),
                  // Sustitución
                  _actionButton(
                    icon: Icons.swap_horiz_rounded,
                    color: const Color(0xFF292D32), // Gris oscuro
                    onTap: () async {
                      final event = await showDialog<MatchEventDetail>(
                        context: context,
                        builder: (context) => SubstitutionDialog(
                          homeTeam: controller.match.homeTeam,
                          awayTeam: controller.match.awayTeam,
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
                    label: '+1',
                  ),
                  // Interrupción
                  _actionButton(
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFF9CA3AF), // Gris
                    onTap: () async {
                      final event = await showDialog<MatchEventDetail>(
                        context: context,
                        builder: (context) => InterruptionDialog(
                          homeTeam: controller.match.homeTeam,
                          awayTeam: controller.match.awayTeam,
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
                  // Fin de Tiempo
                  _actionButton(
                    icon: Icons.circle_outlined,
                    color: const Color(0xFF292D32), // Gris oscuro
                    onTap: () {
                      controller.endHalfTime();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            controller.match.currentHalf == HalfTime.secondHalf
                                ? '⏱️ Segundo Tiempo'
                                : '🏁 Fin del Partido',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Timeline de eventos
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  if (controller.match.detailedEvents.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
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
                      child: const Center(
                        child: Text(
                          'No hay eventos registrados aún',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eventos del Partido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      EventsTimeline(
                        events: controller.sortedEvents,
                        homeTeam: controller.match.homeTeam,
                        awayTeam: controller.match.awayTeam,
                      ),
                    ],
                  );
                },
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
