import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart'; // Import for WidgetsFlutterBinding
import 'package:match_track/features/match/domain/models/team_model.dart';
import 'package:match_track/features/match/domain/models/match_model.dart';
import 'package:match_track/features/match/domain/models/match_event_model.dart' as event_model;
import 'package:match_track/features/match/utils/match_sheet_pdf_generator.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  // Ensure Flutter binding is initialized for plugins like path_provider
  WidgetsFlutterBinding.ensureInitialized();

  // Run the async logic within a self-executing function or a separate async function
  _generatePdfTest();
}

Future<void> _generatePdfTest() async {
  // Simulate fetching data for a match
  final sampleHomeTeam = Team(id: 'home1', name: 'Aguilas FC', logoUrl: 'https://example.com/logo_aguilas.png', colorValue: 0xFF0000FF, players: ['player1', 'player2']);
  final sampleAwayTeam = Team(id: 'away1', name: 'Leones Rojos', logoUrl: null, colorValue: 0xFFFF0000, players: ['player3', 'player4']);

  final sampleMatchEvents = <event_model.MatchEventDetail>[
    event_model.MatchEventDetail(
      id: 'event1',
      type: event_model.EventType.goal,
      minute: 15,
      teamId: sampleHomeTeam.id,
      scorer: event_model.Player(name: 'Jugador 1', number: '10', teamId: sampleHomeTeam.id),
      assist: event_model.Player(name: 'Jugador 2', number: '7', teamId: sampleHomeTeam.id),
    ),
    event_model.MatchEventDetail(
      id: 'event2',
      type: event_model.EventType.yellowCard,
      minute: 25,
      teamId: sampleAwayTeam.id,
      player: event_model.Player(name: 'Defensor A', number: '4', teamId: sampleAwayTeam.id),
    ),
    event_model.MatchEventDetail(
      id: 'event3',
      type: event_model.EventType.substitution,
      minute: 45,
      teamId: sampleHomeTeam.id,
      playerOut: event_model.Player(name: 'Delantero X', number: '9', teamId: sampleHomeTeam.id),
      playerIn: event_model.Player(name: 'Mediocampista Y', number: '11', teamId: sampleHomeTeam.id),
    ),
    event_model.MatchEventDetail(
      id: 'event4',
      type: event_model.EventType.goal,
      minute: 70,
      teamId: sampleAwayTeam.id,
      scorer: event_model.Player(name: 'Atacante Z', number: '9', teamId: sampleAwayTeam.id),
    ),
    event_model.MatchEventDetail(
      id: 'event5',
      type: event_model.EventType.redCard,
      minute: 80,
      teamId: sampleHomeTeam.id,
      player: event_model.Player(name: 'Jugador 5', number: '5', teamId: sampleHomeTeam.id),
    ),
    event_model.MatchEventDetail(
      id: 'event6',
      type: event_model.EventType.fullTime,
      minute: 90,
      teamId: '', // N/A for full-time
    ),
  ];

  final MatchModel sampleMatch = MatchModel(
    id: 'match123',
    homeTeam: sampleHomeTeam,
    awayTeam: sampleAwayTeam,
    homeScore: 1,
    awayScore: 2,
    elapsedSeconds: 5400, // 90 minutes
    status: MatchStatus.finished,
    currentHalf: HalfTime.firstHalf,
    detailedEvents: sampleMatchEvents,
  );

  print('Generating PDF for sample match...');
  final Uint8List pdfBytes = await MatchSheetPdfGenerator.generate(sampleMatch);

  // Save the PDF to a temporary directory (for demonstration purposes)
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/match_sheet.pdf');
  await file.writeAsBytes(pdfBytes);

  print('PDF generated successfully at: ${file.path}');
  print('You can open this file to view the match sheet.');
}