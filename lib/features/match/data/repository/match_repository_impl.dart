import '../../domain/models/match_model.dart';
import 'match_repository.dart';

/// Simple in-memory implementation for prototyping.
class MatchRepositoryImpl implements MatchRepository {
  final Map<String, MatchModel> _store = {};

  @override
  Future<void> saveMatch(MatchModel match) async {
    _store[match.id] = match;
  }

  @override
  Future<MatchModel?> getMatch(String id) async {
    return _store[id];
  }

  @override
  Future<List<MatchModel>> listMatches() async {
    return _store.values.toList(growable: false);
  }

  @override
  Future<void> deleteMatch(String id) async {
    _store.remove(id);
  }
}
