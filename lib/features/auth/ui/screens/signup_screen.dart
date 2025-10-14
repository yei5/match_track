import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/ui/bloc/signup_bloc.dart';
import 'package:match_track/features/auth/ui/widgets/signup_form.dart';
import 'package:match_track/core/presentation/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkText,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => SignupBloc(),
          child: const SignupView(),
        ),
      ),
    );
  }
}

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        if (state is SignupIdleState) {
          return SignupForm();
        } else if (state is SignupLoadingState) {
          return CircularProgressIndicator();
        } else if (state is SignupSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(context, 'Usuario creado exitosamente', false);
            print(Supabase.instance.client.auth.currentUser);
            Navigator.pushReplacementNamed(context, '/profile');
          });
          return SizedBox.shrink();
        } else if (state is SignupErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(
              context,
              state.errorMessage ?? "Error desconocido",
              true,
            );
            Navigator.pushReplacementNamed(context, '/signup');
          });
          return SizedBox.shrink();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.lightBackground),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
