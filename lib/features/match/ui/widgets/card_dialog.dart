import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';
import '../../../../core/domain/model/player.dart' as CorePlayer;

class CardDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final List<CorePlayer.Player> homePlayers;
  final List<CorePlayer.Player> awayPlayers;
  final int currentMinute;
  final bool isRed; // true = roja, false = amarilla

  const CardDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homePlayers,
    required this.awayPlayers,
    required this.currentMinute,
    required this.isRed,
  });

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  String? selectedTeamId;
  final TextEditingController _playerNumberController = TextEditingController();
  CorePlayer.Player? _foundPlayer;

  @override
  void dispose() {
    _playerNumberController.dispose();
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
              const Text('Jugador sancionado (Dorsal):',
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
                    type: widget.isRed ? EventType.redCard : EventType.yellowCard,
                    minute: widget.currentMinute,
                    teamId: selectedTeamId!,
                    player: Player(
                      name: _foundPlayer!.name,
                      number: _foundPlayer!.jersey_number,
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
