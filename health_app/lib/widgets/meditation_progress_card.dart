import 'package:flutter/material.dart';
import '../utils/theme.dart';

class MeditationProgressCard extends StatelessWidget {
  const MeditationProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for meditation progress
    const totalMinutes = 120;
    const sessionsCompleted = 8;
    const currentStreak = 5;
    const longestStreak = 14;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Meditation Journey',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('$totalMinutes', 'Minutes', Icons.timer),
                _buildStatColumn('$sessionsCompleted', 'Sessions', Icons.spa),
                _buildStatColumn('$currentStreak', 'Day Streak', Icons.local_fire_department),
                _buildStatColumn('$longestStreak', 'Best Streak', Icons.emoji_events),
              ],
            ),
            const SizedBox(height: 16),
            _buildWeeklyProgress(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(BuildContext context) {
    // Mock data for weekly meditation minutes
    final weeklyData = [
      {'day': 'Mon', 'minutes': 15},
      {'day': 'Tue', 'minutes': 20},
      {'day': 'Wed', 'minutes': 10},
      {'day': 'Thu', 'minutes': 15},
      {'day': 'Fri', 'minutes': 25},
      {'day': 'Sat', 'minutes': 0}, // Today (not yet completed)
      {'day': 'Sun', 'minutes': 0}, // Future
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weeklyData.map((day) => _buildDayColumn(day)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayColumn(Map<String, dynamic> day) {
    final minutes = day['minutes'] as int;
    final isToday = day['day'] == 'Sat'; // Mock today as Saturday
    final isFuture = day['day'] == 'Sun'; // Mock future as Sunday
    
    // Calculate height based on minutes (max height for 30 minutes)
    final barHeight = minutes > 0 ? (minutes / 30) * 100 : 0.0;
    final maxHeight = 100.0;
    
    return Column(
      children: [
        Text(
          '${day['minutes']}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: minutes > 0 ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: maxHeight,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 8,
            height: barHeight,
            decoration: BoxDecoration(
              color: isToday
                  ? AppTheme.primaryColor.withOpacity(0.5)
                  : isFuture
                      ? Colors.grey.withOpacity(0.3)
                      : AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day['day'] as String,
          style: TextStyle(
            color: isToday
                ? AppTheme.primaryColor
                : AppTheme.textSecondaryColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}