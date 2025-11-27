import 'package:flutter/material.dart';
import '../../../games/domain/models/game_model.dart';
import '../../../../core/theme/app_colors_new.dart';

class MatchStatisticsWidget extends StatelessWidget {
  final GameStatistics statistics;

  const MatchStatisticsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Estadísticas del Partido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildStatisticBar(
            'Goles',
            statistics.homeGoals,
            statistics.awayGoals,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          
          _buildStatisticBar(
            'Tarjetas Amarillas',
            statistics.homeYellowCards,
            statistics.awayYellowCards,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 16),
          
          _buildStatisticBar(
            'Tarjetas Rojas',
            statistics.homeRedCards,
            statistics.awayRedCards,
            color: const Color(0xFFEF4444),
            maxValue: 5,
          ),
          const SizedBox(height: 16),
          
          _buildStatisticBar(
            'Faltas',
            statistics.homeFouls,
            statistics.awayFouls,
            maxValue: 30,
          ),
          const SizedBox(height: 16),
          
          _buildStatisticBar(
            'Fueras de juego',
            statistics.homeOffsides,
            statistics.awayOffsides,
          ),
          const SizedBox(height: 16),
          
          _buildStatisticBar(
            'Lesiones',
            statistics.homeInjuries,
            statistics.awayInjuries,
            color: const Color(0xFF6B7280),
            maxValue: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticBar(
    String label,
    int homeValue,
    int awayValue, {
    bool showPercentage = false,
    String? leftValue,
    String? rightValue,
    Color? color,
    int? maxValue,
  }) {
    final total = homeValue + awayValue;
    final homePercentage = total > 0 ? (homeValue / total) : 0.5;
    final awayPercentage = total > 0 ? (awayValue / total) : 0.5;
    
    final displayHomeValue = leftValue ?? homeValue.toString();
    final displayAwayValue = rightValue ?? awayValue.toString();
    
    final barColor = color ?? AppColors.primary;

    return Column(
      children: [
        // Label and values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              showPercentage ? '$displayHomeValue%' : displayHomeValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
            Text(
              showPercentage ? '$displayAwayValue%' : displayAwayValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Bar
        Row(
          children: [
            Expanded(
              flex: (homePercentage * 100).toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: (awayPercentage * 100).toInt(),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
