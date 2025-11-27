import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';

class GoalDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final int currentMinute;

  const GoalDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.currentMinute,
  });

  @override
  State<GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<GoalDialog> {
  String? selectedTeamId;
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _assistNameController = TextEditingController();
  final TextEditingController _assistNumberController = TextEditingController();
  bool includeAssist = false;

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerNumberController.dispose();
    _assistNameController.dispose();
    _assistNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('⚽ Registrar Gol'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minuto: ${widget.currentMinute}\'',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Selecciona el equipo:'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => selectedTeamId = widget.homeTeam.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTeamId == widget.homeTeam.id
                          ? const Color(0xFF6366F1)
                          : Colors.grey[300],
                    ),
                    child: Text(widget.homeTeam.name),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => selectedTeamId = widget.awayTeam.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTeamId == widget.awayTeam.id
                          ? const Color(0xFF6366F1)
                          : Colors.grey[300],
                    ),
                    child: Text(widget.awayTeam.name),
                  ),
                ),
              ],
            ),
            if (selectedTeamId != null) ...[
              const SizedBox(height: 16),
              const Text('Goleador:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del jugador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _playerNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de dorsal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Agregar asistencia'),
                value: includeAssist,
                onChanged: (value) {
                  setState(() => includeAssist = value ?? false);
                },
              ),
              if (includeAssist) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _assistNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del asistente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _assistNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Número de dorsal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: selectedTeamId == null ||
                  _playerNameController.text.isEmpty ||
                  _playerNumberController.text.isEmpty
              ? null
              : () {
                  final event = MatchEventDetail(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: EventType.goal,
                    minute: widget.currentMinute,
                    teamId: selectedTeamId!,
                    scorer: Player(
                      name: _playerNameController.text,
                      number: _playerNumberController.text,
                      teamId: selectedTeamId!,
                    ),
                    assist: includeAssist &&
                            _assistNameController.text.isNotEmpty
                        ? Player(
                            name: _assistNameController.text,
                            number: _assistNumberController.text,
                            teamId: selectedTeamId!,
                          )
                        : null,
                  );
                  Navigator.pop(context, event);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
          ),
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
