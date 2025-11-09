import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../domain/models/team_model.dart';

class EventsTimeline extends StatelessWidget {
  final List<MatchEventDetail> events;
  final Team homeTeam;
  final Team awayTeam;

  const EventsTimeline({
    super.key,
    required this.events,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No hay eventos registrados',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    // Ordenar eventos por minuto (más reciente primero)
    final sortedEvents = List<MatchEventDetail>.from(events)
      ..sort((a, b) => b.minute.compareTo(a.minute));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sortedEvents.length,
      separatorBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(left: 24),
        height: 20,
        width: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6366F1).withOpacity(0.5),
              const Color(0xFF6366F1).withOpacity(0.1),
            ],
          ),
        ),
      ),
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isHomeTeam = event.teamId == homeTeam.id;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Minuto
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${event.minute}\'',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            
            // Línea vertical con icono
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getEventColor(event.type),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getEventColor(event.type).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      event.eventIcon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Contenido del evento
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isHomeTeam 
                      ? const Color(0xFFE63946).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHomeTeam 
                        ? const Color(0xFFE63946).withOpacity(0.3)
                        : const Color(0xFFF59E0B).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHomeTeam ? homeTeam.name : awayTeam.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isHomeTeam 
                            ? const Color(0xFFE63946)
                            : const Color(0xFFF59E0B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.displayText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.goal:
        return const Color(0xFF10B981); // Verde
      case EventType.redCard:
        return const Color(0xFFE63946); // Rojo
      case EventType.yellowCard:
        return const Color(0xFFF59E0B); // Amarillo
      case EventType.substitution:
        return const Color(0xFF6366F1); // Morado
      case EventType.offside:
      case EventType.foul:
      case EventType.injury:
        return const Color(0xFF8B5CF6); // Morado claro
      case EventType.halfTime:
      case EventType.fullTime:
        return const Color(0xFF374151); // Gris
    }
  }
}
