import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/nav_bar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/source/tournament_remote_data_source.dart';
import '../../data/repository/tournament_repository_impl.dart';
import '../../domain/usecases/get_tournaments.dart';
import '../widgets/tournament_card.dart';
import '../widgets/tournament_filter_bar.dart';
import '../widgets/empty_tournaments_state.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({Key? key}) : super(key: key);

  @override
  State<TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  String selectedSport = 'Todos';
  String selectedStatus = 'Todos';
  bool showMyTournaments = true;

  List<Map<String, dynamic>> tournaments = [];
  bool isLoading = true;

  late final GetTournaments _getTournaments;

  @override
  void initState() {
    super.initState();

    // Inicializa datasource -> repository -> usecase (sin crear archivos extra)
    final client = Supabase.instance.client;
    final remote = TournamentRemoteDataSource(client);
    final repo = TournamentRepositoryImpl(remoteDataSource: remote);
    _getTournaments = GetTournaments(repo);

    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    try {
      setState(() => isLoading = true);

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes iniciar sesión para ver tus torneos.'),
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      final result = await _getTournaments(user.id);

      // result es List<TournamentEntity>, convertimos a Map para los widgets actuales
      tournaments = result.map((e) {
        return {
          'id': e.id,
          'name': e.name,
          'description': e.description,
          'sport': e.sport,
          'image_url': e.imageUrl,
          'status': e.status,
          'start_date': e.startDate,
          'end_date': e.endDate,
          'team_a': e.teamA,
          'team_b': e.teamB,
          'creator_id': e.creatorId,
          'created_at': e.createdAt?.toIso8601String(),
        };
      }).toList();
    } catch (e) {
      print('Error cargando torneos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los torneos.')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _goToCreateTournament() async {
    await Navigator.pushNamed(context, '/createTournament');
    await _loadTournaments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Torneos', showBackButton: false),
      body: RefreshIndicator(
        onRefresh: _loadTournaments,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TournamentFilterBar(
                selectedSport: selectedSport,
                selectedStatus: selectedStatus,
                showMyTournaments: showMyTournaments,
                onSportChanged: (value) =>
                    setState(() => selectedSport = value),
                onStatusChanged: (value) =>
                    setState(() => selectedStatus = value),
                onToggleMyTournaments: (value) =>
                    setState(() => showMyTournaments = value),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : tournaments.isEmpty
                    ? EmptyTournament(onCreatePressed: _goToCreateTournament)
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: tournaments.length,
                        itemBuilder: (context, index) {
                          final tournament = tournaments[index];
                          return TournamentCard(
                            tournament: tournament,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/tournamentDetail',
                                arguments: tournament,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreateTournament,
        icon: const Icon(Icons.add),
        label: const Text('Crear torneo'),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
