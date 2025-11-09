class TournamentModel {
  final String id;
  final String name;
  final String description;
  final String sport;
  final String status;
  final String startDate;
  final String endDate;
  final String? imageUrl;
  final String creatorId;
  final String category;
  final String teamA;
  final String teamB;

  TournamentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    required this.creatorId,
    required this.category,
    required this.teamA,
    required this.teamB,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sport: json['sport'] ?? '',
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      imageUrl: json['image_url'],
      creatorId: json['creator_id'] ?? '',
      category: json['category'] ?? '',
      teamA: json['team_a'] ?? '',
      teamB: json['team_b'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'image_url': imageUrl,
      'creator_id': creatorId,
      'category': category,
      'team_a': teamA,
      'team_b': teamB,
    };
  }
}
