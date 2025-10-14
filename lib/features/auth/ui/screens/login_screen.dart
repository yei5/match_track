import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/ui/widgets/login_header.dart';
import 'package:match_track/features/auth/ui/widgets/login_form.dart';
import 'package:match_track/features/auth/ui/bloc/login_bloc.dart';
import 'package:match_track/core/presentation/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        backgroundColor: AppColors.darkText,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: const [LoginHeader(), LoginForm()]),
          ),
        ),
      ),
    );
  }
}
