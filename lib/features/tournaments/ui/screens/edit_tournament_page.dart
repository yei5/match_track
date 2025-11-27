import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/data/repository/team_repository_impl.dart';
import 'package:match_track/features/teams/data/source/team_remote_data_source.dart';

class EditTournamentPage extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const EditTournamentPage({super.key, required this.tournament});

  @override
  _EditTournamentPageState createState() => _EditTournamentPageState();
}

class _EditTournamentPageState extends State<EditTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _teamRepository = TeamRepositoryImpl(remoteDataSource: TeamRemoteDataSourceImpl());
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _sport;
  late String _category;
  bool _isLoading = false;
  List<Team> _teams = [];
  final List<String> _selectedTeamIds = [];
  bool _loadingTeams = false;

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
    
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() => _loadingTeams = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final teams = await _teamRepository.getTeams(userId);
        setState(() {
          _teams = teams;
          _loadingTeams = false;
        });
      }
    } catch (e) {
      setState(() => _loadingTeams = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando equipos: $e')),
        );
      }
    }
  }

  void _showAddTeamModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccionar equipo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              if (_loadingTeams)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
              else if (_teams.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('No hay equipos disponibles.'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/createTeam');
                        },
                        child: const Text('Crear Equipo'),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _teams.length,
                    itemBuilder: (context, index) {
                      final team = _teams[index];
                      final isSelected = _selectedTeamIds.contains(team.id);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? Colors.green : Colors.blue,
                          child: Text(
                            team.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(team.name),
                        subtitle: Text(team.category),
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.add_circle_outline,
                          color: isSelected ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTeamIds.remove(team.id);
                            } else {
                              _selectedTeamIds.add(team.id);
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
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
                  initialValue: _sport,
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
                  initialValue: _category,
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
                const SizedBox(height: 24),
                // Sección de equipos
                const Text(
                  'Equipos participantes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddTeamModal,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir equipo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedTeamIds.isNotEmpty)
                  Column(
                    children: _selectedTeamIds.map((teamId) {
                      final team = _teams.firstWhere(
                        (t) => t.id == teamId,
                        orElse: () => Team(
                          id: teamId,
                          name: 'Equipo',
                          description: '',
                          sport: '',
                          creator_id: '',
                          category: '',
                        ),
                      );
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(team.name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(team.name),
                          subtitle: Text(team.category),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedTeamIds.remove(teamId);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
