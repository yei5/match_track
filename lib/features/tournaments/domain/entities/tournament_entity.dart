class TournamentEntity {
  final String id;
  final String? name;
  final String? description;
  final String? sport;
  final String? imageUrl;
  final String? status;
  final String? startDate;
  final String? endDate;
  final String? teamA;
  final String? teamB;
  final String? creatorId;
  final DateTime? createdAt;

  TournamentEntity({
    required this.id,
    this.name,
    this.description,
    this.sport,
    this.imageUrl,
    this.status,
    this.startDate,
    this.endDate,
    this.teamA,
    this.teamB,
    this.creatorId,
    this.createdAt,
  });
}
