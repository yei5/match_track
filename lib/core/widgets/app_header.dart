import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:match_track/core/theme/app_colors.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomHeader({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          false, // 👈 evita que Flutter agregue el espacio del botón atrás automáticamente
      backgroundColor: AppColors.textPrimary,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.surface),
              // 👆 color corregido (antes estaba invisible)
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null, // 👈 si es false, no deja hueco
      title: Row(
        children: [
          SvgPicture.asset('assets/header_logo.svg', height: 40, width: 40),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: _buildActionIcons(),
      iconTheme: const IconThemeData(color: AppColors.surface),
    );
  }

  List<Widget> _buildActionIcons() {
    return [
      IconButton(
        icon: const Icon(Icons.search, color: AppColors.surface),
        onPressed: () {
          // Acción de búsqueda
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications, color: AppColors.surface),
        onPressed: () {
          // Acción de notificaciones
        },
      ),
      IconButton(
        icon: const Icon(Icons.person, color: AppColors.surface),
        onPressed: () {
          // Acción de perfil
        },
      ),
      const SizedBox(width: 8),
    ];
  }
}
