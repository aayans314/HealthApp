import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class MealList extends StatelessWidget {
  const MealList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for meals
    final meals = {
      AppConstants.breakfast: [
        {
          'name': 'Oatmeal with Berries',
          'calories': 320,
          'time': '08:30 AM',
          'image': 'https://via.placeholder.com/60',
        },
      ],
      AppConstants.lunch: [
        {
          'name': 'Grilled Chicken Salad',
          'calories': 450,
          'time': '12:45 PM',
          'image': 'https://via.placeholder.com/60',
        },
        {
          'name': 'Whole Grain Bread',
          'calories': 130,
          'time': '12:45 PM',
          'image': 'https://via.placeholder.com/60',
        },
      ],
      AppConstants.dinner: [
        {
          'name': 'Salmon with Vegetables',
          'calories': 380,
          'time': '07:30 PM',
          'image': 'https://via.placeholder.com/60',
        },
      ],
      AppConstants.snacks: [
        {
          'name': 'Greek Yogurt',
          'calories': 120,
          'time': '03:15 PM',
          'image': 'https://via.placeholder.com/60',
        },
      ],
    };

    return ListView(
      children: [
        _buildMealSection(context, AppConstants.breakfast, meals[AppConstants.breakfast]!),
        _buildMealSection(context, AppConstants.lunch, meals[AppConstants.lunch]!),
        _buildMealSection(context, AppConstants.dinner, meals[AppConstants.dinner]!),
        _buildMealSection(context, AppConstants.snacks, meals[AppConstants.snacks]!),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, String mealType, List<Map<String, dynamic>> mealItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _getMealIcon(mealType),
                  const SizedBox(width: 8),
                  Text(
                    mealType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Add meal for this type
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        if (mealItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No $mealType items added yet',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mealItems.length,
            itemBuilder: (context, index) {
              final meal = mealItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      meal['image'] as String,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    meal['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('${meal['calories']} kcal'),
                      const SizedBox(height: 4),
                      Text(
                        meal['time'] as String,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO: Show meal options
                    },
                  ),
                  onTap: () {
                    // TODO: Show meal details
                  },
                ),
              );
            },
          ),
        const Divider(),
      ],
    );
  }

  Widget _getMealIcon(String mealType) {
    IconData iconData;
    
    switch (mealType) {
      case AppConstants.breakfast:
        iconData = Icons.breakfast_dining;
        break;
      case AppConstants.lunch:
        iconData = Icons.lunch_dining;
        break;
      case AppConstants.dinner:
        iconData = Icons.dinner_dining;
        break;
      case AppConstants.snacks:
        iconData = Icons.cookie;
        break;
      default:
        iconData = Icons.restaurant;
    }
    
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: AppTheme.primaryColor,
        size: 16,
      ),
    );
  }
}