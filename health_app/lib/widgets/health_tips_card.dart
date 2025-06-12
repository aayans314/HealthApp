import 'package:flutter/material.dart';
import '../utils/theme.dart';

class HealthTipsCard extends StatelessWidget {
  const HealthTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for health tips
    final healthTips = [
      {
        'title': 'Stay Hydrated',
        'description': 'Drink at least 8 glasses of water daily to maintain proper hydration.',
        'category': 'nutrition',
      },
      {
        'title': 'Take Regular Breaks',
        'description': 'Stand up and stretch every 30 minutes if you work at a desk.',
        'category': 'fitness',
      },
      {
        'title': 'Practice Mindfulness',
        'description': 'Take 5 minutes each day to practice deep breathing and clear your mind.',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health Tips',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                  onPressed: () {
                    // TODO: Refresh health tips
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: healthTips.length,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, index) {
                  final tip = healthTips[index];
                  return _buildTipCard(
                    context,
                    tip['title'] as String,
                    tip['description'] as String,
                    tip['category'] as String,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  healthTips.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String description, String category) {
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
        categoryIcon = Icons.lightbulb;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(right: 8),
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
                    color: categoryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Show more tips in this category
                },
                child: const Text('More Tips'),
                style: TextButton.styleFrom(
                  foregroundColor: categoryColor,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}