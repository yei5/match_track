import 'package:flutter/material.dart';
import 'package:match_track/core/theme/app_colors.dart';

class TeamFilterBar extends StatelessWidget {
  final String selectedSport;
  final String selectedCategory;
  final Function(String) onSportChanged;
  final Function(String) onCategoryChanged;

  const TeamFilterBar({
    super.key,
    required this.selectedSport,
    required this.selectedCategory,
    required this.onSportChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSport,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onSportChanged(newValue);
                  }
                },
                items: <String>['Todos', 'Fútbol', 'Baloncesto', 'Vóleibol', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCategory,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onCategoryChanged(newValue);
                  }
                },
                items: <String>['Todos', 'Masculino', 'Femenino', 'Mixto']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
