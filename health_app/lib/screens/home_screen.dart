import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/activity_summary_card.dart';
import '../widgets/health_metrics_card.dart';
import '../widgets/upcoming_goals_card.dart';
import '../widgets/recent_activities_card.dart';
import '../widgets/health_tips_card.dart';
import '../widgets/notification_badge.dart';
import '../services/notification_service.dart';
import '../screens/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: NotificationBadge(
                  notificationService: _notificationService,
                  size: 18.0,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                '${AppConstants.welcomeMessage}, User!',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s check your health status today',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              
              // Today's Stats
              _buildSectionHeader(context, AppConstants.todayStats),
              const SizedBox(height: 12),
              const ActivitySummaryCard(),
              const SizedBox(height: 16),
              const HealthMetricsCard(),
              const SizedBox(height: 24),
              
              // Upcoming Goals
              _buildSectionHeader(context, AppConstants.upcomingGoals),
              const SizedBox(height: 12),
              const UpcomingGoalsCard(),
              const SizedBox(height: 24),
              
              // Recent Activities
              _buildSectionHeader(context, AppConstants.recentActivities),
              const SizedBox(height: 12),
              const RecentActivitiesCard(),
              const SizedBox(height: 24),
              
              // Health Tips
              _buildSectionHeader(context, AppConstants.healthTips),
              const SizedBox(height: 12),
              const HealthTipsCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to detailed view
          },
          child: const Text('See All'),
        ),
      ],
    );
  }
}