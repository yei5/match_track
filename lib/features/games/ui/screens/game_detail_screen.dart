import 'package:flutter/material.dart';
import '../../domain/models/game_model.dart';
import '../../../match/ui/widgets/events_timeline.dart';
import '../../../../core/theme/app_colors_new.dart';

class GameDetailScreen extends StatelessWidget {
  final GameModel game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Información del Partido'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Match Header
            _buildMatchHeader(),

            const SizedBox(height: 20),

            // Statistics
            if (game.statistics != null) _buildStatistics(),

            const SizedBox(height: 20),

            // Events Timeline
            _buildEventsSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    Color borderColor;
    String statusText;

    switch (game.status) {
      case GameStatus.live:
        borderColor = const Color(0xFF10B981);
        statusText = "Min ${game.currentMinute}'";
        break;
      case GameStatus.finished:
        borderColor = const Color(0xFFEF4444);
        statusText = 'Finalizado';
        break;
      case GameStatus.scheduled:
        borderColor = const Color(0xFF6B7280);
        statusText = 'Programado';
        break;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tournament Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 16, color: borderColor),
                const SizedBox(width: 6),
                Text(
                  game.tournamentName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (game.isLive)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Teams and Score
          Row(
            children: [
              // Home Team
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.homeTeam.withOpacity(0.1),
                      child: Text(
                        game.homeTeam.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.homeTeam,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      game.homeTeam.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.homeScore.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homeTeam,
                      ),
                    ),
                  ],
                ),
              ),

              // Separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textLight,
                  ),
                ),
              ),

              // Away Team
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.awayTeam.withOpacity(0.1),
                      child: Text(
                        game.awayTeam.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.awayTeam,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      game.awayTeam.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.awayScore.toString(),
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
    );
  }

  Widget _buildStatistics() {
    final stats = game.statistics!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas Importantes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow('Goles', '${stats.homeGoals}', '${stats.awayGoals}',
            homeHighlight: stats.homeGoals > stats.awayGoals,
            awayHighlight: stats.awayGoals > stats.homeGoals),
          _buildStatRow('Tarjetas Amarillas', '${stats.homeYellowCards}', '${stats.awayYellowCards}'),
          _buildStatRow('Tarjetas Rojas', '${stats.homeRedCards}', '${stats.awayRedCards}'),
          _buildStatRow('Faltas', '${stats.homeFouls}', '${stats.awayFouls}'),
          _buildStatRow('Fueras de Juego', '${stats.homeOffsides}', '${stats.awayOffsides}'),
          _buildStatRow('Lesiones', '${stats.homeInjuries}', '${stats.awayInjuries}'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String homeValue, String awayValue, {bool homeHighlight = false, bool awayHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              homeValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: homeHighlight ? const Color(0xFFEF4444) : AppColors.textDark,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              awayValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: awayHighlight ? const Color(0xFFEF4444) : AppColors.textDark,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    if (game.events.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'No hay eventos registrados',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            events: game.events,
            homeTeam: game.homeTeam,
            awayTeam: game.awayTeam,
          ),
        ],
      ),
    );
  }
}
