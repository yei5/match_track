import 'package:flutter/material.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/standard_nav_bar.dart';
import '../widgets/profile_content.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Perfil', showBackButton: false),
      body: const SafeArea(child: ProfileContent()),
      bottomNavigationBar: StandardNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/games');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/tournaments');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/teams');
              break;
            case 3:
              break; // Ya estamos aquí
          }
        },
      ),
    );
  }
}
