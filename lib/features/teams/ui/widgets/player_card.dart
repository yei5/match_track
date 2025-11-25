import 'package:flutter/material.dart';
import 'package:match_track/core/domain/model/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: player.imageUrl != null
                ? NetworkImage(player.imageUrl!)
                : const AssetImage('assets/images/default_user.png') as ImageProvider,
            radius: 30,
          ),
          const SizedBox(height: 6),
          Text(player.name),
        ],
      ),
    );
  }
}
