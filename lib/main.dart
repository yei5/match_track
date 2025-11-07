// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 🔹 Imports de tus pantallas existentes
import 'features/auth/ui/bloc/signup_bloc.dart';
import 'features/auth/ui/screens/signup_screen.dart';
import 'features/auth/ui/screens/login_screen.dart';
import 'features/profile/ui/screens/profile_page.dart';

// 🔹 Import de tu nueva pantalla
import 'features/team_details/ui/screens/details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de entorno y Supabase
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatchTrack',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // 🔹 TEMPORAL: inicia directamente en tu pantalla para probarla
      initialRoute: '/team-details',

      // 🔹 Rutas de toda la app
      routes: {
        '/signup': (_) =>
            BlocProvider(create: (_) => SignupBloc(), child: SignupScreen()),
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfilePage(),
        '/team-details': (_) => const TeamDetailsScreen(), // 👈 nueva ruta
      },
    );
  }
}
