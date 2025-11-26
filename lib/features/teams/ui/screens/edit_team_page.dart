import 'dart:typed_data';
import 'package:match_track/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/bloc/team_event.dart';
import 'package:match_track/features/teams/ui/bloc/team_state.dart';
import 'package:match_track/features/teams/ui/widgets/add_image_box.dart';
import 'package:match_track/core/utils/image_upload_util.dart';
import 'player_form_page.dart';
import 'package:dotted_border/dotted_border.dart';

class EditTeamPage extends StatefulWidget {
  final Team team;
  final List<Player> players;
  const EditTeamPage({super.key, required this.team, required this.players});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  String? sport;
  String? category;
  List<Player> players = [];
  Uint8List? _selectedImageBytes;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.team.name);
    descCtrl = TextEditingController(text: widget.team.description);
    sport = widget.team.sport;
    category = widget.team.category;
    players = widget.players;
    _currentImageUrl = widget.team.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Información")),
      body: BlocListener<TeamBloc, TeamState>(
        listener: (context, state) {
          if (state is TeamUpdatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Equipo actualizado exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is TeamErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar equipo: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddImageBox(
                  imageUrl: _currentImageUrl,
                  selectedImageBytes: _selectedImageBytes,
                  onImageSelected: (bytes) {
                    setState(() {
                      _selectedImageBytes = bytes;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese un nombre" : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: sport,
                  items: const [
                    DropdownMenuItem(value: "Fútbol", child: Text("Fútbol")),
                    DropdownMenuItem(
                      value: "Baloncesto",
                      child: Text("Baloncesto"),
                    ),
                  ],
                  onChanged: (v) => setState(() => sport = v),
                  decoration: const InputDecoration(labelText: "Deporte"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(
                      value: "Masculino",
                      child: Text("Masculino"),
                    ),
                    DropdownMenuItem(
                      value: "Femenino",
                      child: Text("Femenino"),
                    ),
                  ],
                  onChanged: (v) => setState(() => category = v),
                  decoration: const InputDecoration(labelText: "Categoría"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Descripción"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                const Text("Miembros"),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: players.length + 1,
                  itemBuilder: (_, i) {
                    if (i == players.length) {
                      return GestureDetector(
                        onTap: () async {
                          final player = await Navigator.push<Player>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerFormPage(
                                teamSport: sport ?? "Fútbol",
                                teamCategory: category ?? "Masculino",
                                existingJerseyNumbers: players
                                    .map((p) => p.jersey_number)
                                    .toList(),
                              ),
                            ),
                          );
                          if (!mounted) return;
                          if (player != null) {
                            setState(() {
                              players.add(player);
                            });
                          }
                        },
                        child: DottedBorder(
                          options: const RectDottedBorderOptions(
                            color: Colors.grey,
                            strokeWidth: 1.5,
                            dashPattern: [6, 3],
                            borderPadding: EdgeInsets.all(6),
                            strokeCap: StrokeCap.round,
                            stackFit: StackFit.passthrough,
                          ),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_add_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Card(
                            child: Center(child: Text(players[i].name))),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                players.removeAt(i);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<TeamBloc, TeamState>(
                  builder: (context, state) {
                    final loading = state is TeamLoadingState;
                    return CustomButton(
                      text: loading ? 'Actualizando...' : 'Actualizar equipo',
                      onPressed: loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                String? imageUrl;
                                if (_selectedImageBytes != null) {
                                  imageUrl = await ImageUploadUtil
                                      .uploadImageToSupabase(
                                    bytes: _selectedImageBytes!,
                                    bucketName: 'team-photos',
                                    folderPath: 'teams',
                                  );
                                } else {
                                  imageUrl = _currentImageUrl;
                                }
                                final team = Team(
                                  id: widget.team.id,
                                  name: nameCtrl.text,
                                  sport: sport ?? "Fútbol",
                                  imageUrl: imageUrl,
                                  category: category ?? "Masculino",
                                  description: descCtrl.text,
                                  creator_id: widget.team.creator_id,
                                );
                                context.read<TeamBloc>().add(
                                      UpdateTeamEvent(
                                          team: team, players: players),
                                    );
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
