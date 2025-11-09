import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../domain/models/team_model.dart';

class InterruptionDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final int currentMinute;

  const InterruptionDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.currentMinute,
  });

  @override
  State<InterruptionDialog> createState() => _InterruptionDialogState();
}

class _InterruptionDialogState extends State<InterruptionDialog> {
  EventType? selectedType;
  String? selectedTeamId;
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🤚 Interrupción del Juego'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minuto: ${widget.currentMinute}\'',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Tipo de interrupción:'),
            const SizedBox(height: 8),
            Column(
              children: [
                ListTile(
                  leading: const Text('🚩', style: TextStyle(fontSize: 24)),
                  title: const Text('Fuera de juego'),
                  selected: selectedType == EventType.offside,
                  onTap: () => setState(() => selectedType = EventType.offside),
                  tileColor: selectedType == EventType.offside
                      ? const Color(0xFF6366F1).withOpacity(0.2)
                      : null,
                ),
                ListTile(
                  leading: const Text('🤚', style: TextStyle(fontSize: 24)),
                  title: const Text('Falta'),
                  selected: selectedType == EventType.foul,
                  onTap: () => setState(() => selectedType = EventType.foul),
                  tileColor: selectedType == EventType.foul
                      ? const Color(0xFF6366F1).withOpacity(0.2)
                      : null,
                ),
                ListTile(
                  leading: const Text('🩹', style: TextStyle(fontSize: 24)),
                  title: const Text('Lesión'),
                  selected: selectedType == EventType.injury,
                  onTap: () => setState(() => selectedType = EventType.injury),
                  tileColor: selectedType == EventType.injury
                      ? const Color(0xFF6366F1).withOpacity(0.2)
                      : null,
                ),
              ],
            ),
            if (selectedType != null) ...[
              const SizedBox(height: 16),
              const Text('Equipo involucrado:'),
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
              if (selectedType == EventType.injury && selectedTeamId != null) ...[
                const SizedBox(height: 16),
                const Text('Jugador lesionado:',
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
              ],
              if (selectedType == EventType.foul && selectedTeamId != null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    border: OutlineInputBorder(),
                    hintText: 'Ej: Falta sobre el área',
                  ),
                  maxLines: 2,
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
          onPressed: selectedType == null || selectedTeamId == null
              ? null
              : () {
                  final event = MatchEventDetail(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: selectedType!,
                    minute: widget.currentMinute,
                    teamId: selectedTeamId!,
                    player: selectedType == EventType.injury &&
                            _playerNameController.text.isNotEmpty
                        ? Player(
                            name: _playerNameController.text,
                            number: _playerNumberController.text,
                            teamId: selectedTeamId!,
                          )
                        : null,
                    description: selectedType == EventType.foul
                        ? _descriptionController.text
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
