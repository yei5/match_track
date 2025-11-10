import 'package:flutter/material.dart';

class TournamentFilterBar extends StatelessWidget {
  final String selectedSport;
  final String selectedStatus;
  final bool showMyTournaments;
  final ValueChanged<String> onSportChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<bool> onToggleMyTournaments;

  const TournamentFilterBar({
    Key? key,
    required this.selectedSport,
    required this.selectedStatus,
    required this.showMyTournaments,
    required this.onSportChanged,
    required this.onStatusChanged,
    required this.onToggleMyTournaments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sports = ['Todos', 'Fútbol', 'Baloncesto', 'Vóley'];
    final statuses = ['Todos', 'Activo', 'Programado', 'Finalizado'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedSport,
          items: sports
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) {
            if (value != null) onSportChanged(value);
          },
        ),
        DropdownButton<String>(
          value: selectedStatus,
          items: statuses
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) {
            if (value != null) onStatusChanged(value);
          },
        ),
        Row(
          children: [
            Checkbox(
              value: showMyTournaments,
              onChanged: (val) => onToggleMyTournaments(val ?? false),
            ),
            const Text('Mis torneos'),
          ],
        ),
      ],
    );
  }
}
