import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../bloc/match_controller.dart';

class MatchControlScreen extends StatefulWidget {
  final MatchModel match;

  const MatchControlScreen({super.key, required this.match});

  @override
  State<MatchControlScreen> createState() => _MatchControlScreenState();
}

class _MatchControlScreenState extends State<MatchControlScreen> {
  late MatchController controller;

  @override
  void initState() {
    super.initState();
    controller = MatchController(match: widget.match);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _bigButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 44),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Control de partido')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(widget.match.homeTeam.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(widget.match.homeScore.toString(), style: theme.textTheme.displaySmall),
                        ],
                      ),
                      Text('${widget.match.homeScore} - ${widget.match.awayScore}', style: theme.textTheme.headlineMedium),
                      Column(
                        children: [
                          Text(widget.match.awayTeam.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(widget.match.awayScore.toString(), style: theme.textTheme.displaySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.timer, size: 56, color: Colors.deepPurple),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) => Text(controller.formattedTime, style: theme.textTheme.headlineMedium),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bigButton(Icons.play_arrow, Colors.deepPurple, () => controller.start()),
                  _bigButton(Icons.pause, Colors.deepPurple, () => controller.pause()),
                  _bigButton(Icons.stop, Colors.deepPurple, () => controller.stop(reset: false)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Acciones', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.addGoal(widget.match.homeTeam.id),
                    child: const Text('+1'),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.addFoul(widget.match.homeTeam.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Icon(Icons.warning),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.addFoul(widget.match.awayTeam.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Icon(Icons.pan_tool),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.addGoal(widget.match.awayTeam.id),
                    child: const Text('+1'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.loop),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.timer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
