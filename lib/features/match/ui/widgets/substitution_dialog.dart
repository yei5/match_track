import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';
import '../../../../core/domain/model/player.dart' as CorePlayer;

class SubstitutionDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final List<CorePlayer.Player> homePlayers;
  final List<CorePlayer.Player> awayPlayers;
  final int currentMinute;

  const SubstitutionDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homePlayers,
    required this.awayPlayers,
    required this.currentMinute,
  });

  @override
  State<SubstitutionDialog> createState() => _SubstitutionDialogState();
}

class _SubstitutionDialogState extends State<SubstitutionDialog> {
  String? selectedTeamId;
  final _numOutCtrl = TextEditingController();
  final _numInCtrl = TextEditingController();
  CorePlayer.Player? _playerOut;
  CorePlayer.Player? _playerIn;

  @override
  void dispose() {
    _numOutCtrl.dispose();
    _numInCtrl.dispose();
    super.dispose();
  }

  void _searchPlayerOut(String dorsal) {
    if (dorsal.isEmpty || selectedTeamId == null) {
      setState(() => _playerOut = null);
      return;
    }

    final players = selectedTeamId == widget.homeTeam.id 
        ? widget.homePlayers 
        : widget.awayPlayers;
    
    final player = players.where((p) => p.jersey_number == dorsal).firstOrNull;
    setState(() => _playerOut = player);
  }

  void _searchPlayerIn(String dorsal) {
    if (dorsal.isEmpty || selectedTeamId == null) {
      setState(() => _playerIn = null);
      return;
    }

    final players = selectedTeamId == widget.homeTeam.id 
        ? widget.homePlayers 
        : widget.awayPlayers;
    
    final player = players.where((p) => p.jersey_number == dorsal).firstOrNull;
    setState(() => _playerIn = player);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🔄 Sustitución'),
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
                    onPressed: () => setState(() => selectedTeamId = widget.homeTeam.id),
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
                    onPressed: () => setState(() => selectedTeamId = widget.awayTeam.id),
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
              const Text('Sale (Dorsal):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _numOutCtrl,
                decoration: InputDecoration(
                  labelText: 'Número de dorsal',
                  border: const OutlineInputBorder(),
                  suffixIcon: _playerOut != null 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: _searchPlayerOut,
              ),
              if (_playerOut != null) ...[
                const SizedBox(height: 4),
                Text('✓ ${_playerOut!.name}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ] else if (_numOutCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 4),
                const Text('✗ Jugador no encontrado', style: TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              const Text('Entra (Dorsal):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _numInCtrl,
                decoration: InputDecoration(
                  labelText: 'Número de dorsal',
                  border: const OutlineInputBorder(),
                  suffixIcon: _playerIn != null 
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: _searchPlayerIn,
              ),
              if (_playerIn != null) ...[
                const SizedBox(height: 4),
                Text('✓ ${_playerIn!.name}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ] else if (_numInCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 4),
                const Text('✗ Jugador no encontrado', style: TextStyle(color: Colors.red)),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: selectedTeamId == null || _playerOut == null || _playerIn == null ? null : () {
            final event = MatchEventDetail(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: EventType.substitution,
              minute: widget.currentMinute,
              teamId: selectedTeamId!,
              playerOut: Player(
                name: _playerOut!.name,
                number: _playerOut!.jersey_number,
                teamId: selectedTeamId!,
              ),
              playerIn: Player(
                name: _playerIn!.name,
                number: _playerIn!.jersey_number,
                teamId: selectedTeamId!,
              ),
            );
            Navigator.pop(context, event);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
