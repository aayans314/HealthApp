import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/meditation_session_card.dart';
import '../widgets/meditation_progress_card.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final List<String> _categories = [
    'All',
    AppConstants.guidedMeditation,
    AppConstants.breathingExercises,
    AppConstants.sleepStories,
    AppConstants.mindfulness,
  ];
  
  String _selectedCategory = 'All';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.meditationSessions),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meditation progress
            const MeditationProgressCard(),
            const SizedBox(height: 24),
            
            // Category filter
            _buildCategoryFilter(),
            const SizedBox(height: 24),
            
            // Featured session
            _buildSectionHeader('Featured Session'),
            const SizedBox(height: 12),
            _buildFeaturedSessionCard(),
            const SizedBox(height: 24),
            
            // Recommended sessions
            _buildSectionHeader('Recommended For You'),
            const SizedBox(height: 12),
            _buildRecommendedSessions(),
            const SizedBox(height: 24),
            
            // Recent sessions
            _buildSectionHeader('Recent Sessions'),
            const SizedBox(height: 12),
            _buildRecentSessions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Start quick meditation
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.play_arrow),
        label: const Text(AppConstants.startMeditation),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
  
  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildFeaturedSessionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.network(
                    'https://via.placeholder.com/400x200',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Calm Mind Meditation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A guided meditation to calm your mind and reduce stress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Start featured session
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '15 min',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecommendedSessions() {
    // Mock data for recommended sessions
    final recommendedSessions = [
      {
        'title': 'Morning Mindfulness',
        'duration': '10 min',
        'category': AppConstants.mindfulness,
      },
      {
        'title': 'Deep Breathing',
        'duration': '5 min',
        'category': AppConstants.breathingExercises,
      },
      {
        'title': 'Stress Relief',
        'duration': '15 min',
        'category': AppConstants.guidedMeditation,
      },
    ];
    
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendedSessions.length,
        itemBuilder: (context, index) {
          final session = recommendedSessions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MeditationSessionCard(
              title: session['title'] as String,
              duration: session['duration'] as String,
              category: session['category'] as String,
              onTap: () {
                // TODO: Navigate to session details
              },
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildRecentSessions() {
    // Mock data for recent sessions
    final recentSessions = [
      {
        'title': 'Sleep Story: Ocean Waves',
        'duration': '20 min',
        'category': AppConstants.sleepStories,
        'completed': true,
      },
      {
        'title': 'Anxiety Relief',
        'duration': '15 min',
        'category': AppConstants.guidedMeditation,
        'completed': true,
      },
      {
        'title': 'Body Scan Relaxation',
        'duration': '10 min',
        'category': AppConstants.mindfulness,
        'completed': false,
      },
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentSessions.length,
      itemBuilder: (context, index) {
        final session = recentSessions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
            child: Icon(
              Icons.spa,
              color: AppTheme.primaryColor,
            ),
          ),
          title: Text(session['title'] as String),
          subtitle: Text('${session['category']} • ${session['duration']}'),
          trailing: (session['completed'] as bool)
              ? const Icon(Icons.check_circle, color: AppTheme.successColor)
              : IconButton(
                  icon: const Icon(Icons.play_circle_filled, color: AppTheme.primaryColor),
                  onPressed: () {
                    // TODO: Resume session
                  },
                ),
          onTap: () {
            // TODO: Navigate to session details
          },
        );
      },
    );
  }
}