import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_team_card.dart';
import '../../../../core/widgets/custom_tournament_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/domain/model/team.dart';
import '../../../match/domain/models/match_model.dart';
import '../../../match/ui/screens/match_control_screen.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final supabase = Supabase.instance.client;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await supabase
        .from('profiles')
        .select('name')
        .eq('user_id', user.id)
        .maybeSingle();

    if (!mounted) return;
    setState(() {
      name = response?['name'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final teams = [
      'Equipo A',
      'Equipo B',
      'Equipo C',
      'Equipo D',
      'Equipo E',
      'Equipo F',
      'Equipo G',
      'Equipo H',
      'Equipo J',
      'Equipo k',
    ];

    final tournaments = [
      const CustomTournamentCard(
        date: '30 sept.',
        status: 'Finalizado',
        description:
            'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día lleno de deporte y diversión.',
      ),
      const CustomTournamentCard(
        date: '12 sept.',
        status: 'Activo',
        description:
            'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día.',
      ),
      const CustomTournamentCard(
        date: '30 sept.',
        status: 'Próximo',
        description:
            'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día.',
      ),
      const CustomTournamentCard(
        date: '30 sept.',
        status: 'Próximo',
        description:
            'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día.',
      ),
      const CustomTournamentCard(
        date: '30 sept.',
        status: 'Próximo',
        description:
            'El Torneo Universitario de Fútbol se realizará en [lugar]. Ven a disfrutar de la emoción del juego, apoyar a tu equipo y compartir un día.',
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            [
                  // 🔹 Información personal
                  _buildSection(
                    title: 'Información personal',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading
                              ? 'Cargando...'
                              : (name ?? 'Usuario desconocido'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Añade una descripción',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Editar'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Control de Partido (Demo)
                  _buildSection(
                    title: 'Funciones de Árbitro',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sistema completo de gestión de partidos',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Botón Agendar Partido
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/schedule-match');
                            },
                            icon: const Icon(Icons.event),
                            label: const Text('Agendar Partido'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Botón Controlar Partido
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/select-match-to-control');
                            },
                            icon: const Icon(Icons.sports_soccer),
                            label: const Text('Controlar Partido'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Equipos
                  _buildSection(
                    title: 'Equipos que sigues',
                    content: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 3 / 1.2,
                            children: teams
                                .take(9)
                                .map((team) => CustomTeamCard(teamName: team))
                                .toList(),
                          ),
                        ),
                        if (teams.length > 9)
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: TextButton(
                              onPressed: () {
                                print('Ver todos los equipos');
                              },
                              child: const Text(
                                'Ver todos los equipos',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 🔹 Torneos
                  _buildSection(
                    title: 'Torneos que sigues',
                    content: Column(
                      children: [
                        ...tournaments
                            .take(4)
                            .map(
                              (card) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: card,
                              ),
                            ),
                        if (tournaments.length > 4)
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/tournaments');
                              },
                              child: const Text(
                                'Ver todos los torneos',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 🔹 Cerrar sesión
                  _buildSection(
                    content: Column(
                      children: [
                        CustomButton(
                          text: 'Cerrar sesión',
                          color: AppColors.background,
                          textColor: AppColors.error,
                          borderColor: AppColors.error,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                title: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text(
                                  '¿Estás seguro de que quieres cerrar sesión?',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      );
                                    },
                                    child: const Text(
                                      'Cerrar sesión',
                                      style: TextStyle(color: AppColors.error),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: child,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildSection({String? title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
          ),
          child: content,
        ),
      ],
    );
  }
}
