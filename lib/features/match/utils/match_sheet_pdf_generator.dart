import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:match_track/features/match/domain/models/match_model.dart';
import 'package:match_track/features/match/domain/models/team_model.dart';
import 'package:match_track/features/match/domain/models/match_event_model.dart' as event_model;

class MatchSheetPdfGenerator {
  static Future<Uint8List> generate(MatchModel match) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Reporte de Partido',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            _buildMatchSummary(match),
            pw.SizedBox(height: 20),
            _buildTeamsInfo(match),
            pw.SizedBox(height: 20),
            _buildEventsTimeline(match),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildMatchSummary(MatchModel match) {
    return pw.Container(
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey700, width: 1),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Partido: ${match.homeTeam.name} vs ${match.awayTeam.name}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Marcador Final: ${match.homeScore} - ${match.awayScore}',
              style: pw.TextStyle(fontSize: 16)),
          pw.Text('Estado: ${match.status.name}', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Tiempo jugado: ${match.elapsedSeconds ~/ 60} minutos',
              style: pw.TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  static pw.Widget _buildTeamsInfo(MatchModel match) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _buildTeamCard(match.homeTeam, 'Local'),
        _buildTeamCard(match.awayTeam, 'Visitante'),
      ],
    );
  }

  static pw.Widget _buildTeamCard(Team team, String role) {
    return pw.Container(
      width: 200,
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey500, width: 0.5),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text('$role: ${team.name}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          // You can add team logo here if logoUrl is a valid network image and you handle fetching it.
          // For now, text placeholder.
          if (team.logoUrl != null && team.logoUrl!.isNotEmpty)
            pw.Text('Logo: ${team.logoUrl!}'), // Placeholder
          pw.SizedBox(height: 5),
          pw.Text('Jugadores: ${team.players?.length ?? 0}'), // Assuming players list is string IDs
        ],
      ),
    );
  }

  static pw.Widget _buildEventsTimeline(MatchModel match) {
    if (match.detailedEvents.isEmpty) {
      return pw.Text('No hay eventos registrados para este partido.',
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Eventos del Partido',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Minuto', 'Evento', 'Descripción', 'Equipo'],
          data: match.detailedEvents.map((event) {
            return [
              '${event.minute}\'',
              event.eventIcon, // Using the emoji icon from the model
              event.displayText, // Using the formatted text from the model
              event.teamId == match.homeTeam.id ? match.homeTeam.name : match.awayTeam.name,
            ];
          }).toList(),
          border: pw.TableBorder.all(color: PdfColors.grey300),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          cellStyle: const pw.TextStyle(fontSize: 9),
          columnWidths: {
            0: const pw.FlexColumnWidth(0.5),
            1: const pw.FlexColumnWidth(0.5),
            2: const pw.FlexColumnWidth(3),
            3: const pw.FlexColumnWidth(1.5),
          },
        ),
      ],
    );
  }
}
