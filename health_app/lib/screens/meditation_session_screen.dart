import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meditation_model.dart';
import '../services/meditation_service.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class MeditationSessionScreen extends StatefulWidget {
  final String title;
  final String category;
  final int durationInMinutes;
  final String? audioUrl;
  final String? imageUrl;
  final String? description;

  const MeditationSessionScreen({
    super.key,
    required this.title,
    required this.category,
    required this.durationInMinutes,
    this.audioUrl,
    this.imageUrl,
    this.description,
  });

  @override
  State<MeditationSessionScreen> createState() => _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> with TickerProviderStateMixin {
  final MeditationService _meditationService = MeditationService();
  MeditationSession? _activeSession;
  bool _isPlaying = false;
  int _remainingSeconds = 0;
  late AnimationController _progressController;
  
  // Background colors for different meditation categories
  final Map<String, List<Color>> _categoryColors = {
    AppConstants.guidedMeditation: [AppTheme.primaryColor, AppTheme.secondaryColor],
    AppConstants.breathingExercises: [Colors.blue.shade300, Colors.blue.shade700],
    AppConstants.sleepStories: [Colors.indigo.shade300, Colors.indigo.shade700],
    AppConstants.mindfulness: [Colors.teal.shade300, Colors.teal.shade700],
  };

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInMinutes * 60;
    
    // Initialize progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.durationInMinutes),
    );
    
    // Start the meditation session
    _startSession();
  }

  @override
  void dispose() {
    _progressController.dispose();
    // End the session if the screen is closed
    if (_activeSession != null) {
      _meditationService.endSession(completed: false);
    }
    super.dispose();
  }

  void _startSession() {
    _activeSession = _meditationService.startSession(
      title: widget.title,
      category: widget.category,
      durationInMinutes: widget.durationInMinutes,
      audioUrl: widget.audioUrl,
      imageUrl: widget.imageUrl,
      description: widget.description,
    );
    
    setState(() {
      _isPlaying = true;
    });
    
    _progressController.forward(from: 0.0);
    
    // Listen to active session updates
    _meditationService.activeSessionStream.listen((session) {
      if (mounted) {
        setState(() {
          _activeSession = session;
          _remainingSeconds = _meditationService.getRemainingTime();
          
          // If session ended, stop the animation
          if (session == null) {
            _isPlaying = false;
            _progressController.stop();
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _meditationService.pauseSession();
      _progressController.stop();
    } else {
      _meditationService.resumeSession();
      _progressController.forward();
    }
    
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _endSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this meditation session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _meditationService.endSession(completed: false);
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text(AppConstants.confirm),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Get background colors based on category
    final backgroundColors = _categoryColors[widget.category] ?? 
        [AppTheme.primaryColor, AppTheme.secondaryColor];
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _endSession,
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // TODO: Show session settings
                      },
                    ),
                  ],
                ),
              ),
              
              // Session content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Session image
                      if (widget.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.imageUrl!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.spa,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      const SizedBox(height: 40),
                      
                      // Progress indicator
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular progress indicator
                            AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return CircularProgressIndicator(
                                  value: 1.0 - _progressController.value,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                );
                              },
                            ),
                            
                            // Time remaining
                            Text(
                              _formatTime(_remainingSeconds),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Play/pause button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _endSession,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.stop, size: 32),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: _togglePlayPause,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(24),
                              backgroundColor: Colors.white,
                              foregroundColor: backgroundColors[0],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 48,
                            ),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement restart functionality
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.replay, size: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}