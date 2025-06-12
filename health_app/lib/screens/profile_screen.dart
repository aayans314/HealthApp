import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../models/user_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/health_metrics_detail.dart';
import '../widgets/achievements_list.dart';
import '../widgets/goals_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock user data
  final UserProfile _userProfile = UserProfile(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    age: 30,
    height: 175, // cm
    weight: 70, // kg
    gender: 'Male',
    profileImageUrl: 'https://via.placeholder.com/150',
    goals: [],
    achievements: [],
    healthMetrics: HealthMetrics(
      heartRate: 72,
      bloodPressureSystolic: 120,
      bloodPressureDiastolic: 80,
      sleepHours: 7.5,
      bmi: 22.9,
    ),
  );
  
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_userProfile.name),
                background: ProfileHeader(userProfile: _userProfile),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO: Navigate to settings
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  tabs: const [
                    Tab(text: 'Health'),
                    Tab(text: 'Goals'),
                    Tab(text: 'Achievements'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHealthTab(),
            _buildGoalsTab(),
            _buildAchievementsTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(AppConstants.personalInfo),
          const SizedBox(height: 12),
          _buildPersonalInfoCard(),
          const SizedBox(height: 24),
          
          _buildSectionHeader(AppConstants.healthMetrics),
          const SizedBox(height: 12),
          HealthMetricsDetail(healthMetrics: _userProfile.healthMetrics),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Body Measurements'),
          const SizedBox(height: 12),
          _buildBodyMeasurementsCard(),
        ],
      ),
    );
  }
  
  Widget _buildGoalsTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: GoalsList(),
    );
  }
  
  Widget _buildAchievementsTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: AchievementsList(),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
  
  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Name', _userProfile.name),
            const Divider(),
            _buildInfoRow('Email', _userProfile.email),
            const Divider(),
            _buildInfoRow('Age', '${_userProfile.age} years'),
            const Divider(),
            _buildInfoRow('Gender', _userProfile.gender),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBodyMeasurementsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Height', '${_userProfile.height} cm'),
            const Divider(),
            _buildInfoRow('Weight', '${_userProfile.weight} kg'),
            const Divider(),
            _buildInfoRow('BMI', '${_userProfile.calculateBMI().toStringAsFixed(1)} (${_userProfile.getBMICategory()})'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}