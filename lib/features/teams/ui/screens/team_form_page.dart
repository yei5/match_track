import 'package:match_track/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_track/core/domain/model/player.dart';
import 'package:match_track/core/domain/model/team.dart';
import 'package:match_track/features/teams/ui/bloc/team_bloc.dart';
import 'package:match_track/features/teams/ui/bloc/team_event.dart';
import 'package:match_track/features/teams/ui/bloc/team_state.dart';
import 'package:match_track/features/teams/ui/widgets/add_image_box.dart';
import 'player_form_page.dart';
import 'package:dotted_border/dotted_border.dart';

class TeamFormPage extends StatefulWidget {
  const TeamFormPage({super.key});

  @override
  State<TeamFormPage> createState() => _TeamFormPageState();
}

class _TeamFormPageState extends State<TeamFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String? sport;
  String? category;
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Información básica")),
      body: BlocListener<TeamBloc, TeamState>(
        listener: (context, state) {
          if (state is TeamCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Equipo creado exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<TeamBloc>().add(LoadTeamsEvent());
            Navigator.pop(context);
          } else if (state is TeamErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al crear equipo: ${state.message}'),
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
                AddImageBox(onTap: () {}),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Ingrese un nombre" : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: sport,
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
                  initialValue: category,
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
                    return Card(
                        child: Center(child: Text(players[i].name)));
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<TeamBloc, TeamState>(
                  builder: (context, state) {
                    final loading = state is TeamLoadingState;
                    return CustomButton(
                      text: loading ? 'Creando...' : 'Crear equipo',
                      onPressed: loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final team = Team(
                                  id: '',
                                  name: nameCtrl.text,
                                  sport: sport ?? "Fútbol",
                                  imageUrl: null,
                                  category: category ?? "Masculino",
                                  description: descCtrl.text,
                                  creator_id: '',
                                );
                                context.read<TeamBloc>().add(
                                      CreateTeamEvent(
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
