import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../widgets/meditation_session_card.dart';
import '../widgets/meditation_progress_card.dart';
import '../services/meditation_service.dart';
import '../models/meditation_model.dart';
import 'meditation_session_screen.dart';

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
  final MeditationService _meditationService = MeditationService();
  List<MeditationSession> _recentSessions = [];
  List<MeditationProgram> _programs = [];
  MeditationSummary? _userSummary;
  
  @override
  void initState() {
    super.initState();
    // Initialize meditation data
    _initializeMeditationData();
    
    // Listen to meditation data streams
    _meditationService.sessionsStream.listen((sessions) {
      if (mounted) {
        setState(() {
          _recentSessions = _meditationService.getRecentSessions();
        });
      }
    });
    
    _meditationService.programsStream.listen((programs) {
      if (mounted) {
        setState(() {
          _programs = programs;
        });
      }
    });
    
    _meditationService.summaryStream.listen((summary) {
      if (mounted) {
        setState(() {
          _userSummary = summary;
        });
      }
    });
  }
  
  void _initializeMeditationData() {
    // Add sample data if not already added
    if (_meditationService.getAllPrograms().isEmpty) {
      _meditationService.addSamplePrograms();
    }
    
    if (_meditationService.getUserSessions().isEmpty) {
      _meditationService.addSampleSessions();
    }
    
    // Get initial data
    _recentSessions = _meditationService.getRecentSessions();
    _programs = _meditationService.getAllPrograms();
    _userSummary = _meditationService.getUserSummary();
  }
  
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
            MeditationProgressCard(summary: _userSummary),
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
          // Start quick meditation (5-minute breathing exercise)
          _startMeditationSession(
            'Quick Breathing',
            AppConstants.breathingExercises,
            5,
            'A short breathing exercise to calm your mind.',
          );
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
                          _startMeditationSession(
                            'Calm Mind Meditation',
                            AppConstants.guidedMeditation,
                            15,
                            'A guided meditation to calm your mind and reduce stress',
                            'https://via.placeholder.com/400x200',
                          );
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
    // Filter programs based on selected category
    final filteredPrograms = _selectedCategory == 'All'
        ? _programs
        : _programs.where((program) => program.category == _selectedCategory.toLowerCase()).toList();
    
    if (filteredPrograms.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No programs available for this category.'),
        ),
      );
    }
    
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredPrograms.length,
        itemBuilder: (context, index) {
          final program = filteredPrograms[index];
          // Create a MeditationSession from the program for display
          final session = MeditationSession(
            id: program.id,
            userId: 'user123',
            title: program.title,
            category: program.category,
            startTime: DateTime.now(),
            durationInMinutes: program.totalMinutes ~/ program.durationInDays, // Average per day
            imageUrl: program.imageUrl,
            description: program.description,
          );
          
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MeditationSessionCard(
              session: session,
              onTap: () {
                // Show program details
                _showProgramDetails(program);
              },
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildRecentSessions() {
    if (_recentSessions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent sessions. Start meditating to see your history.'),
        ),
      );
    }
    
    // Filter sessions based on selected category
    final filteredSessions = _selectedCategory == 'All'
        ? _recentSessions
        : _recentSessions.where((session) => session.category == _selectedCategory).toList();
    
    if (filteredSessions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No recent sessions for this category.'),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredSessions.length,
      itemBuilder: (context, index) {
        final session = filteredSessions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
            child: Icon(
              Icons.spa,
              color: AppTheme.primaryColor,
            ),
          ),
          title: Text(session.title),
          subtitle: Text('${session.category} • ${session.durationInMinutes} min'),
          trailing: session.isCompleted
              ? const Icon(Icons.check_circle, color: AppTheme.successColor)
              : IconButton(
                  icon: const Icon(Icons.play_circle_filled, color: AppTheme.primaryColor),
                  onPressed: () {
                    // Resume session
                    _startMeditationSession(
                      session.title,
                      session.category,
                      session.durationInMinutes,
                      session.description,
                      session.imageUrl,
                      session.audioUrl,
                    );
                  },
                ),
          onTap: () {
            // Show session details
            _showSessionDetails(session);
          },
        );
      },
    );
  }
  
  void _startMeditationSession(
    String title,
    String category,
    int durationInMinutes,
    String? description,
    [String? imageUrl, String? audioUrl]
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationSessionScreen(
          title: title,
          category: category,
          durationInMinutes: durationInMinutes,
          description: description,
          imageUrl: imageUrl,
          audioUrl: audioUrl,
        ),
      ),
    );
  }
  
  void _showProgramDetails(MeditationProgram program) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Program image
                  if (program.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        program.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  
                  // Program title
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  
                  // Program details
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 4),
                      Text('${program.durationInDays} days'),
                      const SizedBox(width: 16),
                      Icon(Icons.timer, size: 16, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 4),
                      Text('${program.totalMinutes} min total'),
                    ],
                  ),
                  if (program.instructorName != null) ...[  
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 4),
                        Text('Instructor: ${program.instructorName}'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  // Program description
                  Text(
                    program.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  // Start program button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Start the first session of the program
                        _startMeditationSession(
                          'Day 1: ${program.title}',
                          program.category,
                          15, // Default duration for first session
                          'First session of ${program.title} program',
                          program.imageUrl,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Start Program'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _showSessionDetails(MeditationSession session) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text(session.category),
                const SizedBox(width: 16),
                Icon(Icons.timer, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text('${session.durationInMinutes} min'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  '${session.startTime.day}/${session.startTime.month}/${session.startTime.year}',
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            if (session.description != null) ...[  
              const SizedBox(height: 16),
              Text(
                session.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startMeditationSession(
                        session.title,
                        session.category,
                        session.durationInMinutes,
                        session.description,
                        session.imageUrl,
                        session.audioUrl,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: Text(session.isCompleted ? 'Repeat Session' : 'Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}