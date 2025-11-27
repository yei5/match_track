import 'package:flutter/material.dart';
import '../../domain/models/game_model.dart';
import '../../../match/data/repository/match_repository.dart';
import '../../../match/domain/models/match_model.dart';
import '../widgets/game_card.dart';
import 'game_detail_screen.dart';
import '../../../../core/theme/app_colors_new.dart';
import '../../../../core/widgets/standard_nav_bar.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final _matchRepository = MatchRepository();
  List<GameModel> _games = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() => _isLoading = true);
    try {
      final matches = await _matchRepository.getFinishedMatches();
      // Convertir MatchModel a GameModel
      setState(() {
        _games = matches.map((match) => _matchToGame(match)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  GameModel _matchToGame(MatchModel match) {
    return GameModel(
      id: match.id,
      tournamentId: match.tournamentId ?? 'friendly',
      tournamentName: match.tournamentId != null ? 'Torneo' : 'Amistoso',
      homeTeam: match.homeTeam,
      awayTeam: match.awayTeam,
      homeScore: match.homeScore,
      awayScore: match.awayScore,
      status: GameStatus.finished,
      scheduledDate: match.scheduledDate ?? DateTime.now(),
      events: match.detailedEvents,
    );
  }

  List<GameModel> get _filteredGames {
    // Ya están todos finalizados, solo retornar la lista
    return _games;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mis Partidos'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredGames.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadGames,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = _filteredGames[index];
                      return GameCard(
                        game: game,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailScreen(game: game),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
      bottomNavigationBar: StandardNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break; // Ya estamos aquí
            case 1:
              Navigator.pushReplacementNamed(context, '/tournaments');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/teams');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer_outlined,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay partidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los partidos aparecerán aquí',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
