class TournamentEntity {
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

  TournamentEntity({
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
}
