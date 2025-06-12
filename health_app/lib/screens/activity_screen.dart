import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/activity_stats_card.dart';
import '../widgets/activity_history_list.dart';
import '../widgets/activity_type_selector.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedActivityType = 'walking'; // Default activity type
  bool _isActivityInProgress = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text(AppConstants.activityTracking),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Track'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrackTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }
  
  Widget _buildTrackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity type selector
          ActivityTypeSelector(
            selectedType: _selectedActivityType,
            onActivitySelected: (type) {
              setState(() {
                _selectedActivityType = type;
              });
            },
          ),
          const SizedBox(height: 24),
          
          // Current activity stats
          const ActivityStatsCard(),
          const SizedBox(height: 24),
          
          // Start/Stop button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isActivityInProgress = !_isActivityInProgress;
                });
                // TODO: Start or stop activity tracking
              },
              icon: Icon(_isActivityInProgress ? Icons.stop : Icons.play_arrow),
              label: Text(_isActivityInProgress ? AppConstants.stopActivity : AppConstants.startActivity),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isActivityInProgress ? AppTheme.errorColor : AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Activity details form (only shown when not in progress)
          if (!_isActivityInProgress) _buildActivityDetailsForm(),
        ],
      ),
    );
  }
  
  Widget _buildActivityDetailsForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Details',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Activity Name',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Intensity',
                prefixIcon: Icon(Icons.speed),
              ),
              items: ['Low', 'Medium', 'High'].map((String intensity) {
                return DropdownMenuItem<String>(
                  value: intensity,
                  child: Text(intensity),
                );
              }).toList(),
              onChanged: (String? value) {
                // TODO: Handle intensity change
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Goal (optional)',
                prefixIcon: Icon(Icons.flag),
                hintText: 'e.g., 5000 steps or 30 minutes',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHistoryTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity History'),
          SizedBox(height: 16),
          Expanded(
            child: ActivityHistoryList(),
          ),
        ],
      ),
    );
  }
}