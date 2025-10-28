import 'package:flutter/material.dart';

import '../bloc/auth_controller.dart';

class ResetPasswordRequestScreen extends StatefulWidget {
  final AuthController controller;

  const ResetPasswordRequestScreen({super.key, required this.controller});

  @override
  State<ResetPasswordRequestScreen> createState() => _ResetPasswordRequestScreenState();
}

class _ResetPasswordRequestScreenState extends State<ResetPasswordRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.controller.sendResetEmail(_emailCtrl.text.trim());
    if (widget.controller.state == AuthState.success) {
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ResetPasswordConfirmationScreen(),
      ));
    } else if (widget.controller.state == AuthState.error) {
      if (!mounted) return;
      final msg = widget.controller.errorMessage ?? 'Error inesperado';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Restablecer contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text('Introduce tu correo y te enviaremos un enlace para restablecer la contraseña.', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Introduce tu correo';
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.controller.state == AuthState.loading ? null : _onSubmit,
              child: widget.controller.state == AuthState.loading ? const CircularProgressIndicator() : const Text('Enviar enlace'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordConfirmationScreen extends StatelessWidget {
  const ResetPasswordConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Correo enviado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.email, size: 72, color: Colors.green),
              const SizedBox(height: 16),
              const Text('Hemos enviado un correo con instrucciones para restablecer tu contraseña.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Volver'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
