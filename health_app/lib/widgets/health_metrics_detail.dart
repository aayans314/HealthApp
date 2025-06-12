import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/theme.dart';

class HealthMetricsDetail extends StatelessWidget {
  final HealthMetrics healthMetrics;

  const HealthMetricsDetail({super.key, required this.healthMetrics});

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
            _buildMetricRow(
              context,
              'Heart Rate',
              '${healthMetrics.heartRate} bpm',
              Icons.favorite,
              _getHeartRateStatus(healthMetrics.heartRate),
              Colors.red,
            ),
            const Divider(),
            _buildMetricRow(
              context,
              'Blood Pressure',
              '${healthMetrics.bloodPressureSystolic}/${healthMetrics.bloodPressureDiastolic} mmHg',
              Icons.speed,
              _getBloodPressureStatus(
                healthMetrics.bloodPressureSystolic,
                healthMetrics.bloodPressureDiastolic,
              ),
              Colors.orange,
            ),
            const Divider(),
            _buildMetricRow(
              context,
              'Sleep',
              '${healthMetrics.sleepHours} hours',
              Icons.nightlight,
              _getSleepStatus(healthMetrics.sleepHours),
              Colors.indigo,
            ),
            const Divider(),
            _buildMetricRow(
              context,
              'BMI',
              healthMetrics.bmi.toStringAsFixed(1),
              Icons.monitor_weight,
              _getBMIStatus(healthMetrics.bmi),
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHeartRateStatus(int heartRate) {
    if (heartRate < 60) return 'Low';
    if (heartRate > 100) return 'High';
    return 'Normal';
  }

  String _getBloodPressureStatus(int systolic, int diastolic) {
    if (systolic < 90 || diastolic < 60) return 'Low';
    if (systolic >= 140 || diastolic >= 90) return 'High';
    if (systolic >= 120 || diastolic >= 80) return 'Elevated';
    return 'Normal';
  }

  String _getSleepStatus(double hours) {
    if (hours < 6) return 'Poor';
    if (hours >= 9) return 'Excellent';
    if (hours >= 7) return 'Good';
    return 'Fair';
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi >= 30) return 'Obese';
    if (bmi >= 25) return 'Overweight';
    return 'Normal';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'good':
        return Colors.green;
      case 'elevated':
      case 'fair':
      case 'overweight':
      case 'underweight':
        return Colors.orange;
      case 'high':
      case 'low':
      case 'poor':
      case 'obese':
        return Colors.red;
      case 'excellent':
        return Colors.blue;
      default:
        return AppTheme.primaryColor;
    }
  }
}