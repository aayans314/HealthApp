import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/meditation_model.dart';

class MeditationProgressCard extends StatelessWidget {
  final MeditationSummary? summary;

  const MeditationProgressCard({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    // Use real data if available, otherwise use mock data
    final totalMinutes = summary?.totalMinutes ?? 120;
    final sessionsCompleted = summary?.sessionsCompleted ?? 8;
    final currentStreak = summary?.currentStreak ?? 5;
    final longestStreak = 14; // This could be stored in the user profile in a real app

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
    // Generate weekly data based on summary or use mock data
    final weeklyData = _generateWeeklyData();

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

  List<Map<String, dynamic>> _generateWeeklyData() {
    // In a real app, this would come from a database or API
    // For now, we'll use mock data or generate based on the summary
    
    // Get the current day of the week (0 = Monday, 6 = Sunday)
    final now = DateTime.now();
    final currentDayOfWeek = (now.weekday - 1) % 7;
    
    // Day names
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    // Generate data for each day
    final weeklyData = <Map<String, dynamic>>[];
    
    for (var i = 0; i < 7; i++) {
      // Determine if this day is today, in the past, or in the future
      final isToday = i == currentDayOfWeek;
      final isPast = i < currentDayOfWeek;
      final isFuture = i > currentDayOfWeek;
      
      // For past days, generate some random minutes
      // For today, use the summary data if available
      // For future days, set to 0
      int minutes = 0;
      
      if (isPast) {
        // Generate some random minutes for past days
        minutes = [0, 5, 10, 15, 20, 25].elementAt(i % 6);
      } else if (isToday && summary != null) {
        minutes = summary!.totalMinutes;
      }
      
      weeklyData.add({
        'day': dayNames[i],
        'minutes': minutes,
        'isToday': isToday,
        'isFuture': isFuture,
      });
    }
    
    return weeklyData;
  }

  Widget _buildDayColumn(Map<String, dynamic> day) {
    final minutes = day['minutes'] as int;
    final isToday = day['isToday'] as bool;
    final isFuture = day['isFuture'] as bool;
    
    // Calculate height based on minutes (max height for 30 minutes)
    final barHeight = minutes > 0 ? (minutes / 30) * 100 : 0.0;
    final maxHeight = 100.0;
    
    return Column(
      children: [
        Text(
          '$minutes',
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