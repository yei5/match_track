// ignore_for_file: non_constant_identifier_names
class TournamentEntity {
  final String id;
  final String name;
  final String description;
  final String sport;
  final String status;
  final String user_id;
  final String? image_url;
  final String start_date;
  final String end_date;
  final String category;
  final String team1_id;
  final String team2_id;

  TournamentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.status,
    this.image_url,
    required this.start_date,
    required this.end_date,
    required this.user_id,
    required this.category,
    required this.team1_id,
    required this.team2_id,
  });
}
