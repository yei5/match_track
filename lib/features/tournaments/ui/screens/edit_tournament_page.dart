import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditTournamentPage extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const EditTournamentPage({Key? key, required this.tournament})
      : super(key: key);

  @override
  _EditTournamentPageState createState() => _EditTournamentPageState();
}

class _EditTournamentPageState extends State<EditTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _sport;
  late String _category;
  bool _isLoading = false;

  // Use the exact values expected by the database check constraint
  final List<String> _sports = ['Fútbol', 'Baloncesto', 'Vóleibol'];
  final List<String> _categories = ['Masculino', 'Femenino', 'Mixto'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tournament['name']);
    _descriptionController =
        TextEditingController(text: widget.tournament['description']);

    // Safely initialize _sport without converting to lower case
    final initialSport = widget.tournament['sport'] as String?;
    if (initialSport != null && _sports.contains(initialSport)) {
      _sport = initialSport;
    } else {
      _sport = _sports.first;
    }

    // Safely initialize _category without converting to lower case
    final initialCategory = widget.tournament['category'] as String?;
    if (initialCategory != null && _categories.contains(initialCategory)) {
      _category = initialCategory;
    } else {
      _category = _categories.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tournamentId = widget.tournament['id'];
      if (tournamentId == null) {
        throw 'El ID del torneo no se encontró.';
      }

      final updatedData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'sport': _sport,
        'category': _category,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client
          .from('tournaments')
          .update(updatedData)
          .eq('id', tournamentId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Torneo actualizado con éxito.')),
        );
        // Pop twice to go back to the tournament list, not the detail page
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el torneo: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Torneo'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Torneo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'El nombre no puede estar vacío'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _sport,
                  decoration: const InputDecoration(
                    labelText: 'Deporte',
                    border: OutlineInputBorder(),
                  ),
                  items: _sports.map((String sport) {
                    return DropdownMenuItem<String>(
                      value: sport,
                      child: Text(sport),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _sport = newValue);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _category = newValue);
                    }
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
