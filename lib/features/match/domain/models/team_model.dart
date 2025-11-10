class Team {
  final String id;
  final String name;
  final String? logoUrl;
  final int? colorValue;
  final List<String>? players;

  Team({
    required this.id,
    required this.name,
    this.logoUrl,
    this.colorValue,
    this.players,
  });

  Team copyWith({
    String? id,
    String? name,
    String? logoUrl,
    int? colorValue,
    List<String>? players,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      colorValue: colorValue ?? this.colorValue,
      players: players ?? this.players,
    );
  }
}
