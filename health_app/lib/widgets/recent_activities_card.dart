import 'package:flutter/material.dart';
import '../utils/theme.dart';

class RecentActivitiesCard extends StatelessWidget {
  const RecentActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for recent activities
    final recentActivities = [
      {
        'type': 'Running',
        'time': '10:30 AM',
        'duration': '30 min',
        'distance': '3.5 km',
        'calories': '250 kcal',
      },
      {
        'type': 'Cycling',
        'time': 'Yesterday',
        'duration': '45 min',
        'distance': '12 km',
        'calories': '320 kcal',
      },
      {
        'type': 'Walking',
        'time': 'Yesterday',
        'duration': '60 min',
        'distance': '4.2 km',
        'calories': '180 kcal',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to activity history screen
                  },
                  child: const Text('See All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return _buildActivityItem(
                  context,
                  activity['type'] as String,
                  activity['time'] as String,
                  activity['duration'] as String,
                  activity['distance'] as String,
                  activity['calories'] as String,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, String type, String time, String duration, String distance, String calories) {
    IconData activityIcon;
    Color activityColor;

    // Set icon and color based on activity type
    switch (type.toLowerCase()) {
      case 'running':
        activityIcon = Icons.directions_run;
        activityColor = AppTheme.primaryColor;
        break;
      case 'cycling':
        activityIcon = Icons.directions_bike;
        activityColor = AppTheme.secondaryColor;
        break;
      case 'walking':
        activityIcon = Icons.directions_walk;
        activityColor = AppTheme.accentColor;
        break;
      default:
        activityIcon = Icons.fitness_center;
        activityColor = AppTheme.primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activityColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildActivityStat(Icons.timer, duration),
                    const SizedBox(width: 16),
                    _buildActivityStat(Icons.straighten, distance),
                    const SizedBox(width: 16),
                    _buildActivityStat(Icons.local_fire_department, calories),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}