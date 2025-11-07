import 'package:flutter/material.dart';
import 'package:match_track/features/tournaments/ui/screens/create_tournament_page.dart';
import 'package:match_track/features/tournaments/ui/screens/tournament_detail_page.dart';
import 'package:match_track/features/tournaments/ui/screens/tournaments_page.dart';
import 'features/profile/ui/screens/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/features/auth/ui/bloc/signup_bloc.dart';
import 'package:match_track/features/auth/ui/screens/signup_screen.dart';
import 'package:match_track/features/auth/ui/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatchTrack',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (_) =>
            BlocProvider(create: (_) => SignupBloc(), child: SignupScreen()),
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfilePage(),
        '/tournaments': (context) => const TournamentsPage(),
        '/createTournament': (context) => const CreateTournamentPage(),
        '/tournamentDetail': (context) =>
            const TournamentDetailPage(tournament: {}),
      },
    );
  }
}
