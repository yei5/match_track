// lib/widgets/custom_header.dart
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomHeader({
    Key? key,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          // Logo placeholder - puedes reemplazar con tu imagen
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'LOGO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: _buildActionIcons(),
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  List<Widget> _buildActionIcons() {
    return [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: () {
          // Acción de búsqueda
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.black),
        onPressed: () {
          // Acción de notificaciones
        },
      ),
      IconButton(
        icon: const Icon(Icons.person, color: Colors.black),
        onPressed: () {
          // Acción de perfil
        },
      ),
      const SizedBox(width: 8),
    ];
  }
}
