import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Nutrition',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'May 15, 2023',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalorieProgress(context),
            const SizedBox(height: 24),
            _buildMacronutrients(context),
            const SizedBox(height: 16),
            _buildMealSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieProgress(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: 0.65, // 65% of daily calorie goal
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  strokeWidth: 8,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '1,300',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Goal: 2,000 kcal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Remaining: 700 kcal',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'re doing great! 65% of your daily goal completed.',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacronutrients(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrients',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNutrientProgress('Carbs', 0.7, '175g', Colors.orange),
            _buildNutrientProgress('Protein', 0.5, '75g', Colors.green),
            _buildNutrientProgress('Fat', 0.6, '45g', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientProgress(String label, double progress, String value, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 6,
                ),
              ),
              Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildMealSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals Today',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        _buildMealItem(AppConstants.breakfast, '420 kcal', 0.8),
        const SizedBox(height: 8),
        _buildMealItem(AppConstants.lunch, '580 kcal', 0.6),
        const SizedBox(height: 8),
        _buildMealItem(AppConstants.dinner, '300 kcal', 0.3),
        const SizedBox(height: 8),
        _buildMealItem(AppConstants.snacks, '0 kcal', 0.0),
      ],
    );
  }

  Widget _buildMealItem(String mealType, String calories, double progress) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            mealType,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            calories,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}