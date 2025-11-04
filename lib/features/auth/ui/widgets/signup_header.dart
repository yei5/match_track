import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:match_track/core/theme/app_colors.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textPrimary,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      child: Column(
        children: [
          SvgPicture.asset('assets/full_logo.svg', height: 70),
          const SizedBox(height: 16),
          const Text(
            '¡Bienvenido!',
            style: TextStyle(
              color: AppColors.background,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Regístrate y forma parte de la comunidad.',
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
