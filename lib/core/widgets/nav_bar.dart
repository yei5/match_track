import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/control');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tournaments');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/teams');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 90,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            _navigate(context, index);
            onTap(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 24,
          unselectedIconTheme: const IconThemeData(size: 28),
          selectedIconTheme: const IconThemeData(size: 32),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_outlined),
              activeIcon: Icon(Icons.note_alt),
              label: 'Control',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'Torneos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'Equipos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
