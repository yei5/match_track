import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:match_track/core/widgets/custom_button.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Uuid _uuid = const Uuid();
  String _selectedSport = 'Fútbol';
  String? _selectedCategory;
  bool _loading = false;

  // ✅ VALORES EXACTOS según tu base de datos
  final List<String> _categories = ['Masculino', 'Femenino', 'Mixto'];

  // ✅ STATUS válidos según tu base de datos
  final List<String> _statusOptions = ['Activo', 'Programado', 'Finalizado'];

  Future<void> _createTournament() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

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
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error: No se encontró tu perfil. Por favor, completa tu perfil primero.',
            ),
          ),
        );
        setState(() => _loading = false);
        return;
      }

      final team1Id = _uuid.v4();
      final team2Id = _uuid.v4();

      // ✅ USAR LOS VALORES EXACTOS de la base de datos
      final tournamentData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'sport': _selectedSport,
        'category': _selectedCategory!, // 'Masculino', 'Femenino' o 'Mixto'
        'user_id': user.id,
        'status': 'Programado', // ✅ 'Activo', 'Programado' o 'Finalizado'
        'start_date': DateTime.now().toIso8601String().split('T')[0],
        'end_date': DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String()
            .split('T')[0],
        'team1_id': team1Id,
        'team2_id': team2Id,
        'image_url': null,
      };

      print('📤 Enviando datos: $tournamentData');

      final response = await Supabase.instance.client
          .from('tournaments')
          .insert(tournamentData)
          .select();

      print('✅ Torneo creado exitosamente: $response');

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Torneo creado con éxito.')),
        );
      }
    } catch (e) {
      print('❌ Error completo al crear torneo: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear el torneo: ${e.toString()}'),
          duration: const Duration(seconds: 10),
        ),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Selecciona una categoría',
                ),
                validator: (value) =>
                    value == null ? 'Por favor selecciona una categoría' : null,
                items: _categories.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _loading ? 'Creando...' : 'Crear torneo',
                onPressed: _loading ? null : _createTournament,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
