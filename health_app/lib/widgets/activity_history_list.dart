import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ActivityHistoryList extends StatelessWidget {
  const ActivityHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for activity history
    final activityHistory = [
      {
        'date': 'Today',
        'type': 'Running',
        'duration': '30 min',
        'distance': '5.2 km',
        'calories': '320 kcal',
      },
      {
        'date': 'Yesterday',
        'type': 'Cycling',
        'duration': '45 min',
        'distance': '12 km',
        'calories': '410 kcal',
      },
      {
        'date': '2 days ago',
        'type': 'Walking',
        'duration': '60 min',
        'distance': '4.8 km',
        'calories': '280 kcal',
      },
      {
        'date': '3 days ago',
        'type': 'Swimming',
        'duration': '40 min',
        'distance': '1.5 km',
        'calories': '350 kcal',
      },
      {
        'date': '4 days ago',
        'type': 'Running',
        'duration': '25 min',
        'distance': '4 km',
        'calories': '250 kcal',
      },
    ];

    return ListView.builder(
      itemCount: activityHistory.length,
      itemBuilder: (context, index) {
        final activity = activityHistory[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: _getActivityIcon(activity['type'] as String),
            title: Text(
              activity['type'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(activity['date'] as String),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildDetailChip(Icons.timer, activity['duration'] as String),
                    const SizedBox(width: 8),
                    _buildDetailChip(Icons.straighten, activity['distance'] as String),
                    const SizedBox(width: 8),
                    _buildDetailChip(Icons.local_fire_department, activity['calories'] as String),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Show activity details or options
              },
            ),
            onTap: () {
              // TODO: Navigate to activity details
            },
          ),
        );
      },
    );
  }

  Widget _getActivityIcon(String activityType) {
    IconData iconData;
    Color backgroundColor;

    switch (activityType.toLowerCase()) {
      case 'running':
        iconData = Icons.directions_run;
        backgroundColor = Colors.orange;
        break;
      case 'walking':
        iconData = Icons.directions_walk;
        backgroundColor = Colors.green;
        break;
      case 'cycling':
        iconData = Icons.directions_bike;
        backgroundColor = Colors.blue;
        break;
      case 'swimming':
        iconData = Icons.pool;
        backgroundColor = Colors.cyan;
        break;
      default:
        iconData = Icons.fitness_center;
        backgroundColor = Colors.purple;
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: backgroundColor.withOpacity(0.2),
      child: Icon(
        iconData,
        color: backgroundColor,
        size: 24,
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}