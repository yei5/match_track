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
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'image_url': imageUrl,
      'creator_id': creator_id,
      'category': category,
    };
  }
}
