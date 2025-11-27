import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../domain/models/match_model.dart';
import '../../domain/models/match_event_model.dart';
import '../../../games/domain/models/game_model.dart';

class MatchPdfService {
  static final _primaryColor = PdfColor.fromHex('#6366F1');
  static final _darkText = PdfColor.fromHex('#374151');
  static final _lightText = PdfColor.fromHex('#9CA3AF');
  static final _homeColor = PdfColor.fromHex('#E63946');
  static final _awayColor = PdfColor.fromHex('#F59E0B');
  static final _successColor = PdfColor.fromHex('#10B981');
  static final _warningColor = PdfColor.fromHex('#F59E0B');
  static final _dangerColor = PdfColor.fromHex('#EF4444');

  static Future<Uint8List> generateMatchReport({
    required MatchModel match,
    required GameStatistics statistics,
    String? tournamentName,
  }) async {
    final pdf = pw.Document();
    
    final dateFormat = DateFormat('dd MMMM yyyy', 'es');
    final timeFormat = DateFormat('HH:mm');
    final now = DateTime.now();

    // Limit events to prevent too many pages (max 10 events to ensure it fits)
    final limitedEvents = match.detailedEvents.length > 10 
        ? match.detailedEvents.take(10).toList()
        : match.detailedEvents;
    final hasMoreEvents = match.detailedEvents.length > 10;

    // Create a temporary match with limited events for PDF generation
    final matchForPdf = MatchModel(
      id: match.id,
      homeTeam: match.homeTeam,
      awayTeam: match.awayTeam,
      homeScore: match.homeScore,
      awayScore: match.awayScore,
      elapsedSeconds: match.elapsedSeconds,
      status: match.status,
      currentHalf: match.currentHalf,
      detailedEvents: limitedEvents,
      tournamentId: match.tournamentId,
      scheduledDate: match.scheduledDate,
    );

    // Use MultiPage with strict limits
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Header
            _buildHeader(),
            pw.SizedBox(height: 20),
            
            // Match Score Card (same as screen)
            _buildScoreCard(matchForPdf, tournamentName),
            pw.SizedBox(height: 24),
            
            // Statistics Section (same format as screen)
            _buildStatisticsSection(statistics),
            pw.SizedBox(height: 32),
            
            // Events Timeline (if any)
            if (limitedEvents.isNotEmpty) ...[
              _buildEventsSectionCompact(matchForPdf, hasMoreEvents: hasMoreEvents, totalEvents: match.detailedEvents.length),
              pw.SizedBox(height: 32),
            ],
            
            // Footer
            _buildFooter(dateFormat, timeFormat, now),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _primaryColor,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'MATCH TRACK',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildScoreCard(MatchModel match, String? tournamentName) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Column(
        children: [
          // Tournament badge (like in the screen)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#EEF2FF'),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  tournamentName ?? 'Amistoso',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          
          // Teams and Score (exact same layout as screen)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              // Home Team
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Text(
                      match.homeTeam.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: _darkText,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      match.homeScore.toString(),
                      style: pw.TextStyle(
                        fontSize: 48,
                        fontWeight: pw.FontWeight.bold,
                        color: _homeColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Separator
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16),
                child: pw.Text(
                  '-',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: _lightText,
                  ),
                ),
              ),
              
              // Away Team
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Text(
                      match.awayTeam.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: _darkText,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      match.awayScore.toString(),
                      style: pw.TextStyle(
                        fontSize: 48,
                        fontWeight: pw.FontWeight.bold,
                        color: _awayColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMatchInfo(MatchModel match, DateFormat dateFormat, DateTime now) {
    final duration = '${(match.elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(match.elapsedSeconds % 60).toString().padLeft(2, '0')}';
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoItem('Fecha', dateFormat.format(now)),
          _buildInfoItem('Duración', duration),
          _buildInfoItem('Estado', _getStatusText(match.status)),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: _lightText,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _darkText,
          ),
        ),
      ],
    );
  }

