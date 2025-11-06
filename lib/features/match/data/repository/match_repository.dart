import '../../domain/models/match_model.dart';

abstract class MatchRepository {
  Future<void> saveMatch(MatchModel match);
  Future<MatchModel?> getMatch(String id);
  Future<List<MatchModel>> listMatches();
  Future<void> deleteMatch(String id);
}
