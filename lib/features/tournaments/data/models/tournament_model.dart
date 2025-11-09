import '../../domain/entities/tournament_entity.dart';

class TournamentModel extends TournamentEntity {
  TournamentModel({
    required String id,
    String? name,
    String? description,
    String? sport,
    String? imageUrl,
    String? status,
    String? startDate,
    String? endDate,
    String? teamA,
    String? teamB,
    String? creatorId,
    DateTime? createdAt,
  }) : super(
         id: id,
         name: name,
         description: description,
         sport: sport,
         imageUrl: imageUrl,
         status: status,
         startDate: startDate,
         endDate: endDate,
         teamA: teamA,
         teamB: teamB,
         creatorId: creatorId,
         createdAt: createdAt,
       );

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'].toString(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      sport: json['sport'] as String?,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      teamA: json['team_a'] as String?,
      teamB: json['team_b'] as String?,
      creatorId: json['creator_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'image_url': imageUrl,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'team_a': teamA,
      'team_b': teamB,
      'creator_id': creatorId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
