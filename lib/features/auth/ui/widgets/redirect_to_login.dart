import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:match_track/core/presentation/app_theme.dart';

class RedirectToLogin extends StatelessWidget {
  final VoidCallback onLoginTap;

  const RedirectToLogin({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "¿Ya tienes cuenta? ",
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: "Inicia sesión",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onLoginTap,
            ),
          ],
        ),
      ),
    );
  }
}
