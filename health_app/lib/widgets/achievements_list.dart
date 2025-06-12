import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AchievementsList extends StatelessWidget {
  const AchievementsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for achievements
    final achievements = [
      {
        'title': 'Early Bird',
        'description': 'Complete 5 morning workouts',
        'date': 'May 10, 2023',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
        'progress': 1.0, // Completed
      },
      {
        'title': 'Step Master',
        'description': 'Reach 10,000 steps in a day',
        'date': 'May 8, 2023',
        'icon': Icons.directions_walk,
        'color': Colors.green,
        'progress': 1.0, // Completed
      },
      {
        'title': 'Hydration Hero',
        'description': 'Drink 8 glasses of water for 7 consecutive days',
        'date': 'May 5, 2023',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'progress': 1.0, // Completed
      },
      {
        'title': 'Meditation Guru',
        'description': 'Complete 10 meditation sessions',
        'date': 'In Progress',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
        'progress': 0.7, // 70% complete
      },
      {
        'title': 'Nutrition Expert',
        'description': 'Log all meals for 14 consecutive days',
        'date': 'In Progress',
        'icon': Icons.restaurant,
        'color': Colors.red,
        'progress': 0.5, // 50% complete
      },
      {
        'title': 'Sleep Champion',
        'description': 'Get 8 hours of sleep for 5 consecutive days',
        'date': 'In Progress',
        'icon': Icons.nightlight,
        'color': Colors.indigo,
        'progress': 0.4, // 40% complete
      },
    ];

    return ListView.builder(
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isCompleted = achievement['progress'] as double >= 1.0;
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: (achievement['color'] as Color).withOpacity(0.2),
              child: Icon(
                achievement['icon'] as IconData,
                color: achievement['color'] as Color,
              ),
            ),
            title: Text(
              achievement['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(achievement['description'] as String),
                const SizedBox(height: 8),
                if (!isCompleted)
                  LinearProgressIndicator(
                    value: achievement['progress'] as double,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      achievement['date'] as String,
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    if (!isCompleted)
                      Text(
                        '${((achievement['progress'] as double) * 100).toInt()}%',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            trailing: isCompleted
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                : null,
            onTap: () {
              // TODO: Show achievement details
            },
          ),
        );
      },
    );
  }
}