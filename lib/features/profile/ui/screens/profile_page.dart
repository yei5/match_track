import 'package:flutter/material.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/nav_bar.dart';
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
