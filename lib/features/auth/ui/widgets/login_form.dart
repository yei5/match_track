import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/features/auth/ui/bloc/login_bloc.dart';
import 'package:match_track/features/auth/ui/widgets/login_button.dart';
import 'package:match_track/features/auth/ui/widgets/redirect_to_signup.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailErrorMessage;
  String? passwordErrorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/profile');
        } else if (state is LoginFailure) {
          setState(() {
            // Asigna el error al campo correcto según el field del estado
            emailErrorMessage = state.field == LoginErrorField.email
                ? state.message
                : null;
            passwordErrorMessage = state.field == LoginErrorField.password
                ? state.message
                : null;
          });
          _formKey.currentState!.validate(); // fuerza revalidación
        }
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
              bottom: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: emailController,
                  title: 'Correo electrónico',
                  label: 'Ingresa tu correo',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (emailErrorMessage != null) return emailErrorMessage;
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Correo electrónico no válido';
                    }
                    return null;
                  },
                  errorText: emailErrorMessage,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  title: 'Contraseña',
                  label: 'Escribe tu contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (passwordErrorMessage != null) {
                      return passwordErrorMessage;
                    }
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    return null;
                  },
                  errorText: passwordErrorMessage,
                ),
                const SizedBox(height: 24),
                LoginButton(
                  onPressed: () {
                    setState(() {
                      emailErrorMessage = null;
                      passwordErrorMessage = null;
                    });
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(
                        LoginSubmitted(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  text: 'Iniciar sesión',
                ),
                const SizedBox(height: 28),
                RedirectToSignup(
                  onSignupTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String title,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w100,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.textPrimary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
