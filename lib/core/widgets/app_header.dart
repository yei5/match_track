import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';

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
      backgroundColor: AppColors.textPrimary,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'LOGO',
                style: TextStyle(
                  color: AppColors.background,
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
