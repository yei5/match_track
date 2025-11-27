import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/widgets/app_header.dart';
import 'package:match_track/core/widgets/minimizable_nav_bar.dart';
import '../widgets/tournament_filter_bar.dart';
import '../widgets/tournament_card.dart';
import '../widgets/empty_tournaments_state.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({super.key});

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

      print('🔄 Cargando torneos para usuario: ${user.id}');

      // Verificar si el usuario tiene perfil
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se encontró tu perfil.')),
        );
        return;
      }

      // Cargar torneos del usuario
      final response = await supabase
          .from('tournaments')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      print('✅ Torneos cargados: ${response.length} torneos encontrados');

      setState(() {
        tournaments = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('❌ Error completo cargando torneos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los torneos: ${e.toString()}'),
          duration: const Duration(seconds: 10),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _goToCreateTournament() async {
    await Navigator.pushNamed(context, '/createTournament');
    _loadTournaments(); // Recargar la lista después de crear
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Torneos', showBackButton: false),

      floatingActionButton: tournaments.isNotEmpty
          ? FloatingActionButton(
              onPressed: _goToCreateTournament,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.surface, size: 28),
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                '/tournamentDetail',
                                arguments: tournament,
                              );
                              _loadTournaments(); // Recargar al volver
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StandardNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/games');
              break;
            case 1:
              break; // Ya estamos aquí
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
}
