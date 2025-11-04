import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';

class RedirectToSignup extends StatelessWidget {
  final VoidCallback onSignupTap;

  const RedirectToSignup({super.key, required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSignupTap,
      child: const Center(
        child: Text.rich(
          TextSpan(
            text: '¿No tienes cuenta? ',
            style: TextStyle(color: AppColors.textSecondary),
            children: [
              TextSpan(
                text: 'Regístrate',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
