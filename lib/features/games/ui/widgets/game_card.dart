import 'package:flutter/material.dart';
import '../../domain/models/game_model.dart';
import '../../../../core/theme/app_colors_new.dart';
import 'package:intl/intl.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  String get _statusText {
    // Solo mostrar "Finalizado" ya que todos los partidos están finalizados
    return 'Finalizado';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Tournament Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      game.tournamentName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Match Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Teams and Score
                  Row(
                    children: [
                      // Home Team
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.homeTeam.withOpacity(0.1),
                              child: Text(
                                game.homeTeam.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.homeTeam,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              game.homeTeam.name,
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

                      // Score
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  game.homeScore.toString(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: game.isLive || game.isFinished
                                        ? AppColors.homeTeam
                                        : AppColors.textLight,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ),
                                Text(
                                  game.awayScore.toString(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: game.isLive || game.isFinished
                                        ? AppColors.awayTeam
                                        : AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Away Team
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.awayTeam.withOpacity(0.1),
                              child: Text(
                                game.awayTeam.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.awayTeam,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              game.awayTeam.name,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
