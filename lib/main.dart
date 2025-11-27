import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match_track/features/auth/data/repository/auth_repository_impl.dart';
import 'package:match_track/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:match_track/features/auth/ui/bloc/signup_bloc.dart';
import 'package:match_track/features/auth/ui/screens/login_screen.dart';
import 'package:match_track/features/auth/ui/screens/signup_screen.dart';
import 'package:match_track/features/players/data/repository/player_repository_impl.dart';
import 'package:match_track/features/players/data/source/player_remote_data_source.dart';
import 'package:match_track/features/players/domain/usecases/create_player.dart';
import 'package:match_track/features/players/domain/usecases/delete_player.dart';
import 'package:match_track/features/players/domain/usecases/get_players_for_team.dart';
import 'package:match_track/features/profile/ui/screens/profile_page.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/features/teams/data/source/team_remote_data_source.dart';
import 'package:match_track/features/teams/domain/usecases/create_team.dart';
import 'package:match_track/features/teams/domain/usecases/get_team_detail.dart';
import 'package:match_track/features/teams/domain/usecases/get_teams.dart';
import 'package:match_track/features/teams/domain/usecases/delete_team_usecase.dart';
import 'package:match_track/features/teams/domain/usecases/update_team_usecase.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/screens/team_form_page.dart';
import 'package:match_track/features/teams/ui/screens/teams_page.dart';
import 'package:match_track/features/tournaments/ui/screens/create_tournament_page.dart';
import 'package:match_track/features/tournaments/ui/screens/edit_tournament_page.dart';
import 'package:match_track/features/tournaments/ui/screens/tournament_detail_page.dart';
import 'package:match_track/features/tournaments/ui/screens/tournaments_page.dart';
import 'package:match_track/features/games/ui/screens/games_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignupBloc()),
        BlocProvider(
          create: (_) {
            // Team Feature Dependencies
            final teamRemoteDataSource = TeamRemoteDataSourceImpl();
            final teamRepository =
                TeamRepositoryImpl(remoteDataSource: teamRemoteDataSource);
            final getTeams = GetTeams(repository: teamRepository);
            final getTeamDetail = GetTeamDetail(repository: teamRepository);
            final createTeamUseCase = CreateTeam(repository: teamRepository);
            final deleteTeamUseCase =
                DeleteTeamUseCase(teamRepository: teamRepository);
            final updateTeamUseCase =
                UpdateTeamUseCase(teamRepository: teamRepository);
            final authRepository =
                AuthRepositoryImpl();
            final getCurrentUser =
                GetCurrentUserUsecase(repository: authRepository);

            // Player dependencies for TeamBloc
            final playerRemoteDataSource = PlayerRemoteDataSourceImpl();
            final playerRepository =
                PlayerRepositoryImpl(remoteDataSource: playerRemoteDataSource);
            final getPlayersForTeam =
                GetPlayersForTeam(repository: playerRepository);
            final createPlayerUseCase =
                CreatePlayer(repository: playerRepository);
            final deletePlayerUseCase =
                DeletePlayerUseCase(playerRepository: playerRepository);

            return TeamBloc(
              getTeams: getTeams,
              getTeamDetail: getTeamDetail,
              createTeam: createTeamUseCase,
              deleteTeam: deleteTeamUseCase,
              updateTeam: updateTeamUseCase,
              getCurrentUser: getCurrentUser,
              getPlayersForTeam: getPlayersForTeam,
              createPlayer: createPlayerUseCase,
              deletePlayer: deletePlayerUseCase,
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'MatchTrack',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/signup',
        routes: {
          '/signup': (_) => const SignupScreen(),
          '/login': (_) => const LoginScreen(),
          '/profile': (_) => const ProfilePage(),
          '/tournaments': (_) => const TournamentsPage(),
          '/createTournament': (_) => const CreateTournamentPage(),
          '/teams': (_) => const TeamsPage(),
          '/createTeam': (_) => const TeamFormPage(),
          '/games': (_) => const GamesListScreen(),
          '/tournamentDetail': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return TournamentDetailPage(tournament: args);
          },
          '/editTournament': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return EditTournamentPage(tournament: args);
          },
        },
      ),
    );
  }
}