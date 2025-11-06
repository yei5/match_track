import 'package:flutter/material.dart';
import 'features/match/domain/models/team_model.dart';
import 'features/match/domain/models/match_model.dart';
import 'features/match/ui/screens/match_control_screen.dart';

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
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Demo: crear un partido entre Icesi y Javeriana
                  final home = Team(id: 'home-1', name: 'Icesi');
                  final away = Team(id: 'away-1', name: 'Javeriana');
                  final match = MatchModel(id: 'match-1', homeTeam: home, awayTeam: away);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MatchControlScreen(match: match)),
                  );
                },
                icon: const Icon(Icons.sports_soccer),
                label: const Text('Control de Partido'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
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
