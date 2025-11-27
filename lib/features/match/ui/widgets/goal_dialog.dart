import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';
import '../../../../core/domain/model/player.dart' as CorePlayer;

class GoalDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final List<CorePlayer.Player> homePlayers;
  final List<CorePlayer.Player> awayPlayers;
  final int currentMinute;

  const GoalDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homePlayers,
    required this.awayPlayers,
    required this.currentMinute,
  });

  @override
  State<GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<GoalDialog> {
  String? selectedTeamId;
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _assistNumberController = TextEditingController();
  bool includeAssist = false;
  CorePlayer.Player? _foundPlayer;
  CorePlayer.Player? _foundAssist;

  @override
  void dispose() {
    _playerNumberController.dispose();
    _assistNumberController.dispose();
    super.dispose();
  }

  void _searchPlayer(String dorsal) {
    if (dorsal.isEmpty || selectedTeamId == null) {
      setState(() => _foundPlayer = null);
      return;
    }

    final players = selectedTeamId == widget.homeTeam.id 
        ? widget.homePlayers 
        : widget.awayPlayers;
    
    final player = players.where((p) => p.jersey_number == dorsal).firstOrNull;
    setState(() => _foundPlayer = player);
  }

  void _searchAssist(String dorsal) {
    if (dorsal.isEmpty || selectedTeamId == null) {
      setState(() => _foundAssist = null);
      return;
    }

    final players = selectedTeamId == widget.homeTeam.id 
        ? widget.homePlayers 
        : widget.awayPlayers;
    
    final player = players.where((p) => p.jersey_number == dorsal).firstOrNull;
    setState(() => _foundAssist = player);
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
              const Text('Goleador (Dorsal):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _playerNumberController,
                decoration: InputDecoration(
                  labelText: 'Número de dorsal',
                  border: const OutlineInputBorder(),
                  suffixIcon: _foundPlayer != null 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: _searchPlayer,
              ),
              if (_foundPlayer != null) ...[
                const SizedBox(height: 4),
                Text(
                  '✓ ${_foundPlayer!.name}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ] else if (_playerNumberController.text.isNotEmpty) ...[
                const SizedBox(height: 4),
                const Text(
                  '✗ Jugador no encontrado',
                  style: TextStyle(color: Colors.red),
                ),
              ],
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
                  controller: _assistNumberController,
                  decoration: InputDecoration(
                    labelText: 'Dorsal del asistente',
                    border: const OutlineInputBorder(),
                    suffixIcon: _foundAssist != null 
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _searchAssist,
                ),
                if (_foundAssist != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '✓ ${_foundAssist!.name}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ] else if (_assistNumberController.text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  const Text(
                    '✗ Jugador no encontrado',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
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
          onPressed: selectedTeamId == null || _foundPlayer == null
              ? null
              : () {
                  final event = MatchEventDetail(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: EventType.goal,
                    minute: widget.currentMinute,
                    teamId: selectedTeamId!,
                    scorer: Player(
                      name: _foundPlayer!.name,
                      number: _foundPlayer!.jersey_number,
                      teamId: selectedTeamId!,
                    ),
                    assist: includeAssist && _foundAssist != null
                        ? Player(
                            name: _foundAssist!.name,
                            number: _foundAssist!.jersey_number,
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
