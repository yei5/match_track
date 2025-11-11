// ignore_for_file: non_constant_identifier_names
class Player {
  final String id; 
  final String name;
  final String sport;
  final String? imageUrl;
  final String category;
  final String jersey_number;
  final String team_id;

  Player({
    required this.id,
    required this.name,
    required this.sport,
    this.imageUrl,
    required this.category,
    required this.jersey_number,
    required this.team_id,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      sport: json['sport'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? '',
      jersey_number: json['jersey_number'] ?? '',
      team_id: json['team_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'image_url': imageUrl,
      'category': category,
      'jersey_number': jersey_number,
      'team_id': team_id,
    };
  }

  factory Player.copyWith({
    required Player player,
    String? id,
    String? name,
    String? sport,
    String? imageUrl,
    String? category,
    String? jersey_number,
    String? team_id,
  }) {
    return Player(
      id: id ?? player.id,
      name: name ?? player.name,
      sport: sport ?? player.sport,
      imageUrl: imageUrl ?? player.imageUrl,
      category: category ?? player.category,
      jersey_number: jersey_number ?? player.jersey_number,
      team_id: team_id ?? player.team_id,
    );
  }
}
