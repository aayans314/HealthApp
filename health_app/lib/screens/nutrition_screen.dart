import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/nutrition_summary_card.dart';
import '../widgets/water_intake_tracker.dart';
import '../widgets/meal_list.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.mealPlanning),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Meals'),
            Tab(text: 'Water'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildMealsTab(),
          _buildWaterTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptionsBottomSheet(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nutrition summary card
          const NutritionSummaryCard(),
          const SizedBox(height: 24),
          
          // Macronutrient breakdown
          _buildSectionHeader('Macronutrient Breakdown'),
          const SizedBox(height: 12),
          _buildMacronutrientChart(),
          const SizedBox(height: 24),
          
          // Calorie breakdown by meal
          _buildSectionHeader('Calories by Meal'),
          const SizedBox(height: 12),
          _buildCaloriesByMealChart(),
          const SizedBox(height: 24),
          
          // Water intake summary
          _buildSectionHeader(AppConstants.waterIntake),
          const SizedBox(height: 12),
          const WaterIntakeTracker(compact: true),
        ],
      ),
    );
  }
  
  Widget _buildMealsTab() {
    return Column(
      children: [
        // Date selector
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // TODO: Go to previous day
                },
              ),
              const Text(
                'Today, June 12',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // TODO: Go to next day
                },
              ),
            ],
          ),
        ),
        
        // Meal list
        const Expanded(
          child: MealList(),
        ),
      ],
    );
  }
  
  Widget _buildWaterTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstants.waterIntake,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          
          // Water intake tracker
          const WaterIntakeTracker(),
          const SizedBox(height: 24),
          
          // Quick add buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAddWaterButton(100, '100ml'),
              _buildQuickAddWaterButton(250, '250ml'),
              _buildQuickAddWaterButton(500, '500ml'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Custom amount
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom Amount',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Amount (ml)',
                            prefixIcon: Icon(Icons.water_drop),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add custom water amount
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAddWaterButton(int amount, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Add water amount
      },
      icon: const Icon(Icons.add),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
  
  Widget _buildMacronutrientChart() {
    // TODO: Implement actual chart
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroLegendItem('Protein', AppTheme.primaryColor),
                _buildMacroLegendItem('Carbs', AppTheme.secondaryColor),
                _buildMacroLegendItem('Fat', AppTheme.accentColor),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Macronutrient chart will be displayed here'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMacroLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
  
  Widget _buildCaloriesByMealChart() {
    // TODO: Implement actual chart
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Center(
        child: Text('Calories by meal chart will be displayed here'),
      ),
    );
  }
  
  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.breakfast_dining, color: AppTheme.primaryColor),
                title: const Text(AppConstants.breakfast),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add breakfast screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.lunch_dining, color: AppTheme.primaryColor),
                title: const Text(AppConstants.lunch),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add lunch screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.dinner_dining, color: AppTheme.primaryColor),
                title: const Text(AppConstants.dinner),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add dinner screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.cookie, color: AppTheme.primaryColor),
                title: const Text(AppConstants.snacks),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to add snack screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop, color: AppTheme.secondaryColor),
                title: const Text(AppConstants.waterIntake),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(2); // Switch to water tab
                },
              ),
            ],
          ),
        );
      },
    );
  }
}