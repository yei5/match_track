import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../bloc/match_controller.dart';
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
  }) {
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
              Icon(icon, color: Colors.white, size: 32),
              if (label != null) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
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
          padding: const EdgeInsets.all(20),
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
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Abrir diálogo de gol
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('⚽ Registrar Gol - Próximamente')),
                      );
                    },
                    label: '+1',
                  ),
                  // Tarjeta Roja
                  _actionButton(
                    icon: Icons.rectangle,
                    color: AppColors.redCard,
                    onTap: () {
                      // TODO: Abrir diálogo de tarjeta roja
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🟥 Tarjeta Roja - Próximamente')),
                      );
                    },
                  ),
                  // Tarjeta Amarilla
                  _actionButton(
                    icon: Icons.rectangle,
                    color: AppColors.yellowCard,
                    onTap: () {
                      // TODO: Abrir diálogo de tarjeta amarilla
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🟨 Tarjeta Amarilla - Próximamente')),
                      );
                    },
                  ),
                  // Sustitución
                  _actionButton(
                    icon: Icons.sync_alt,
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Abrir diálogo de sustitución
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🔄 Sustitución - Próximamente')),
                      );
                    },
                  ),
                  // Interrupción
                  _actionButton(
                    icon: Icons.pan_tool,
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Abrir diálogo de interrupción
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🤚 Interrupción - Próximamente')),
                      );
                    },
                  ),
                  // Fin de Tiempo
                  _actionButton(
                    icon: Icons.access_time,
                    color: AppColors.primary,
                    onTap: () {
                      controller.endHalfTime();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            match.currentHalf == HalfTime.secondHalf
                                ? '⏱️ Segundo Tiempo'
                                : '🏁 Fin del Partido',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