  static String _getStatusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.finished:
        return 'Finalizado';
      case MatchStatus.running:
        return 'En curso';
      case MatchStatus.paused:
        return 'Pausado';
      case MatchStatus.scheduled:
        return 'Programado';
      default:
        return 'Pendiente';
    }
  }

  static pw.Widget _buildStatisticsSection(GameStatistics stats) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Estadísticas del Partido',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: _darkText,
            ),
          ),
          pw.SizedBox(height: 20),
          
          // Statistics rows (same format as screen)
          _buildStatRow('Goles', stats.homeGoals, stats.awayGoals, _successColor),
          pw.SizedBox(height: 16),
          _buildStatRow('Tarjetas Amarillas', stats.homeYellowCards, stats.awayYellowCards, _warningColor),
          pw.SizedBox(height: 16),
          _buildStatRow('Tarjetas Rojas', stats.homeRedCards, stats.awayRedCards, _dangerColor),
          pw.SizedBox(height: 16),
          _buildStatRow('Faltas', stats.homeFouls, stats.awayFouls, _primaryColor),
          pw.SizedBox(height: 16),
          _buildStatRow('Fueras de juego', stats.homeOffsides, stats.awayOffsides, _primaryColor),
          pw.SizedBox(height: 16),
          _buildStatRow('Lesiones', stats.homeInjuries, stats.awayInjuries, PdfColor.fromHex('#6B7280')),
        ],
      ),
    );
  }

  static pw.Widget _buildStatRow(String label, int homeValue, int awayValue, PdfColor color) {
    final total = homeValue + awayValue;
    final homePercent = total > 0 ? (homeValue / total * 100).round() : 50;
    final awayPercent = total > 0 ? (awayValue / total * 100).round() : 50;

    return pw.Column(
      children: [
        // Label and values (same as screen)
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              homeValue.toString(),
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color: _darkText,
              ),
            ),
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 13,
                color: _lightText,
              ),
            ),
            pw.Text(
              awayValue.toString(),
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color: _darkText,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        
        // Bar (same as screen)
        pw.Row(
          children: [
            pw.Expanded(
              flex: homePercent > 0 ? homePercent : 1,
              child: pw.Container(
                height: 8,
                decoration: pw.BoxDecoration(
                  color: color,
                  borderRadius: const pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(4),
                    bottomLeft: pw.Radius.circular(4),
                  ),
                ),
              ),
            ),
            pw.Expanded(
              flex: awayPercent > 0 ? awayPercent : 1,
              child: pw.Container(
                height: 8,
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#E5E7EB'), // Light gray for away team (like screen)
                  borderRadius: const pw.BorderRadius.only(
                    topRight: pw.Radius.circular(4),
                    bottomRight: pw.Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildEventsSectionCompact(MatchModel match, {bool hasMoreEvents = false, int totalEvents = 0}) {
    final sortedEvents = List<MatchEventDetail>.from(match.detailedEvents)
      ..sort((a, b) => a.minute.compareTo(b.minute));

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 4,
                height: 18,
                decoration: pw.BoxDecoration(
                  color: _primaryColor,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'CRONOLOGÍA DE EVENTOS',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: _darkText,
                ),
              ),
            ],
          ),
          if (hasMoreEvents) ...[
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'Mostrando 10 de $totalEvents eventos',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.orange900,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ],
          pw.SizedBox(height: 12),
          
          // Events list - compact version
          ...sortedEvents.map((event) => _buildEventRowCompact(event, match)),
        ],
      ),
    );
  }

  static pw.Widget _buildEventsSection(MatchModel match, {bool hasMoreEvents = false, int totalEvents = 0}) {
    final sortedEvents = List<MatchEventDetail>.from(match.detailedEvents)
      ..sort((a, b) => a.minute.compareTo(b.minute));

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 4,
                height: 20,
                decoration: pw.BoxDecoration(
                  color: _primaryColor,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                'CRONOLOGÍA DE EVENTOS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: _darkText,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          if (hasMoreEvents) ...[
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.orange50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Mostrando 10 de $totalEvents eventos',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.orange900,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ],
          pw.SizedBox(height: 20),
          
          // Events list
          ...sortedEvents.map((event) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: _buildEventRow(event, match),
          )),
        ],
      ),
    );
  }

  static pw.Widget _buildEventRowCompact(MatchEventDetail event, MatchModel match) {
    final isHome = event.teamId == match.homeTeam.id;
    final eventColor = _getEventColor(event.type);
    
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          // Left border bar
          pw.Container(
            width: 3,
            decoration: pw.BoxDecoration(
              color: eventColor,
            ),
          ),
          // Content container
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                    width: 35,
                    child: pw.Text(
                      "${event.minute}'",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: eventColor,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: pw.BoxDecoration(
                      color: eventColor,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      _getEventIcon(event.type),
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Text(
                      _getEventDescription(event, isHome ? match.homeTeam.name : match.awayTeam.name),
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: _darkText,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: pw.BoxDecoration(
                      color: isHome ? PdfColors.red50 : PdfColors.orange50,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      isHome ? 'L' : 'V',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: isHome ? _homeColor : _awayColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildEventRow(MatchEventDetail event, MatchModel match) {
    final isHome = event.teamId == match.homeTeam.id;
    final teamName = isHome ? match.homeTeam.name : match.awayTeam.name;
    final eventColor = _getEventColor(event.type);
    
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Left border (colored bar)
        pw.Container(
          width: 3,
          decoration: pw.BoxDecoration(
            color: eventColor,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(8),
              bottomLeft: pw.Radius.circular(8),
            ),
          ),
        ),
        
        // Content container
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: const pw.BorderRadius.only(
                topRight: pw.Radius.circular(8),
                bottomRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Row(
              children: [
                // Minute
                pw.SizedBox(
                  width: 40,
                  child: pw.Text(
                    "${event.minute}'",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: eventColor,
                    ),
                  ),
                ),
                
                // Event icon
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: eventColor,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    _getEventIcon(event.type),
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                
                // Event details
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _getEventTitle(event.type),
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: _darkText,
                        ),
                      ),
                      pw.Text(
                        _getEventDescription(event, teamName),
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: _lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Team indicator
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: isHome ? PdfColors.red50 : PdfColors.orange50,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    isHome ? 'L' : 'V',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: isHome ? _homeColor : _awayColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static PdfColor _getEventColor(EventType type) {
    switch (type) {
      case EventType.goal:
        return _successColor;
      case EventType.redCard:
        return _dangerColor;
      case EventType.yellowCard:
        return _warningColor;
      case EventType.substitution:
        return PdfColor.fromHex('#6B7280');
      case EventType.foul:
        return PdfColor.fromHex('#9CA3AF');
      case EventType.offside:
        return PdfColor.fromHex('#9CA3AF');
      case EventType.injury:
        return PdfColor.fromHex('#EF4444');
      case EventType.halfTime:
        return _primaryColor;
      case EventType.fullTime:
        return _primaryColor;
    }
  }

  static String _getEventIcon(EventType type) {
    switch (type) {
      case EventType.goal:
        return 'GOL';
      case EventType.redCard:
        return 'ROJA';
      case EventType.yellowCard:
        return 'AMAR';
      case EventType.substitution:
        return 'CAMB';
      case EventType.foul:
        return 'FALTA';
      case EventType.offside:
        return 'OFF';
      case EventType.injury:
        return 'LES';
      case EventType.halfTime:
        return 'MT';
      case EventType.fullTime:
        return 'FT';
    }
  }

  static String _getEventTitle(EventType type) {
    switch (type) {
      case EventType.goal:
        return 'Gol';
      case EventType.redCard:
        return 'Tarjeta Roja';
      case EventType.yellowCard:
        return 'Tarjeta Amarilla';
      case EventType.substitution:
        return 'Sustitución';
      case EventType.foul:
        return 'Falta';
      case EventType.offside:
        return 'Fuera de Juego';
      case EventType.injury:
        return 'Lesión';
      case EventType.halfTime:
        return 'Medio Tiempo';
      case EventType.fullTime:
        return 'Final';
    }
  }

  static String _getEventDescription(MatchEventDetail event, String teamName) {
    switch (event.type) {
      case EventType.goal:
        final scorer = event.scorer?.name ?? 'Desconocido';
        final assist = event.assist?.name;
        return assist != null ? '$scorer (Asist: $assist) - $teamName' : '$scorer - $teamName';
      case EventType.redCard:
      case EventType.yellowCard:
        return '${event.player?.name ?? 'Jugador'} #${event.player?.number ?? '?'} - $teamName';
      case EventType.substitution:
        return 'Sale: ${event.playerOut?.name ?? '?'} → Entra: ${event.playerIn?.name ?? '?'}';
      case EventType.foul:
        return event.description ?? teamName;
      case EventType.injury:
        return event.player?.name ?? teamName;
      case EventType.halfTime:
        return 'Entretiempo';
      case EventType.fullTime:
        return 'Fin del partido';
      default:
        return teamName;
    }
  }

  static pw.Widget _buildFooter(DateFormat dateFormat, DateFormat timeFormat, DateTime now) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generado por Match Track',
            style: pw.TextStyle(
              fontSize: 10,
              color: _lightText,
            ),
          ),
          pw.Text(
            '${dateFormat.format(now)} - ${timeFormat.format(now)}',
            style: pw.TextStyle(
              fontSize: 10,
              color: _lightText,
            ),
          ),
        ],
      ),
    );
  }

  /// Download the PDF directly
  static Future<void> downloadMatchReport({
    required MatchModel match,
    required GameStatistics statistics,
    String? tournamentName,
  }) async {
    final pdfBytes = await generateMatchReport(
      match: match,
      statistics: statistics,
      tournamentName: tournamentName,
    );

    // Use XFile.fromData which works on all platforms (web, mobile, desktop)
    final fileName = 'match_report_${match.homeTeam.name}_vs_${match.awayTeam.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final xFile = XFile.fromData(
      pdfBytes,
      mimeType: 'application/pdf',
      name: fileName,
    );
    
    // Share will trigger download on web and save dialog on mobile
    await Share.shareXFiles(
      [xFile],
      subject: 'Reporte de Partido: ${match.homeTeam.name} vs ${match.awayTeam.name}',
      text: '${match.homeTeam.name} ${match.homeScore} - ${match.awayScore} ${match.awayTeam.name}',
    );
  }

  // ============== GameModel Support ==============

  /// Calculate statistics from events
  static GameStatistics _calculateStatisticsFromEvents(
    List<MatchEventDetail> events,
    String homeTeamId,
    String awayTeamId,
  ) {
    int homeGoals = 0;
    int awayGoals = 0;
    int homeYellowCards = 0;
    int awayYellowCards = 0;
    int homeRedCards = 0;
    int awayRedCards = 0;
    int homeFouls = 0;
    int awayFouls = 0;
    int homeOffsides = 0;
    int awayOffsides = 0;
    int homeInjuries = 0;
    int awayInjuries = 0;

    for (final event in events) {
      final isHomeTeam = event.teamId == homeTeamId;
      
      switch (event.type) {
        case EventType.goal:
          if (isHomeTeam) {
            homeGoals++;
          } else {
            awayGoals++;
          }
          break;
        case EventType.yellowCard:
          if (isHomeTeam) {
            homeYellowCards++;
          } else {
            awayYellowCards++;
          }
          break;
        case EventType.redCard:
          if (isHomeTeam) {
            homeRedCards++;
          } else {
            awayRedCards++;
          }
          break;
        case EventType.foul:
          if (isHomeTeam) {
            homeFouls++;
          } else {
            awayFouls++;
          }
          break;
        case EventType.offside:
          if (isHomeTeam) {
            homeOffsides++;
          } else {
            awayOffsides++;
          }
          break;
        case EventType.injury:
          if (isHomeTeam) {
            homeInjuries++;
          } else {
            awayInjuries++;
          }
          break;
        default:
          // Other events don't affect statistics
          break;
      }
    }

    return GameStatistics(
      homeGoals: homeGoals,
      awayGoals: awayGoals,
      homeYellowCards: homeYellowCards,
      awayYellowCards: awayYellowCards,
      homeRedCards: homeRedCards,
      awayRedCards: awayRedCards,
      homeFouls: homeFouls,
      awayFouls: awayFouls,
      homeOffsides: homeOffsides,
      awayOffsides: awayOffsides,
      homeInjuries: homeInjuries,
      awayInjuries: awayInjuries,
    );
  }

  /// Generate PDF report from a GameModel (for finished matches list)
  static Future<Uint8List> generateGameReport({
    required GameModel game,
  }) async {
    // Convert GameModel to MatchModel format for PDF generation
    final match = MatchModel(
      id: game.id,
      homeTeam: game.homeTeam,
      awayTeam: game.awayTeam,
      homeScore: game.homeScore,
      awayScore: game.awayScore,
      status: MatchStatus.finished,
      elapsedSeconds: 90 * 60, // Default 90 minutes for finished games
      detailedEvents: game.events,
      tournamentId: game.tournamentId,
    );

    // Calculate statistics from events if not provided
    final statistics = game.statistics ?? 
        _calculateStatisticsFromEvents(
          game.events,
          game.homeTeam.id,
          game.awayTeam.id,
        );

    return generateMatchReport(
      match: match,
      statistics: statistics,
      tournamentName: game.tournamentName,
    );
  }

  /// Download a GameModel report
  static Future<void> downloadGameReport({
    required GameModel game,
  }) async {
    final pdfBytes = await generateGameReport(game: game);

    // Use XFile.fromData which works on all platforms (web, mobile, desktop)
    final fileName = 'match_report_${game.homeTeam.name}_vs_${game.awayTeam.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final xFile = XFile.fromData(
      pdfBytes,
      mimeType: 'application/pdf',
      name: fileName,
    );
    
    // Share will trigger download on web and save dialog on mobile
    await Share.shareXFiles(
      [xFile],
      subject: 'Reporte de Partido: ${game.homeTeam.name} vs ${game.awayTeam.name}',
      text: '${game.homeTeam.name} ${game.homeScore} - ${game.awayScore} ${game.awayTeam.name}',
    );
  }
}

