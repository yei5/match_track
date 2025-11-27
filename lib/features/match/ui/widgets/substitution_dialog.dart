import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';

class SubstitutionDialog extends StatefulWidget {
  final Team homeTeam;
  final Team awayTeam;
  final int currentMinute;

  const SubstitutionDialog({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.currentMinute,
  });

  @override
  State<SubstitutionDialog> createState() => _SubstitutionDialogState();
}

class _SubstitutionDialogState extends State<SubstitutionDialog> {
  String? selectedTeamId;
  final _nameOutCtrl = TextEditingController();
  final _numOutCtrl = TextEditingController();
  final _nameInCtrl = TextEditingController();
  final _numInCtrl = TextEditingController();

  @override
  void dispose() {
    _nameOutCtrl.dispose();
    _numOutCtrl.dispose();
    _nameInCtrl.dispose();
    _numInCtrl.dispose();
    super.dispose();
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
            Text('Minuto: ${widget.currentMinute}\''),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => selectedTeamId = widget.homeTeam.id),
              child: Text(widget.homeTeam.name),
            ),
            ElevatedButton(
              onPressed: () => setState(() => selectedTeamId = widget.awayTeam.id),
              child: Text(widget.awayTeam.name),
            ),
            if (selectedTeamId != null) ...[
              TextField(controller: _nameOutCtrl, decoration: const InputDecoration(labelText: 'Sale - Nombre')),
              TextField(controller: _numOutCtrl, decoration: const InputDecoration(labelText: 'Sale - Número')),
              TextField(controller: _nameInCtrl, decoration: const InputDecoration(labelText: 'Entra - Nombre')),
              TextField(controller: _numInCtrl, decoration: const InputDecoration(labelText: 'Entra - Número')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: selectedTeamId == null ? null : () {
            final event = MatchEventDetail(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: EventType.substitution,
              minute: widget.currentMinute,
              teamId: selectedTeamId!,
              playerOut: Player(name: _nameOutCtrl.text, number: _numOutCtrl.text, teamId: selectedTeamId!),
              playerIn: Player(name: _nameInCtrl.text, number: _numInCtrl.text, teamId: selectedTeamId!),
            );
            Navigator.pop(context, event);
          },
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
