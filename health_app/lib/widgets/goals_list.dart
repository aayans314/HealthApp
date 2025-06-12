import 'package:flutter/material.dart';
import '../utils/theme.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for goals
    final goals = [
      {
        'title': 'Lose 5kg',
        'description': 'Reach target weight of 65kg',
        'targetDate': 'June 30, 2023',
        'category': 'fitness',
        'progress': 0.4, // 40% complete
        'isCompleted': false,
      },
      {
        'title': 'Run 5km',
        'description': 'Complete a 5km run without stopping',
        'targetDate': 'May 25, 2023',
        'category': 'fitness',
        'progress': 0.7, // 70% complete
        'isCompleted': false,
      },
      {
        'title': 'Meditate Daily',
        'description': 'Meditate for at least 10 minutes every day',
        'targetDate': 'Ongoing',
        'category': 'meditation',
        'progress': 0.6, // 60% complete
        'isCompleted': false,
      },
      {
        'title': 'Drink More Water',
        'description': 'Drink 8 glasses of water daily',
        'targetDate': 'Ongoing',
        'category': 'nutrition',
        'progress': 0.8, // 80% complete
        'isCompleted': false,
      },
      {
        'title': 'Improve Sleep',
        'description': 'Sleep 8 hours every night',
        'targetDate': 'Ongoing',
        'category': 'health',
        'progress': 0.5, // 50% complete
        'isCompleted': false,
      },
      {
        'title': 'Reduce Screen Time',
        'description': 'Limit screen time to 2 hours per day',
        'targetDate': 'May 31, 2023',
        'category': 'health',
        'progress': 0.3, // 30% complete
        'isCompleted': false,
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Add new goal
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Goal'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final categoryIcon = _getCategoryIcon(goal['category'] as String);
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: categoryIcon['color']!.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              categoryIcon['icon']!,
                              color: categoryIcon['color']!,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              goal['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              // TODO: Handle menu item selection
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'complete',
                                child: Text('Mark as Complete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        goal['description'] as String,
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: goal['progress'] as double,
                                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                  borderRadius: BorderRadius.circular(4),
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Target: ${goal['targetDate']}',
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${((goal['progress'] as double) * 100).toInt()}%',
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fitness':
        return {
          'icon': Icons.fitness_center,
          'color': Colors.orange,
        };
      case 'nutrition':
        return {
          'icon': Icons.restaurant,
          'color': Colors.green,
        };
      case 'meditation':
        return {
          'icon': Icons.self_improvement,
          'color': Colors.purple,
        };
      case 'health':
        return {
          'icon': Icons.favorite,
          'color': Colors.red,
        };
      default:
        return {
          'icon': Icons.flag,
          'color': AppTheme.primaryColor,
        };
    }
  }
}