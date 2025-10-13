import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/features/auth/ui/widgets/login_header.dart';
import 'package:match_track/features/auth/ui/widgets/login_form.dart';
import 'package:match_track/features/auth/ui/bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [LoginHeader(), LoginForm()]),
          ),
        ),
      ),
    );
  }
}
