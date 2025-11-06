import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final dynamic authController;

  // Allow injecting a fake authController for tests
  const MyApp({super.key, this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'match_track',
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
                    : () {},
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
