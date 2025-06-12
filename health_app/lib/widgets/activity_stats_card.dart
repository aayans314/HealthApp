import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class ActivityStatsCard extends StatelessWidget {
  const ActivityStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, Icons.directions_walk, '8,543', AppConstants.steps),
                _buildStatItem(context, Icons.straighten, '5.2', 'km'),
                _buildStatItem(context, Icons.local_fire_department, '423', 'kcal'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.7, // 70% of daily goal
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(10),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '70% of daily goal',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}