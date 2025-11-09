import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/source/tournament_remote_data_source.dart';
import '../../data/repository/tournament_repository_impl.dart';
import '../../data/models/tournament_model.dart';
import '../../domain/usecases/create_tournament.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedSport = 'Fútbol';
  bool _loading = false;

  late final CreateTournament _createTournament;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final remote = TournamentRemoteDataSource(client);
    final repo = TournamentRepositoryImpl(remoteDataSource: remote);
    _createTournament = CreateTournament(repo);
  }

  Future<void> _createTournamentAction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para crear un torneo.'),
        ),
      );
      setState(() => _loading = false);
      return;
    }

    try {
      final model = TournamentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        sport: _selectedSport,
        creatorId: user.id,
        createdAt: DateTime.now(),
      );

      await _createTournament(model);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Torneo creado con éxito.')),
        );
      }
    } catch (e) {
      print('Error al crear torneo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el torneo.')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Torneo'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del torneo',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSport,
                decoration: const InputDecoration(labelText: 'Deporte'),
                items: const [
                  DropdownMenuItem(value: 'Fútbol', child: Text('Fútbol')),
                  DropdownMenuItem(
                    value: 'Baloncesto',
                    child: Text('Baloncesto'),
                  ),
                  DropdownMenuItem(value: 'Vóleibol', child: Text('Vóleibol')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (value) => setState(() => _selectedSport = value!),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _loading ? 'Creando...' : 'Crear torneo',
                onPressed: _loading ? null : _createTournamentAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
