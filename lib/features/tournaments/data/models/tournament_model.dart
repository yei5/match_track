// ignore_for_file: non_constant_identifier_names
class TournamentModel {
  final String id;
  final String name;
  final String description;
  final String sport;
  final String status;
  final String start_date;
  final String end_date;
  final String? imageUrl;
  final String user_id;
  final String category;
  final String team1_id;
  final String team2_id;

  TournamentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.status,
    required this.start_date,
    required this.end_date,
    this.imageUrl,
    required this.user_id,
    required this.category,
    required this.team1_id,
    required this.team2_id,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sport: json['sport'] ?? '',
      status: json['status'] ?? '',
      start_date: json['start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      imageUrl: json['image_url'],
      user_id: json['user_id'] ?? '',
      category: json['category'] ?? '',
      team1_id: json['team1_id']?.toString() ?? '',
      team2_id: json['team2_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'status': status,
      'start_date': start_date,
      'end_date': end_date,
      'image_url': imageUrl,
      'user_id': user_id,
      'category': category,
      'team1_id': team1_id,
      'team2_id': team2_id,
    };
  }
}
