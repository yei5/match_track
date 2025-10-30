import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/auth/auth_scope.dart';
import 'features/auth/ui/screens/reset_password_request_screen.dart';
import 'features/auth/ui/screens/login_screen.dart';

Future<void> main() async {
  // try load .env if present (not mandatory)
  try {
    await dotenv.load();
  } catch (_) {
    // ignore
  }

  final authController = createAuthControllerFromEnv();
  runApp(MyApp(authController: authController));
}

class MyApp extends StatelessWidget {
  final dynamic authController;

  // Allow an optional authController for tests; production code passes a real one.
  const MyApp({super.key, this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', authController: authController),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final dynamic authController;

  const MyHomePage({super.key, required this.title, this.authController});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bienvenido', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: widget.authController == null
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ResetPasswordRequestScreen(controller: widget.authController),
                        ));
                      },
                child: const Text('Reestablecer contraseña'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: widget.authController == null
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => LoginScreen(controller: widget.authController),
                        ));
                      },
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 24),
              Text('Contador: $_counter'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
