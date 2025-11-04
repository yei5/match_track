import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/ui/bloc/signup_bloc.dart';
import 'package:match_track/features/auth/ui/widgets/redirect_to_login.dart';
import 'package:match_track/features/auth/ui/widgets/signup_text_field.dart';
import 'package:match_track/features/auth/ui/widgets/signup_button.dart';
import 'package:match_track/features/auth/ui/widgets/signup_header.dart';
import 'package:match_track/core/theme/app_colors.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SignupHeader(),
          const SizedBox(height: 8),
          Container(
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
                  SignupTextField(
                    controller: nameController,
                    label: 'Ingresa tu nombre',
                    title: 'Nombre Completo',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, ingresa tu nombre completo';
                      } else if (value.contains(RegExp(r'[0-9]'))) {
                        return 'El nombre no debe contener números';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SignupTextField(
                    controller: emailController,
                    label: 'Ingresa tu correo electrónico',
                    title: 'Correo electrónico',
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, ingresa un correo electrónico';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Correo electrónico no válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SignupTextField(
                    controller: passwordController,
                    label: 'Escribe tu contraseña',
                    title: 'Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa una contraseña';
                      } else if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SignupButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignupBloc>().add(
                          SubmmitSignupEvent(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Por favor llene todos los campos correctamente",
                              style: TextStyle(color: AppColors.background),
                            ),
                            backgroundColor: AppColors.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    text: "Registrarme",
                  ),
                  const SizedBox(height: 28),
                  RedirectToLogin(
                    onLoginTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
