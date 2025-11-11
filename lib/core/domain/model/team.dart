// ignore_for_file: non_constant_identifier_names
class Team {
  final String id;
  final String name;
  final String description;
  final String sport;
  final String? imageUrl;
  final String creator_id;
  final String category;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    this.imageUrl,
    required this.creator_id,
    required this.category,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sport: json['sport'] ?? '',
      imageUrl: json['image_url'],
      creator_id: json['creator_id'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'description': description,
      'sport': sport,
      'image_url': imageUrl,
      'creator_id': creator_id,
      'category': category,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  factory Team.copyWith({
    required Team team,
    String? id,
    String? name,
    String? description,
    String? sport,
    String? imageUrl,
    String? creator_id,
    String? category,
  }) {
    return Team(
      id: id ?? team.id,
      name: name ?? team.name,
      description: description ?? team.description,
      sport: sport ?? team.sport,
      imageUrl: imageUrl ?? team.imageUrl,
      creator_id: creator_id ?? team.creator_id,
      category: category ?? team.category,
    );
  }
}
