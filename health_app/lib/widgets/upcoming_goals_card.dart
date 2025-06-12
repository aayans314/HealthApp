import 'package:flutter/material.dart';
import '../utils/theme.dart';

class UpcomingGoalsCard extends StatelessWidget {
  const UpcomingGoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for upcoming goals
    final upcomingGoals = [
      {
        'title': 'Complete 10,000 steps',
        'dueDate': 'Today',
        'progress': 0.75,
        'category': 'fitness',
      },
      {
        'title': 'Drink 2L of water',
        'dueDate': 'Today',
        'progress': 0.5,
        'category': 'nutrition',
      },
      {
        'title': 'Meditate for 10 minutes',
        'dueDate': 'Today',
        'progress': 0.0,
        'category': 'meditation',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingGoals.length,
              itemBuilder: (context, index) {
                final goal = upcomingGoals[index];
                return _buildGoalItem(
                  context,
                  goal['title'] as String,
                  goal['dueDate'] as String,
                  goal['progress'] as double,
                  goal['category'] as String,
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to add goal screen
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Goal'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(
      BuildContext context, String title, String dueDate, double progress, String category) {
    Color categoryColor;
    IconData categoryIcon;

    // Set color and icon based on category
    switch (category) {
      case 'fitness':
        categoryColor = AppTheme.primaryColor;
        categoryIcon = Icons.directions_run;
        break;
      case 'nutrition':
        categoryColor = AppTheme.secondaryColor;
        categoryIcon = Icons.restaurant;
        break;
      case 'meditation':
        categoryColor = AppTheme.accentColor;
        categoryIcon = Icons.spa;
        break;
      default:
        categoryColor = AppTheme.primaryColor;
        categoryIcon = Icons.flag;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              categoryIcon,
              color: categoryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dueDate,
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}