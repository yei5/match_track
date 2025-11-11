// ignore_for_file: non_constant_identifier_names
class Player {
  final String id; 
  final String name;
  final String sport;
  final String? imageUrl;
  final String category;
  final String team_id;

  Player({
    required this.id,
    required this.name,
    required this.sport,
    this.imageUrl,
    required this.category,
    required this.team_id,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      sport: json['sport'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? '',
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
      'team_id': team_id,
    };
  }
}
