import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ActivityTypeSelector extends StatelessWidget {
  final Function(String) onActivitySelected;
  final String selectedType;

  const ActivityTypeSelector({
    super.key,
    required this.onActivitySelected,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    // List of activity types with their icons
    final activityTypes = [
      {'name': 'Running', 'icon': Icons.directions_run},
      {'name': 'Walking', 'icon': Icons.directions_walk},
      {'name': 'Cycling', 'icon': Icons.directions_bike},
      {'name': 'Swimming', 'icon': Icons.pool},
      {'name': 'Gym', 'icon': Icons.fitness_center},
      {'name': 'Yoga', 'icon': Icons.self_improvement},
      {'name': 'Hiking', 'icon': Icons.terrain},
      {'name': 'Other', 'icon': Icons.more_horiz},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activityTypes.length,
        itemBuilder: (context, index) {
          final activity = activityTypes[index];
          final isSelected = activity['name'] == selectedType;
          
          return GestureDetector(
            onTap: () => onActivitySelected(activity['name'] as String),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}