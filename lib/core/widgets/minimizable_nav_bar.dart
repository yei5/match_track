import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MinimizableNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MinimizableNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<MinimizableNavBar> createState() => _MinimizableNavBarState();
}

class _MinimizableNavBarState extends State<MinimizableNavBar> with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _iconSizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 90.0,
      end: 60.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _iconSizeAnimation = Tween<double>(
      begin: 28.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  void _navigate(BuildContext context, int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/games');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tournaments');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/teams');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Barra de navegación principal
              Container(
                height: _heightAnimation.value,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_isExpanded ? 0 : 30),
                    topRight: Radius.circular(_isExpanded ? 0 : 30),
                  ),
                ),
                child: _isExpanded
                    ? _buildFullNavBar()
                    : _buildMinimizedNavBar(),
              ),
              
              // Botón de toggle
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: _toggleExpanded,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFullNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(0, Icons.sports_soccer_outlined, Icons.sports_soccer, 'Partidos'),
        _buildNavItem(1, Icons.emoji_events_outlined, Icons.emoji_events, 'Torneos'),
        _buildNavItem(2, Icons.home_outlined, Icons.home, 'Inicio'),
        _buildNavItem(3, Icons.groups_outlined, Icons.groups, 'Equipos'),
        _buildNavItem(4, Icons.person_outline, Icons.person, 'Perfil'),
      ],
    );
  }

  Widget _buildMinimizedNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMiniNavItem(0, Icons.sports_soccer_outlined, Icons.sports_soccer),
        _buildMiniNavItem(1, Icons.emoji_events_outlined, Icons.emoji_events),
        _buildMiniNavItem(2, Icons.home_outlined, Icons.home),
        _buildMiniNavItem(3, Icons.groups_outlined, Icons.groups),
        _buildMiniNavItem(4, Icons.person_outline, Icons.person),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = widget.currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          _navigate(context, index);
          widget.onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: isSelected ? 28 : 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniNavItem(int index, IconData icon, IconData activeIcon) {
    final isSelected = widget.currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          _navigate(context, index);
          widget.onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: _iconSizeAnimation.value,
            ),
          ),
        ),
      ),
    );
  }
}
