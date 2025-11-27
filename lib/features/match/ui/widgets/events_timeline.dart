import 'package:flutter/material.dart';
import '../../domain/models/match_event_model.dart';
import '../../../../core/domain/model/team.dart';

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

    // Ordenar eventos por minuto (más antiguo primero)
    final sortedEvents = List<MatchEventDetail>.from(events)
      ..sort((a, b) => a.minute.compareTo(b.minute));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isHomeTeam = event.teamId == homeTeam.id;
        final isNeutral = event.type == EventType.halfTime || event.type == EventType.fullTime;
        
        return _buildTimelineItem(
          event: event,
          isHomeTeam: isHomeTeam,
          isNeutral: isNeutral,
          isLast: index == sortedEvents.length - 1,
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required MatchEventDetail event,
    required bool isHomeTeam,
    required bool isNeutral,
    required bool isLast,
  }) {
    // Si es evento neutral, usar layout especial centrado
    if (isNeutral) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // Minuto
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Evento neutral centrado
                    _buildNeutralEvent(event),
                    const SizedBox(height: 8),
                    // Línea vertical
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 20,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF6366F1),
                              Color(0x4D6366F1),
                            ],
                          ),
                        ),
                      ),
                    if (isLast)
                      const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    
    // Layout normal para eventos con equipo
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lado izquierdo (equipo local)
          Expanded(
            child: isHomeTeam
                ? _buildEventContent(event, isHomeTeam, Alignment.centerRight)
                : const SizedBox(),
          ),
          
          // Riel central con minuto
          SizedBox(
            width: 80,
            child: Column(
              children: [
                // Minuto
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  ),
                ),
                
                // Línea vertical
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF6366F1),
                            Color(0x4D6366F1),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                if (isLast)
                  const SizedBox(height: 16),
              ],
            ),
          ),
          
          // Lado derecho (equipo visitante)
          Expanded(
            child: !isHomeTeam
                ? _buildEventContent(event, isHomeTeam, Alignment.centerLeft)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventContent(MatchEventDetail event, bool isHomeTeam, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
          left: alignment == Alignment.centerLeft ? 8 : 0,
          right: alignment == Alignment.centerRight ? 8 : 0,
          bottom: 16,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHomeTeam ? const Color(0xFFE63946) : const Color(0xFFF59E0B),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono del evento
            _buildEventIcon(event.type),
            const SizedBox(width: 8),
            
            // Contenido del evento
            Flexible(
              child: _buildEventText(event),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeutralEvent(MatchEventDetail event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9CA3AF),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.type == EventType.halfTime ? Icons.timer : Icons.flag,
              color: const Color(0xFF6366F1),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            event.type == EventType.halfTime ? 'Entretiempo' : 'Fin del partido',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventIcon(EventType type) {
    String emoji;
    Color bgColor;
    
    switch (type) {
      case EventType.goal:
        emoji = '⚽';
        bgColor = const Color(0xFF00FF00);
        break;
      case EventType.redCard:
        emoji = '🟥';
        bgColor = const Color(0xFFE63946);
        break;
      case EventType.yellowCard:
        emoji = '🟨';
        bgColor = const Color(0xFFF59E0B);
        break;
      case EventType.substitution:
        emoji = '🔄';
        bgColor = const Color(0xFF6366F1);
        break;
      case EventType.offside:
        emoji = '🚩';
        bgColor = const Color(0xFF9CA3AF);
        break;
      case EventType.foul:
        emoji = '⚠️';
        bgColor = const Color(0xFFF59E0B);
        break;
      case EventType.injury:
        emoji = '🩹';
        bgColor = const Color(0xFFE63946);
        break;
      case EventType.halfTime:
        emoji = '⏸️';
        bgColor = const Color(0xFF9CA3AF);
        break;
      case EventType.fullTime:
        emoji = '🏁';
        bgColor = const Color(0xFF374151);
        break;
    }
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildEventText(MatchEventDetail event) {
    switch (event.type) {
      case EventType.goal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.scorer?.name ?? 'Desconocido',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '#${event.scorer?.number ?? '?'}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            if (event.assist != null) ...[
              const SizedBox(height: 4),
              Text(
                'Asist: ${event.assist!.name}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
        
      case EventType.redCard:
      case EventType.yellowCard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.player?.name ?? 'Desconocido',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '#${event.player?.number ?? '?'}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        );
        
      case EventType.substitution:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jugador que entra (verde)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '↑',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${event.playerIn?.name ?? '?'} #${event.playerIn?.number ?? '?'}',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Jugador que sale (rojo)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '↓',
                  style: TextStyle(
                    color: Color(0xFFE63946),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${event.playerOut?.name ?? '?'} #${event.playerOut?.number ?? '?'}',
                    style: const TextStyle(
                      color: Color(0xFFE63946),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
        
      case EventType.offside:
        return const Text(
          'Fuera de juego',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        );
        
      case EventType.foul:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Falta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (event.description != null && event.description!.isNotEmpty)
              Text(
                event.description!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
          ],
        );
        
      case EventType.injury:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Lesión',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (event.player != null)
              Text(
                '${event.player!.name} #${event.player!.number}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
          ],
        );
        
      default:
        return Text(
          event.displayText,
          style: const TextStyle(fontSize: 13),
        );
    }
  }
}
