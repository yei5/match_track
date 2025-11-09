enum EventType {
  goal,
  redCard,
  yellowCard,
  substitution,
  offside,
  foul,
  injury,
  halfTime,
  fullTime
}

class Player {
  final String name;
  final String number;
  final String teamId;

  Player({
    required this.name,
    required this.number,
    required this.teamId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'teamId': teamId,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json['name'] as String,
        number: json['number'] as String,
        teamId: json['teamId'] as String,
      );
}

class MatchEventDetail {
  final String id;
  final EventType type;
  final int minute;
  final String teamId;
  
  // Para goles
  final Player? scorer;
  final Player? assist;
  
  // Para tarjetas
  final Player? player;
  
  // Para sustituciones
  final Player? playerOut;
  final Player? playerIn;
  
  // Para interrupciones
  final String? description;
  
  final DateTime timestamp;

  MatchEventDetail({
    required this.id,
    required this.type,
    required this.minute,
    required this.teamId,
    this.scorer,
    this.assist,
    this.player,
    this.playerOut,
    this.playerIn,
    this.description,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get eventIcon {
    switch (type) {
      case EventType.goal:
        return '⚽';
      case EventType.redCard:
        return '🟥';
      case EventType.yellowCard:
        return '🟨';
      case EventType.substitution:
        return '🔄';
      case EventType.offside:
        return '🚩';
      case EventType.foul:
        return '🤚';
      case EventType.injury:
        return '🩹';
      case EventType.halfTime:
        return '⏱️';
      case EventType.fullTime:
        return '🏁';
    }
  }

  String get displayText {
    switch (type) {
      case EventType.goal:
        return 'Gol de ${scorer?.name ?? "Desconocido"}${assist != null ? " (Asistencia: ${assist!.name})" : ""}';
      case EventType.redCard:
        return 'Tarjeta Roja - ${player?.name ?? "Desconocido"} #${player?.number ?? "?"}';
      case EventType.yellowCard:
        return 'Tarjeta Amarilla - ${player?.name ?? "Desconocido"} #${player?.number ?? "?"}';
      case EventType.substitution:
        return 'Cambio: Sale ${playerOut?.name ?? "?"} #${playerOut?.number ?? "?"}, Entra ${playerIn?.name ?? "?"} #${playerIn?.number ?? "?"}';
      case EventType.offside:
        return 'Fuera de juego';
      case EventType.foul:
        return 'Falta${description != null ? " - $description" : ""}';
      case EventType.injury:
        return 'Lesión${player != null ? " - ${player!.name}" : ""}';
      case EventType.halfTime:
        return 'Entretiempo';
      case EventType.fullTime:
        return 'Fin del partido';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'minute': minute,
        'teamId': teamId,
        'scorer': scorer?.toJson(),
        'assist': assist?.toJson(),
        'player': player?.toJson(),
        'playerOut': playerOut?.toJson(),
        'playerIn': playerIn?.toJson(),
        'description': description,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MatchEventDetail.fromJson(Map<String, dynamic> json) =>
      MatchEventDetail(
        id: json['id'] as String,
        type: EventType.values.firstWhere((e) => e.name == json['type']),
        minute: json['minute'] as int,
        teamId: json['teamId'] as String,
        scorer: json['scorer'] != null
            ? Player.fromJson(json['scorer'] as Map<String, dynamic>)
            : null,
        assist: json['assist'] != null
            ? Player.fromJson(json['assist'] as Map<String, dynamic>)
            : null,
        player: json['player'] != null
            ? Player.fromJson(json['player'] as Map<String, dynamic>)
            : null,
        playerOut: json['playerOut'] != null
            ? Player.fromJson(json['playerOut'] as Map<String, dynamic>)
            : null,
        playerIn: json['playerIn'] != null
            ? Player.fromJson(json['playerIn'] as Map<String, dynamic>)
            : null,
        description: json['description'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
