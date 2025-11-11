import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTeamCard extends StatelessWidget {
  final String teamName;

  const CustomTeamCard({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            color: AppColors.textPrimary,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
