import 'package:flutter/material.dart';
import '../../core/theme/app_colors_new.dart';

class StandardNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const StandardNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight.withOpacity(0.6),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: 'Partidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Torneos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield),
          label: 'Equipos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
