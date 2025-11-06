import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/team_model.dart';

class MatchController extends ChangeNotifier {
  final MatchModel match;
  Timer? _ticker;
  int _accumulated = 0;

  MatchController({required this.match});

  int get elapsedSeconds => match.elapsedSeconds;
  String get formattedTime {
    final s = match.elapsedSeconds;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  bool get isRunning => match.status == MatchStatus.running;

  void start() {
    if (isRunning) return;
    match.status = MatchStatus.running;
    _ticker?.cancel();
    _ticker = Timer.periodic(Duration(seconds: 1), (_) {
      match.elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (!isRunning) return;
    _ticker?.cancel();
    match.status = MatchStatus.paused;
    notifyListeners();
  }

  void stop({bool reset = false}) {
    _ticker?.cancel();
    match.status = MatchStatus.finished;
    if (reset) {
      match.elapsedSeconds = 0;
      match.homeScore = 0;
      match.awayScore = 0;
      match.events.clear();
    }
    notifyListeners();
  }

  void addGoal(String teamId) {
    if (teamId == match.homeTeam.id) {
      match.homeScore++;
    } else if (teamId == match.awayTeam.id) {
      match.awayScore++;
    }
    final ev = MatchEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'goal',
      teamId: teamId,
      timestamp: match.elapsedSeconds,
    );
    match.events.add(ev);
    notifyListeners();
  }

  void addFoul(String teamId) {
    final ev = MatchEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'foul',
      teamId: teamId,
      timestamp: match.elapsedSeconds,
    );
    match.events.add(ev);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
