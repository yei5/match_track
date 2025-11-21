import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:match_track/core/theme/app_colors.dart';
import 'package:match_track/core/widgets/custom_button.dart';
import 'package:match_track/core/widgets/app_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final Uuid _uuid = const Uuid();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _selectedImageBytes;
  String? _uploadedImageUrl;

  String _selectedSport = 'Fútbol';
  String? _selectedCategory;
  String? _selectedStatus;
  bool _loading = false;

  final List<String> _categories = ['Masculino', 'Femenino', 'Mixto'];
  final List<String> _statuses = ['Programado', 'En curso', 'Finalizado'];
  final List<String> _teams = ['Equipo A', 'Equipo B', 'Equipo C', 'Equipo D'];
  final List<String> _selectedTeams = [];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo seleccionar la imagen: $e')),
      );
    }
  }

  Future<String?> _uploadImageToSupabase(Uint8List bytes) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;

      final String fileName = 'tournament_${_uuid.v4()}.jpg';
      final String filePath = 'tournaments/$fileName';

      // Subir la imagen al bucket 'tournament-images'
      await Supabase.instance.client.storage
          .from('tournament-photos')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      // Obtener URL pública
      final String publicUrl = Supabase.instance.client.storage
          .from('tournament-photos')
          .getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Error al subir imagen: $e');
      return null;
    }
  }

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
          const SnackBar(content: Text('Error: No se encontró tu perfil.')),
        );
        setState(() => _loading = false);
        return;
      }

      String? imageUrl;
      if (_selectedImageBytes != null) {
        imageUrl = await _uploadImageToSupabase(_selectedImageBytes!);
      }

      final tournamentData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'sport': _selectedSport,
        'category': _selectedCategory!,
        'user_id': user.id,
        'status': _selectedStatus ?? 'Programado',
        'start_date': _startDateController.text.isNotEmpty
            ? _startDateController.text
            : DateTime.now().toIso8601String().split('T')[0],
        'end_date': _endDateController.text.isNotEmpty
            ? _endDateController.text
            : DateTime.now()
                  .add(const Duration(days: 30))
                  .toIso8601String()
                  .split('T')[0],
        'image_url': imageUrl,
      };

      await Supabase.instance.client.from('tournaments').insert(tournamentData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Torneo creado con éxito.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear el torneo: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0];
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
              ..._teams.map((team) {
                return ListTile(
                  title: Text(team),
                  trailing: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    if (!_selectedTeams.contains(team)) {
                      setState(() => _selectedTeams.add(team));
                    }
                    Navigator.pop(context);
                  },
                );
              }),
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
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(title: 'Crear Torneo', showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Información básica',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            border: Border.all(color: const Color(0xFFD0D0D0)),
                            borderRadius: BorderRadius.circular(14),
                            image: _selectedImageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(_selectedImageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedImageBytes == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.grey[600],
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Agregar imagen',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('Nombre del torneo'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Ingrese un nombre'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSport,
                        decoration: _inputDecoration('Deporte'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Fútbol',
                            child: Text('Fútbol'),
                          ),
                          DropdownMenuItem(
                            value: 'Baloncesto',
                            child: Text('Baloncesto'),
                          ),
                          DropdownMenuItem(
                            value: 'Vóleibol',
                            child: Text('Vóleibol'),
                          ),
                          DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedSport = value!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: _inputDecoration('Fecha de inicio')
                            .copyWith(
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                            ),
                        onTap: () => _selectDate(context, _startDateController),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: _inputDecoration('Fecha de fin').copyWith(
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: () => _selectDate(context, _endDateController),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: _inputDecoration('Estado'),
                        items: _statuses
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedStatus = value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: _inputDecoration('Categoría'),
                        validator: (value) =>
                            value == null ? 'Selecciona una categoría' : null,
                        items: _categories
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          border: Border.all(color: const Color(0xFFD0D0D0)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Equipos participantes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              text: 'Añadir equipo',
                              onPressed: _showAddTeamModal,
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: _selectedTeams
                                  .map(
                                    (team) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.sports_soccer,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            team,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _inputDecoration('Descripción del torneo'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: CustomButton(
                          text: _loading ? 'Creando...' : 'Crear torneo',
                          onPressed: _loading ? null : _createTournament,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
