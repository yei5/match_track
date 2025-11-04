import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';

class SignupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String title;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const SignupTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.title,
    required this.icon,
    this.validator,
    this.obscureText = false,
  });

  @override
 Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
color: AppColors.textPrimary
            
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w100,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.textPrimary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
