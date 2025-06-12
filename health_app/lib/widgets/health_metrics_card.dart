import 'package:flutter/material.dart';
import '../utils/theme.dart';

class HealthMetricsCard extends StatelessWidget {
  const HealthMetricsCard({super.key});

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
            Text(
              'Health Metrics',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(
                  context,
                  Icons.favorite,
                  '72',
                  'Heart Rate',
                  'bpm',
                  AppTheme.errorColor,
                ),
                _buildMetricItem(
                  context,
                  Icons.speed,
                  '120/80',
                  'Blood Pressure',
                  'mmHg',
                  AppTheme.primaryColor,
                ),
                _buildMetricItem(
                  context,
                  Icons.nightlight,
                  '7.5',
                  'Sleep',
                  'hours',
                  AppTheme.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
      BuildContext context, IconData icon, String value, String label, String unit, Color color) {
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
        Text(
          unit,
          style: const TextStyle(
            color: AppTheme.textLightColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}