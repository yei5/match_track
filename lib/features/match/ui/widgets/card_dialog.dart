import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../domain/models/team_model.dart';

class CardDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final int currentMinute;
  final bool isRed; // true = roja, false = amarilla

  const CardDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.currentMinute,
    required this.isRed,
  });

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  String? selectedTeamId;
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _playerNumberController = TextEditingController();

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isRed ? '🟥 Tarjeta Roja' : '🟨 Tarjeta Amarilla'),
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
              const Text('Jugador sancionado:',
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
                    type: widget.isRed ? EventType.redCard : EventType.yellowCard,
                    minute: widget.currentMinute,
                    teamId: selectedTeamId!,
                    player: Player(
                      name: _playerNameController.text,
                      number: _playerNumberController.text,
                      teamId: selectedTeamId!,
                    ),
                  );
                  Navigator.pop(context, event);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isRed ? const Color(0xFFE63946) : const Color(0xFFF59E0B),
          ),
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
