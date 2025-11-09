import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/widgets/app_header.dart';
import 'package:match_track/core/widgets/nav_bar.dart';
import '../widgets/tournament_filter_bar.dart';
import '../widgets/tournament_card.dart';
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

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    try {
      setState(() => isLoading = true);

      final user = supabase.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes iniciar sesión para ver tus torneos.'),
          ),
        );
        return;
      }

      final response = await supabase
          .from('tournaments')
          .select()
          .eq('creator_id', user.id)
          .order('created_at', ascending: false);

      setState(() {
        tournaments = List<Map<String, dynamic>>.from(response);
      });
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
    _loadTournaments();
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
