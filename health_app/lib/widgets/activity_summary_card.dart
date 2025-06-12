import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class ActivitySummaryCard extends StatelessWidget {
  const ActivitySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Activity Summary',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Text(
                  'Today',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActivityStat(
                  context,
                  Icons.directions_walk,
                  '7,543',
                  AppConstants.steps,
                  AppTheme.primaryColor,
                ),
                _buildActivityStat(
                  context,
                  Icons.straighten,
                  '5.2',
                  '${AppConstants.distance} km',
                  AppTheme.secondaryColor,
                ),
                _buildActivityStat(
                  context,
                  Icons.local_fire_department,
                  '320',
                  '${AppConstants.calories} kcal',
                  AppTheme.accentColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(
              value: 0.75, // 75% of daily goal
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            const Text(
              '75% of daily goal',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat(
      BuildContext context, IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}