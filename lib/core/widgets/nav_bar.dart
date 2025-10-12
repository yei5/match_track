import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

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
            switch (index) {
              case 0:
                print('Control seleccionado');
                break;
              case 1:
                print('Torneos seleccionado');
                break;
              case 2:
                print('Inicio seleccionado');
                break;
              case 3:
                print('Equipos seleccionado');
                break;
              case 4:
                print('Perfil seleccionado');
                break;
            }
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
