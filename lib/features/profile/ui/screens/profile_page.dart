// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/header.dart';
import '../../../../core/widgets/nav_bar.dart';
import '../widgets/profile_content.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Perfil'),
      body: const SafeArea(child: PerfilContent()),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
